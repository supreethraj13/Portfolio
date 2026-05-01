import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> fetchProjects();
  Future<Map<String, dynamic>?> fetchProfile();

  Future<void> submitLead(Map<String, dynamic> leadPayload);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  const ProjectRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ProjectModel>> fetchProjects() async {
    final snapshot = await _firestore.collection('projects').get();
    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Map<String, dynamic>?> fetchProfile() async {
    final snapshot = await _firestore
        .collection('portfolio')
        .doc('profile')
        .get();
    return snapshot.data();
  }

  @override
  Future<void> submitLead(Map<String, dynamic> leadPayload) async {
    final email = leadPayload['email'];
    if (email is! String) {
      throw ArgumentError.value(email, 'email', 'Email is required');
    }

    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw ArgumentError.value(email, 'email', 'Email is required');
    }

    final now = DateTime.now().toUtc();
    final hourBucket =
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}';
    final rateLimitKey = sha256
        .convert(utf8.encode('$hourBucket|$normalizedEmail'))
        .toString();
    final rateLimitRef = _firestore
        .collection('lead_rate_limits')
        .doc(rateLimitKey);
    final leadRef = _firestore.collection('leads').doc();
    final batch = _firestore.batch();

    batch.set(rateLimitRef, {
      'email': normalizedEmail,
      'windowCount': FieldValue.increment(1),
      'bucket': hourBucket,
      'bucketStartedAt': Timestamp.fromDate(
        DateTime.utc(now.year, now.month, now.day, now.hour),
      ),
      'bucketExpiresAt': Timestamp.fromDate(
        DateTime.utc(now.year, now.month, now.day, now.hour + 1),
      ),
      'lastSentAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    batch.set(leadRef, {
      ...leadPayload,
      'email': normalizedEmail,
      'rateLimitKey': rateLimitKey,
      'createdAt': FieldValue.serverTimestamp(),
    });

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'rate-limit-exceeded',
          message: 'Please wait before sending more messages.',
        );
      }
      rethrow;
    }
  }
}

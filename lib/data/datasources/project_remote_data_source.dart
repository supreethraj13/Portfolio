import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> submitLead(Map<String, dynamic> leadPayload) {
    return _firestore.collection('leads').add(leadPayload);
  }
}

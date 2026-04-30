import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lead_message.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl({
    required ProjectRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ProjectRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProjectEntity>> getProjects() {
    return _remoteDataSource.fetchProjects();
  }

  @override
  Future<void> submitLead(LeadMessage lead) {
    return _remoteDataSource.submitLead({
      'name': lead.name,
      'email': lead.email,
      'message': lead.message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

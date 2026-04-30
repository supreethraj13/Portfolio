import '../entities/lead_message.dart';
import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();
  Future<Map<String, dynamic>?> getProfile();

  Future<void> submitLead(LeadMessage lead);
}

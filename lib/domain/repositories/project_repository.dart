import '../entities/lead_message.dart';
import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();

  Future<void> submitLead(LeadMessage lead);
}

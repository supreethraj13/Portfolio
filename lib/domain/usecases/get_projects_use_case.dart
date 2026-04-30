import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  const GetProjectsUseCase(this._repository);

  final ProjectRepository _repository;

  Future<List<ProjectEntity>> call() {
    return _repository.getProjects();
  }
}

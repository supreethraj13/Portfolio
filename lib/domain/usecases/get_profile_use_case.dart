import '../repositories/project_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Map<String, dynamic>?> call() {
    return _repository.getProfile();
  }
}

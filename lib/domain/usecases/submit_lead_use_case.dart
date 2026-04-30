import '../entities/lead_message.dart';
import '../repositories/project_repository.dart';

class SubmitLeadUseCase {
  const SubmitLeadUseCase(this._repository);

  final ProjectRepository _repository;

  Future<void> call(LeadMessage lead) {
    return _repository.submitLead(lead);
  }
}

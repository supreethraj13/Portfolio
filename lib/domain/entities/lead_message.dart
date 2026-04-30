import 'package:equatable/equatable.dart';

class LeadMessage extends Equatable {
  const LeadMessage({
    required this.name,
    required this.email,
    required this.message,
  });

  final String name;
  final String email;
  final String message;

  @override
  List<Object?> get props => [name, email, message];
}

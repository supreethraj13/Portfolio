import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

class ProjectLoaded extends ProjectState {
  const ProjectLoaded(this.projects);

  final List<ProjectEntity> projects;

  @override
  List<Object?> get props => [projects];
}

class ProjectError extends ProjectState {
  const ProjectError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

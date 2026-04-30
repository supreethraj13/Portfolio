import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_projects_use_case.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({
    required GetProjectsUseCase getProjectsUseCase,
    required FirebaseAnalytics analytics,
  }) : _getProjectsUseCase = getProjectsUseCase,
       _analytics = analytics,
       super(const ProjectInitial()) {
    on<LoadProjects>(_onLoadProjects);
  }

  final GetProjectsUseCase _getProjectsUseCase;
  final FirebaseAnalytics _analytics;

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectLoading());
    try {
      final projects = await _getProjectsUseCase.call();
      emit(ProjectLoaded(projects));
      await _analytics.logEvent(
        name: 'projects_loaded',
        parameters: {'count': projects.length},
      );
    } catch (error) {
      emit(ProjectError('Unable to load projects: $error'));
    }
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/project_remote_data_source.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/get_projects_use_case.dart';
import '../../domain/usecases/submit_lead_use_case.dart';
import '../../presentation/bloc/project_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (getIt.isRegistered<ProjectBloc>()) {
    return;
  }

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseAnalytics>(
    () => FirebaseAnalytics.instance,
  );

  getIt.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: getIt<ProjectRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetProjectsUseCase>(
    () => GetProjectsUseCase(getIt<ProjectRepository>()),
  );
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<ProjectRepository>()),
  );

  getIt.registerLazySingleton<SubmitLeadUseCase>(
    () => SubmitLeadUseCase(getIt<ProjectRepository>()),
  );

  getIt.registerFactory<ProjectBloc>(
    () => ProjectBloc(
      getProjectsUseCase: getIt<GetProjectsUseCase>(),
      analytics: getIt<FirebaseAnalytics>(),
    ),
  );
}

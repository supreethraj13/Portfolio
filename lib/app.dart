import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'presentation/bloc/project_bloc.dart';
import 'presentation/bloc/project_event.dart';
import 'presentation/pages/portfolio_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Developer Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => getIt<ProjectBloc>()..add(const LoadProjects()),
        child: const PortfolioPage(),
      ),
    );
  }
}

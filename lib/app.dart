import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'presentation/bloc/project_bloc.dart';
import 'presentation/bloc/project_event.dart';
import 'presentation/bloc/theme_bloc.dart';
import 'presentation/bloc/theme_event.dart';
import 'presentation/bloc/theme_state.dart';
import 'presentation/pages/portfolio_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
          create: (_) => getIt<ProjectBloc>()..add(const LoadProjects()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Developer Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            themeAnimationDuration: const Duration(milliseconds: 420),
            themeAnimationCurve: Curves.easeInOutCubicEmphasized,
            home: PortfolioPage(
              isDarkMode: themeState.isDarkMode,
              onToggleTheme: () =>
                  context.read<ThemeBloc>().add(const ToggleThemeRequested()),
            ),
          );
        },
      ),
    );
  }
}

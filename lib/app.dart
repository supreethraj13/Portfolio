import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/project_bloc.dart';
import 'presentation/bloc/project_event.dart';
import 'presentation/pages/portfolio_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProjectBloc>()..add(const LoadProjects()),
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) {
          return Builder(
            builder: (context) {
              final mode = AdaptiveTheme.of(context).mode;
              final themeMode = mode == AdaptiveThemeMode.dark
                  ? ThemeMode.dark
                  : mode == AdaptiveThemeMode.light
                  ? ThemeMode.light
                  : ThemeMode.system;
              return MaterialApp(
                title: 'Developer Portfolio',
                debugShowCheckedModeBanner: false,
                theme: theme,
                darkTheme: darkTheme,
                themeMode: themeMode,
                themeAnimationDuration: const Duration(milliseconds: 260),
                themeAnimationCurve: Curves.easeOutCubic,
                home: const PortfolioPage(),
              );
            },
          );
        },
      ),
    );
  }
}

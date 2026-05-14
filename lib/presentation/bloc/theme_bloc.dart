import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.dark)) {
    on<ToggleThemeRequested>(_onToggleThemeRequested);
  }

  void _onToggleThemeRequested(
    ToggleThemeRequested event,
    Emitter<ThemeState> emit,
  ) {
    emit(
      state.copyWith(
        themeMode: state.isDarkMode ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }
}

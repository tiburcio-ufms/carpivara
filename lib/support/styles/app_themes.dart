import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.lightGray),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import 'support/styles/app_themes.dart';
import 'support/utils/carpivara_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Carpivara',
      theme: AppThemes.theme,
      routerConfig: CarpivaraRouter.config,
    );
  }
}

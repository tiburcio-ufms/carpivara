import 'package:flutter/material.dart';

import 'support/config/env_config.dart';
import 'support/styles/app_themes.dart';
import 'support/utils/carpivara_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  runApp(const MyApp());
}

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

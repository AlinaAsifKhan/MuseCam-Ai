import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MuseCamAI extends StatelessWidget {
  const MuseCamAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MuseCam AI',
      debugShowCheckedModeBanner: false,
      theme: MuseAppTheme.darkTheme,
      routerConfig: AppRouter.createRouter(),
    );
  }
}

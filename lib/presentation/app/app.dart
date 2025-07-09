import 'package:brasil_card/presentation/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/config/app_config.dart';
import '../../core/router/app_router.dart';

class BrasilCriptoApp extends StatelessWidget {
  const BrasilCriptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Permitir apenas orientação retrato
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Aplicar escala de texto responsiva
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).size.width < 360 ? 0.8 : 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}

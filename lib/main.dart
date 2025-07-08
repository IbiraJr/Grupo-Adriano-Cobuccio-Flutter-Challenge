import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'core/config/app_config.dart';
import 'presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize app config
  await AppConfig.init();

  runApp(const ProviderScope(child: BrasilCriptoApp()));
}

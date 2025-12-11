import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/observers/app_bloc_observer.dart';
import 'core/logging/app_logger.dart';
import 'app/app.dart';

Future<void> bootstrap(Environment environment) async {
  // Ensure Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // تقييد اتجاه التطبيق على الوضع العمودي فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure dependencies (AppConfig + DI)
  await configureDependencies(environment);

  // Setup BLoC observer
  Bloc.observer = AppBlocObserver();

  // Initialize logger
  AppLogger.init(environment);
  AppLogger.i(
    'App initialized - ${AppConfig.appName} v${AppConfig.fullVersion}',
    tag: 'Bootstrap',
  );

  // Run app
  runApp(const SahoolApp());
}
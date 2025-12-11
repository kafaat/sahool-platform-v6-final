import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(Environment environment) async {
  // إعداد البيئة
  AppConfig.initialize(environment);

  // External
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  // Network
  final dio = DioClient.createDio();
  dio.interceptors.add(AuthInterceptor(storage: secureStorage));
  getIt.registerSingleton<Dio>(dio);
}
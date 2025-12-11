import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../data/auth_repository.dart';
import '../../../fields/sync/field_sync_service.dart';

/// ==== Events ====
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

/// ==== States ====
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated({required this.user});

  final Map<String, dynamic> user;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  AuthFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==== BLoC ====
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : _authRepository = AuthRepository(),
        _secureStorage = getIt<FlutterSecureStorage>(),
        _prefs = getIt<SharedPreferences>(),
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    if (token == null || token.isEmpty) {
      emit(AuthUnauthenticated());
      return;
    }

    // حاول قراءة المستخدم من التخزين أولاً
    Map<String, dynamic>? userFromCache;
    final rawUser = _prefs.getString(AppConstants.userKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUser) as Map<String, dynamic>;
        userFromCache = decoded;
      } catch (_) {
        userFromCache = null;
      }
    }

    if (userFromCache != null) {
      emit(AuthAuthenticated(user: userFromCache));
    }

    try {
      final user = await _authRepository.getCurrentUser();
      await _prefs.setString(AppConstants.userKey, jsonEncode(user));
      emit(AuthAuthenticated(user: user));

      // بعد التأكد من أن المستخدم مصادق، نقوم بمحاولة مزامنة الحقول Offline
      final syncService = FieldSyncService();
      await syncService.syncOfflineCreations();
    } catch (_) {
      // إذا فشلنا في جلب المستخدم، نعتبر الجلسة منتهية
      await _secureStorage.delete(key: AppConstants.accessTokenKey);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final tokenPayload = await _authRepository.login(
        username: event.email,
        password: event.password,
      );

      final accessToken = tokenPayload['access_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        emit(AuthFailure('فشل تسجيل الدخول: لم يتم استرجاع توكن صالح.'));
        return;
      }

      await _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );

      // جلب بيانات المستخدم
      final user = await _authRepository.getCurrentUser();
      await _prefs.setString(AppConstants.userKey, jsonEncode(user));
      final tenantId = user['tenant_id'];
      if (tenantId is int) {
        await _prefs.setInt(AppConstants.tenantIdKey, tenantId);
      }

      emit(AuthAuthenticated(user: user));

      // مزامنة الحقول Offline -> Online بعد تسجيل الدخول مباشرة
      final syncService = FieldSyncService();
      await syncService.syncOfflineCreations();
    } catch (e) {
      emit(AuthFailure('فشل تسجيل الدخول. تأكد من البريد/كلمة المرور أو من الاتصال.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
    await _prefs.remove(AppConstants.userKey);
    emit(AuthUnauthenticated());
  }
}
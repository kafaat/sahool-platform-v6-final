import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page_v2.dart';
import '../../features/fields/presentation/pages/fields_page.dart';
import '../../features/fields/presentation/pages/field_create_wizard_page.dart';
import '../../features/fields/presentation/pages/field_hub_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/weather/presentation/pages/weather_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../features/ndvi/presentation/pages/ndvi_map_page.dart';
import '../widgets/common/main_scaffold.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      
      // Auth
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      
      // Main App Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: Routes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: Routes.dashboardV2,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPageV2(),
            ),
          ),
          GoRoute(
            path: Routes.fields,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FieldsPage(),
            ),
          ),
          GoRoute(
            path: Routes.addField,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FieldCreateWizardPage(),
            ),
          ),
          GoRoute(
            path: Routes.fieldHub,
            pageBuilder: (context, state) {
              final qp = state.uri.queryParameters;
              return NoTransitionPage(
                child: FieldHubPage.fromQuery(qp),
              );
            },
          ),
          GoRoute(
            path: Routes.tasks,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TasksPage(),
            ),
          ),
          GoRoute(
            path: Routes.weather,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WeatherPage(),
            ),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
          GoRoute(
            path: Routes.aiChat,
            pageBuilder: (context, state) {
              final extra = state.extra;
              final fieldContext =
                  extra is Map<String, dynamic> ? extra : <String, dynamic>{};
              return NoTransitionPage(
                child: AiAssistantPage(fieldContext: fieldContext),
              );
            },
          ),
          GoRoute(
            path: Routes.ndviMap,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NdviMapPage(),
            ),
          ),
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('الصفحة غير موجودة', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.dashboard),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
}

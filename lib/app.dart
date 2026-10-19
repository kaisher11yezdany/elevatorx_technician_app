import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/home/my_jobs_screen.dart';
import 'screens/home/profile_screen.dart';
import 'screens/home/maintenance_screen.dart';
import 'screens/home/breakdown_screen.dart';
import 'screens/home/reports_screen.dart';
import 'screens/home/scan_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      redirect: _handleRedirect,
      routes: _buildRoutes(),
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authProvider = context.watch<AuthProvider>();
    final isLoggingIn = state.matchedLocation == '/login';

    if (!authProvider.isAuthenticated) {
      return isLoggingIn ? null : '/login';
    }

    if (isLoggingIn) {
      return '/home';
    }

    return null;
  }

  List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'my-jobs',
            name: 'my-jobs',
            builder: (context, state) => const MyJobsScreen(),
          ),
          GoRoute(
            path: 'maintenance',
            name: 'maintenance',
            builder: (context, state) => const MaintenanceScreen(),
          ),
          GoRoute(
            path: 'breakdown',
            name: 'breakdown',
            builder: (context, state) => const BreakdownScreen(),
          ),
          GoRoute(
            path: 'reports',
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: 'scan',
            name: 'scan',
            builder: (context, state) => const ScanScreen(),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'elevatorX Technician',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Segoe UI',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 1,
          centerTitle: false,
          titleTextStyle: AppTextStyles.h4,
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

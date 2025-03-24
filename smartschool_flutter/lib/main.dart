import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartschool_flutter/core/api/api_client.dart';
import 'package:smartschool_flutter/core/config/api_config.dart';
import 'package:smartschool_flutter/core/utils/user_roles.dart';
import 'providers/auth_provider.dart';
import 'providers/parent_provider.dart';
import 'core/services/auth_service.dart';
import 'services/parent_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/parent/parent_dashboard.dart';
import 'screens/shared/loading_screen.dart';
import 'screens/shared/no_access_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and config
  final apiConfig = ApiConfig();
  final apiClient = ApiClient(apiConfig: apiConfig);
  final authService = AuthService(apiConfig, apiClient);
  final parentService = ParentService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ParentProvider>(
          create: (context) => ParentProvider(
            parentService,
            context.read<AuthProvider>(),
          ),
          update: (context, auth, previous) =>
              previous ?? ParentProvider(parentService, auth),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'SmartSchool',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.blue,
              secondary: Colors.orange,
            ),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: authProvider.isLoading
              ? const LoadingScreen()
              : _handleAuthState(authProvider),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/admin/dashboard': (context) => const AdminDashboard(),
            '/teacher/dashboard': (context) => const TeacherDashboard(),
            '/parent/dashboard': (context) => const ParentDashboard(),
            '/no-access': (context) => const NoAccessScreen(),
          },
        );
      },
    );
  }

  Widget _handleAuthState(AuthProvider authProvider) {
    if (!authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    // Redirect based on user role
    switch (authProvider.userRole) {
      case UserRole.super_admin:
      case UserRole.admin:
        return const AdminDashboard();
      case UserRole.teacher:
        return const TeacherDashboard();
      case UserRole.parent:
        return const ParentDashboard();
      default:
        return const NoAccessScreen();
    }
  }
}

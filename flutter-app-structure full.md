# SmartSchool Flutter App Structure

## 1. Project Organization

### Core Directory Structure
```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── theme_config.dart
│   ├── constants/
│   │   ├── api_paths.dart
│   │   ├── app_constants.dart
│   │   └── enums.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   └── navigation_service.dart
│   └── utils/
│       ├── validators.dart
│       └── formatters.dart
├── features/
│   ├── auth/
│   ├── student/
│   ├── academic/
│   ├── staff/
│   └── admin/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── providers/
└── main.dart
```

## 2. Feature Modules

### Authentication Module
```
features/auth/
├── models/
│   └── user_model.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── login_screen.dart
│   └── profile_screen.dart
└── widgets/
    └── role_based_wrapper.dart
```

### Student Module
```
features/student/
├── models/
│   ├── student_record.dart
│   ├── attendance.dart
│   └── exam_record.dart
├── providers/
│   └── student_provider.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── attendance_screen.dart
│   └── exam_results_screen.dart
└── widgets/
    ├── attendance_card.dart
    └── result_card.dart
```

### Academic Module
```
features/academic/
├── models/
│   ├── class_model.dart
│   ├── subject_model.dart
│   └── timetable_model.dart
├── providers/
│   └── academic_provider.dart
├── screens/
│   ├── class_list_screen.dart
│   ├── subject_screen.dart
│   └── timetable_screen.dart
└── widgets/
    ├── class_card.dart
    └── timetable_grid.dart
```

### Staff Module
```
features/staff/
├── models/
│   ├── staff_record.dart
│   └── teacher_attendance.dart
├── providers/
│   └── staff_provider.dart
├── screens/
│   ├── staff_dashboard.dart
│   └── attendance_management.dart
└── widgets/
    └── staff_profile_card.dart
```

### Admin Module
```
features/admin/
├── models/
│   ├── payment_record.dart
│   └── system_settings.dart
├── providers/
│   └── admin_provider.dart
├── screens/
│   ├── admin_dashboard.dart
│   ├── user_management.dart
│   └── settings_screen.dart
└── widgets/
    ├── stats_card.dart
    └── user_list_item.dart
```

## 3. Core Components

### Models
```dart
// user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  
  // Constructor and JSON serialization
}

// student_record.dart
class StudentRecord {
  final String id;
  final String admissionNumber;
  final String className;
  final List<ExamRecord> examRecords;
  
  // Constructor and JSON serialization
}
```

### Services
```dart
// api_service.dart
class ApiService {
  final String baseUrl;
  final Map<String, String> headers;
  
  Future<T> get<T>(String endpoint);
  Future<T> post<T>(String endpoint, Map<String, dynamic> data);
  Future<T> put<T>(String endpoint, Map<String, dynamic> data);
  Future<void> delete(String endpoint);
}

// auth_service.dart
class AuthService {
  Future<User> login(String identity, String password);
  Future<void> logout();
  Future<bool> checkAuthStatus();
  Future<String> getUserRole();
}
```

### Providers
```dart
// auth_provider.dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  
  Future<void> login(String identity, String password);
  Future<void> logout();
  bool hasRole(List<String> roles);
}

// student_provider.dart
class StudentProvider extends ChangeNotifier {
  List<StudentRecord> _students = [];
  
  Future<void> fetchStudents();
  Future<void> addStudent(StudentRecord student);
  Future<void> updateStudent(StudentRecord student);
}
```

## 4. State Management

### Using Provider/Riverpod
```dart
// main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AcademicProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

## 5. Navigation

### Route Management
```dart
// routes.dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      // Add more routes
    }
  }
}
```

## 6. Theme and Styling

### Theme Configuration
```dart
// theme_config.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    // Define your theme
  );
  
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    // Define dark theme
  );
}
```

## 7. API Integration

### API Constants
```dart
// api_paths.dart
class ApiPaths {
  static const String baseUrl = 'https://api.smartschool.com';
  static const String login = '/api/login';
  static const String students = '/api/students';
  static const String classes = '/api/classes';
  // Add more endpoints
}
```

## 8. Security Implementation

### Secure Storage
```dart
// storage_service.dart
class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}
```

## 9. Error Handling

### Error Models
```dart
// error_model.dart
class ApiError {
  final String message;
  final int statusCode;
  final String? details;
  
  // Constructor and handling methods
}
```

## 10. Middleware Implementation

### Role-Based Access
```dart
// middleware/role_middleware.dart
class RoleMiddleware {
  static Widget protect(Widget child, List<String> allowedRoles) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.hasRole(allowedRoles)) {
          return AccessDeniedScreen();
        }
        return child;
      },
    );
  }
}
```

## 11. Implementation Steps

1. **Setup Project**
   - Create new Flutter project
   - Set up dependencies in pubspec.yaml
   - Configure project structure

2. **Core Implementation**
   - Implement API service
   - Set up authentication
   - Create base models

3. **Feature Implementation**
   - Start with authentication
   - Add student management
   - Implement academic features
   - Add administrative features

4. **Testing**
   - Unit tests for services
   - Widget tests for UI
   - Integration tests for workflows

5. **Deployment**
   - Configure build settings
   - Prepare release versions
   - Deploy to stores

## 12. Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^0.13.0
  shared_preferences: ^2.0.0
  flutter_secure_storage: ^5.0.0
  intl: ^0.17.0
  cached_network_image: ^3.0.0
  # Add more dependencies as needed
```

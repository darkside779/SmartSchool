# SmartSchool Parent App Structure

## Project Structure
```
lib/
├── main.dart
├── config/
│   ├── app_config.dart
│   ├── theme.dart
│   └── routes.dart
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   └── app_constants.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── data/
│   ├── models/
│   │   ├── user.dart
│   │   ├── student.dart
│   │   ├── exam_result.dart
│   │   ├── attendance.dart
│   │   └── payment.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── student_repository.dart
│   │   └── payment_repository.dart
│   └── providers/
│       ├── auth_provider.dart
│       └── student_provider.dart
└── features/
    ├── auth/
    │   ├── screens/
    │   │   ├── login_screen.dart
    │   │   └── forgot_password_screen.dart
    │   └── widgets/
    │       └── login_form.dart
    ├── dashboard/
    │   ├── screens/
    │   │   └── dashboard_screen.dart
    │   └── widgets/
    │       ├── children_list.dart
    │       └── quick_actions.dart
    ├── children/
    │   ├── screens/
    │   │   ├── children_list_screen.dart
    │   │   └── child_detail_screen.dart
    │   └── widgets/
    │       ├── child_card.dart
    │       └── academic_info.dart
    ├── academics/
    │   ├── screens/
    │   │   ├── exam_results_screen.dart
    │   │   └── attendance_screen.dart
    │   └── widgets/
    │       ├── result_card.dart
    │       └── attendance_calendar.dart
    └── payments/
        ├── screens/
        │   ├── payments_screen.dart
        │   └── payment_history_screen.dart
        └── widgets/
            ├── payment_card.dart
            └── payment_form.dart
```

## Key Features

### 1. Authentication
- Login with email/username and password
- Forgot password functionality
- Secure token storage
- Auto-login capability

### 2. Dashboard
- Quick overview of children
- Recent activities
- Important notifications
- Quick action buttons

### 3. Children Management
- List of all children
- Detailed profile for each child
- Academic performance tracking
- Attendance records
- Behavior reports

### 4. Academic Monitoring
- Exam results and grades
- Class schedule
- Homework assignments
- Teacher comments
- Progress reports

### 5. Attendance Tracking
- Daily attendance status
- Monthly attendance overview
- Absence justification submission
- Attendance history

### 6. Financial Management
- Fee payment status
- Payment history
- Online payment processing
- Fee structure view
- Receipt downloads

### 7. Communication
- Direct messaging with teachers
- View school announcements
- Event calendar
- Document sharing

## Technical Implementation

### 1. State Management
```dart
// Using Provider for state management
class ChildrenProvider extends ChangeNotifier {
  List<Student> _children = [];
  
  Future<void> fetchChildren() async {
    final children = await StudentRepository().getChildren();
    _children = children;
    notifyListeners();
  }
}
```

### 2. API Integration
```dart
// API service setup
class ApiService {
  final String baseUrl = 'https://your-school-domain.com/api';
  final String token;

  Future<List<Student>> getChildren() async {
    final response = await http.get(
      Uri.parse('$baseUrl/parent/children'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // Handle response
  }
}
```

### 3. Models
```dart
// Student model
class Student {
  final int id;
  final String name;
  final String admissionNumber;
  final String className;
  final String section;
  
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      admissionNumber: json['adm_no'],
      className: json['class_name'],
      section: json['section'],
    );
  }
}
```

### 4. Authentication
```dart
// Auth service
class AuthService {
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'identity': username, 'password': password},
      );
      // Handle response and token storage
    } catch (e) {
      // Handle errors
    }
  }
}
```

### 5. Local Storage
```dart
// Storage service for caching
class StorageService {
  Future<void> cacheChildren(List<Student> children) async {
    final box = await Hive.openBox('children');
    await box.put('children_list', children);
  }
}
```

## API Endpoints Documentation

### Authentication Endpoints
```
POST /api/login
- Purpose: Authenticate parent user
- Parameters: 
  - identity (email or username)
  - password
- Returns: 
  - user data
  - Bearer token
  - token type

POST /api/logout (Protected)
- Purpose: Logout user
- Headers: Bearer token
- Returns: Success message

GET /api/me (Protected)
- Purpose: Get authenticated user details
- Headers: Bearer token
- Returns: User data
```

### Parent Endpoints
All these endpoints require authentication and parent middleware

#### Children Management
```
GET /api/parent/children
- Purpose: Get list of parent's children
- Returns: Array of children with:
  - Basic information
  - Class details
  - Section details

GET /api/parent/children/{id}
- Purpose: Get detailed information about a specific child
- Parameters: child_id
- Returns: 
  - Child's complete profile
  - Class information
  - Section information
  - Dormitory details

GET /api/parent/children/{id}/results
- Purpose: Get child's exam results
- Parameters: 
  - child_id
  - year (optional, defaults to current session)
- Returns: 
  - Exam results
  - Subject details

GET /api/parent/children/{id}/attendance
- Purpose: Get child's attendance records
- Parameters: 
  - child_id
  - month (optional, defaults to current month)
  - year (optional, defaults to current year)
- Returns: Attendance records for specified period
```

#### Financial Management
```
GET /api/parent/payments
- Purpose: Get payment history
- Returns: 
  - List of payments
  - Payment details
  - Associated student information
```

### Error Responses
All endpoints follow this error format:
```json
{
    "status": false,
    "message": "Error message",
    "errors": {
        "field": ["Error details"]
    }
}
```

Common HTTP Status Codes:
- 200: Success
- 401: Unauthorized (invalid/expired token)
- 403: Forbidden (not a parent or not child's parent)
- 422: Validation error
- 500: Server error

## Required Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^0.13.0
  shared_preferences: ^2.0.0
  hive: ^2.0.0
  intl: ^0.17.0
  flutter_secure_storage: ^5.0.0
  cached_network_image: ^3.0.0
  flutter_calendar_carousel: ^2.0.0
  pdf: ^3.0.0
  url_launcher: ^6.0.0
```

## Security Considerations

1. **Token Management**
   - Secure token storage using flutter_secure_storage
   - Token refresh mechanism
   - Auto logout on token expiration

2. **Data Security**
   - Encryption for sensitive data
   - Secure API communication
   - Input validation

3. **Error Handling**
   - Graceful error messages
   - Offline support
   - API error handling

## Testing Strategy

1. **Unit Tests**
   - Model tests
   - Repository tests
   - Service tests

2. **Widget Tests**
   - Screen tests
   - Component tests
   - Navigation tests

3. **Integration Tests**
   - API integration tests
   - End-to-end flows
   - Authentication flows

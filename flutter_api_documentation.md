# SmartSchool Laravel API Models Documentation

This documentation provides an overview of the Laravel backend models for the SmartSchool application. This will help in building the Flutter frontend application.

## Core Models Overview

### User Model
The main user model that handles authentication and user management. This model is likely to be one of the most important for your Flutter app's authentication system.

### Student-Related Models
- **StudentRecord**: Manages student information
- **StudentAttendance**: Handles student attendance records
- **Book**: Manages library books
- **BookRequest**: Handles book borrowing requests
- **ExamRecord**: Stores examination records
- **Mark**: Manages student marks/grades
- **Promotion**: Handles student grade promotions

### Academic Models
- **MyClass**: Manages school classes
- **ClassType**: Defines types of classes
- **Subject**: Handles subject/course information
- **Grade**: Manages grading information
- **TimeTable**: Manages class schedules
- **TimeTableRecord**: Stores timetable entries
- **TimeSlot**: Defines time slots for classes

### Staff Models
- **StaffRecord**: Manages staff information
- **TeacherAttendance**: Handles teacher attendance records

### Administrative Models
- **Payment**: Handles payment information
- **PaymentRecord**: Stores payment records
- **Receipt**: Manages receipts
- **Setting**: Application settings
- **Pin**: Manages PIN-based operations

### Location Models
- **State**: Manages state information
- **Lga**: Local Government Area information
- **Nationality**: Manages nationality data

### Other Supporting Models
- **BloodGroup**: Blood group information
- **Dorm**: Dormitory management
- **Skill**: Skills tracking
- **UserType**: User role/type definitions

## Helper Class (Qs.php)

The `Qs` (Quick School) helper class provides essential utility functions that your Flutter app will need to implement. Here are the key functionalities:

### Authentication & User Roles
- User type checking methods:
  - `userIsAdmin()`, `userIsSuperAdmin()`, `userIsTeacher()`, `userIsStudent()`, `userIsParent()`
  - `userIsStaff()`, `userIsPTA()`, `userIsTeamAccount()`
- Role groups:
  - Team SA (Super Admin): admin, super_admin
  - Team Account: admin, super_admin, accountant
  - Team Academic: admin, super_admin, teacher, student
  - Staff: super_admin, admin, teacher, accountant, librarian
  - Parent: Parent
### Data Management
- `getUserRecord()`: Gets user profile fields
- `getStudentData()`: Gets student-specific fields
- `getStaffRecord()`: Gets staff-specific fields
- `findMyChildren($parent_id)`: Gets children records for a parent
- `findTeacherSubjects($teacher_id)`: Gets subjects assigned to a teacher
- `findStudentRecord($user_id)`: Gets student record by user ID

### File Handling
- `getPublicUploadPath()`: Gets public upload directory
- `getUserUploadPath()`: Gets user-specific upload path
- `getFileMetaData($file)`: Gets file metadata (extension, type, size)
- `formatBytes($size)`: Formats file sizes

### Session Management
- `getCurrentSession()`: Gets current academic session
- `getNextSession()`: Calculates next academic session
- `getSystemName()`: Gets school system name

### API Response Helpers
- `json($msg, $ok = TRUE, $arr = [])`: Formats JSON responses
- `jsonStoreOk()`: Success response for store operations
- `jsonUpdateOk()`: Success response for update operations

### Important Constants
- `getDaysOfTheWeek()`: Returns days of the week
- `getMarkType($class_type)`: Maps class types to marking systems:
  - J: junior
  - S: senior
  - N: nursery
  - P: primary
  - PN: pre_nursery
  - C: creche

## Middleware Overview

The application implements several layers of middleware for security and access control:

### Core Middleware
- **Authenticate**: Handles basic authentication
  - Redirects unauthenticated users to login
  - Required for all protected routes

### Custom Role-Based Middleware
Located in `app/Http/Middleware/Custom/`:

#### User Role Middleware
- **TeamSA**: Super Admin + Admin access
  ```php
  // Example usage in routes
  Route::middleware('teamSA')->group(function () {
      // Routes for super admin and admin only
  });
  ```

- **SuperAdmin**: Exclusive super admin access
- **Admin**: Administrator access
- **Teacher**: Teacher access
- **Student**: Student access
- **MyParent**: Parent access
- **TeamAccount**: Finance team access
- **TeamSAT**: Super Admin + Admin + Teacher access

#### Special Purpose Middleware
- **ExamIsLocked**: Controls access to exam results
  - Verifies if exam results are locked
  - Redirects to dashboard if not locked

### System Middleware
- **EncryptCookies**: Handles cookie encryption
- **VerifyCsrfToken**: CSRF protection
- **TrimStrings**: Cleans input data
- **Localization**: Handles language settings

## Controllers Overview

The application is organized into several controller groups:

### Authentication Controllers
Located in `app/Http/Controllers/Auth/`:
- **LoginController**: Handles user authentication
  - Supports login with either username or email
  - Uses Laravel's built-in AuthenticatesUsers trait
  - Custom redirect paths based on user type

### Support Team Controllers
Located in `app/Http/Controllers/SupportTeam/`:

#### Student Management
- **StudentRecordController**:
  - Student CRUD operations
  - Admission number generation
  - Photo upload handling
  - Password reset functionality
  - Class-wise student listing
  - Graduation management
  
- **MarkController**:
  - Exam marks management
  - Result viewing with PIN verification
  - Year-wise result access
  - Print view for results
  - Permission checks for result access

#### Academic Management
- **MyClassController**: Class management
- **SubjectController**: Subject management
- **ExamController**: Examination setup
- **GradeController**: Grading system
- **SectionController**: Class sections
- **TimeTableController**: School timetable

#### Administrative
- **AttendanceController**: Student/Teacher attendance
- **PaymentController**: Fee management
- **PinController**: Result checking PIN system
- **PromotionController**: Student promotion
- **UserController**: User management

### Access Control
Most controllers implement middleware checks:
- `teamSA`: Super Admin + Admin access
- `super_admin`: Only Super Admin access
- `teamSAT`: Super Admin + Admin + Teacher access

## API Endpoints for Flutter

When building your Flutter app, you'll need these key endpoints:

### Authentication
```
POST /api/login
- Parameters: identity (email/username), password
- Returns: user data with token
```

### Student Records
```
GET /api/students
- Parameters: class_id (optional)
- Returns: list of students

GET /api/students/{id}
- Returns: detailed student information

GET /api/students/{id}/marks
- Parameters: year, exam_id
- Returns: student's exam marks
```

### Academic Data
```
GET /api/classes
- Returns: list of classes

GET /api/subjects
- Parameters: class_id
- Returns: subjects for class

GET /api/timetable
- Parameters: class_id, section_id
- Returns: class timetable
```

### File Upload
```
POST /api/students/{id}/photo
- Parameters: photo (file)
- Returns: updated student data
```

## Important Implementation Notes

1. **Authentication**:
   - Implement token-based auth using Laravel Sanctum
   - Store token securely in Flutter
   - Handle role-based access control

2. **File Handling**:
   - Use multipart/form-data for file uploads
   - Follow the server's file structure
   - Handle image compression on client side

3. **Error Handling**:
   - Implement proper error handling for API responses
   - Show appropriate messages for PIN verification
   - Handle session expiration

4. **Data Caching**:
   - Cache appropriate data locally
   - Implement offline support where possible
   - Sync mechanism for attendance and marks

## Flutter Integration Notes

When building your Flutter app, you should:

1. **User Authentication**:
   - Implement role-based access control using the user type constants
   - Create corresponding enums/constants for user roles in Flutter

2. **File Upload**:
   - Use the same file path structure as defined in the helper
   - Implement file size formatting similarly to `formatBytes()`

3. **API Integration**:
   - Match the JSON response format from the helper
   - Create corresponding response models in Flutter

4. **Session Handling**:
   - Implement academic session logic in Flutter
   - Use the same session format as `getCurrentSession()`

## Important Notes for Flutter Integration

1. **Authentication**: The User model will be crucial for implementing authentication in your Flutter app. Make sure to implement proper token-based authentication.

2. **Relationships**: Many models have relationships with others (e.g., StudentRecord with User, Mark with Subject). Consider these relationships when designing your Flutter app's data models.

3. **Data Validation**: Implement proper validation in your Flutter app that matches the Laravel backend validation rules.

4. **API Endpoints**: You'll need to create corresponding API endpoints in Laravel for each model operation you want to perform from your Flutter app.

## Flutter Integration Guidelines

### Authentication Flow
1. **Initial Authentication**:
   ```dart
   // Example Flutter authentication check
   bool isAuthenticated = await checkAuthStatus();
   if (!isAuthenticated) {
     Navigator.pushNamed(context, '/login');
   }
   ```

2. **Role-Based Access**:
   ```dart
   // Example role check in Flutter
   bool canAccessFeature = await checkUserRole(['super_admin', 'admin']);
   if (!canAccessFeature) {
     showAccessDeniedDialog();
   }
   ```

3. **Exam Access**:
   ```dart
   // Example exam access check
   bool examIsLocked = await checkExamLockStatus();
   if (!examIsLocked) {
     showPinEntryDialog();
   }
   ```

### Security Implementation

1. **Token Management**:
   - Store authentication token securely
   - Include token in all API requests
   - Handle token expiration

2. **Role Verification**:
   - Implement client-side role checks
   - Cache user permissions
   - Update UI based on user role

3. **Error Handling**:
   - Handle unauthorized access (401)
   - Handle forbidden access (403)
   - Show appropriate error messages

### API Headers
```dart
// Example API headers setup
Map<String, String> headers = {
  'Authorization': 'Bearer $token',
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};
```

### Middleware Check Methods
```dart
// Example middleware check methods
class AuthMiddleware {
  static Future<bool> isTeamSA() async {
    final userRole = await getUserRole();
    return ['super_admin', 'admin'].contains(userRole);
  }

  static Future<bool> isTeacher() async {
    final userRole = await getUserRole();
    return userRole == 'teacher';
  }

  static Future<bool> canAccessExams() async {
    final examLocked = await getExamLockStatus();
    final hasPin = await checkExamPin();
    return examLocked && hasPin;
  }
}

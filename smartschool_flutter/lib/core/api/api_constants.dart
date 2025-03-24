class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth endpoints
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String refreshTokenEndpoint = '/refresh';
  static const String userEndpoint = '/user';
  
  // User management endpoints
  static const String usersEndpoint = '/users';
  static const String profileEndpoint = '/users/profile';
  
  // Student endpoints
  static const String studentsEndpoint = '/students';
  static const String studentAttendanceEndpoint = '/students/attendance';
  static const String studentGradesEndpoint = '/students/grades';
  
  // Teacher endpoints
  static const String teachersEndpoint = '/teachers';
  static const String teacherAttendanceEndpoint = '/teachers/attendance';
  static const String classManagementEndpoint = '/teachers/classes';
  
  // Parent endpoints
  static const String parentsEndpoint = '/parents';
  static const String childrenEndpoint = '/parents/children';
  
  // Timetable endpoints
  static const String timetableEndpoint = '/timetable';
  static const String classScheduleEndpoint = '/timetable/class';
  
  // Admin endpoints
  static const String adminReportsEndpoint = '/admin/reports';
  static const String adminUsersEndpoint = '/admin/users';
  static const String adminClassesEndpoint = '/admin/classes';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

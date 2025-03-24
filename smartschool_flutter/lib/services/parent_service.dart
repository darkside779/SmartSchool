// ignore_for_file: avoid_print
import '../models/student_record.dart';
import '../models/student_attendance.dart';
import '../models/mark.dart';
import '../models/time_table.dart';
import '../models/exam.dart';
import '../models/payment.dart';
import '../core/api/api_client.dart';

class ParentService {
  final ApiClient _apiClient;
  
  ParentService(this._apiClient);

  void setAuthToken(String token) {
    // Token handling is now managed by ApiClient
  }

  Future<List<StudentRecord>> getChildren() async {
    try {
      return await _apiClient.fetchChildren();
    } catch (e) {
      print('ParentService getChildren error: $e'); // Debug log
      rethrow;
    }
  }

  Future<List<StudentAttendance>> getChildAttendance(int studentId) async {
    if (_apiClient.authToken == null) {
      throw Exception('Authentication token is required');
    }

    try {
      final response = await _apiClient.get('/parent/children/$studentId/attendance');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => StudentAttendance.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch attendance');
        }
      } else {
        throw Exception('Failed to fetch attendance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      rethrow;
    }
  }

  Future<List<Mark>> getChildGrades(int studentId) async {
    if (_apiClient.authToken == null) {
      throw Exception('Authentication token is required');
    }

    try {
      final response = await _apiClient.get('/parent/children/$studentId/grades');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => Mark.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch grades');
        }
      } else {
        throw Exception('Failed to fetch grades: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching grades: $e');
      rethrow;
    }
  }

  Future<List<TimeTable>> getChildTimetable(int studentId) async {
    if (_apiClient.authToken == null) {
      throw Exception('Authentication token is required');
    }

    try {
      final response = await _apiClient.get('/parent/children/$studentId/timetable');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => TimeTable.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch timetable');
        }
      } else {
        throw Exception('Failed to fetch timetable: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching timetable: $e');
      rethrow;
    }
  }

  Future<List<Exam>> getChildExams(int studentId) async {
    if (_apiClient.authToken == null) {
      throw Exception('Authentication token is required');
    }

    try {
      final response = await _apiClient.get('/parent/children/$studentId/exams');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => Exam.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch exams');
        }
      } else {
        throw Exception('Failed to fetch exams: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exams: $e');
      rethrow;
    }
  }

  Future<List<Payment>> getChildPayments(int studentId) async {
    if (_apiClient.authToken == null) {
      throw Exception('Authentication token is required');
    }

    try {
      final response = await _apiClient.get('/parent/children/$studentId/payments');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => Payment.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch payments');
        }
      } else {
        throw Exception('Failed to fetch payments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching payments: $e');
      rethrow;
    }
  }
}

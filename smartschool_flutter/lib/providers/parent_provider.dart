import 'package:flutter/foundation.dart';
import '../models/student_record.dart';
import '../models/student_attendance.dart';
import '../models/mark.dart';
import '../models/time_table.dart';
import '../models/exam.dart';
import '../models/payment.dart';
import '../services/parent_service.dart';
import '../providers/auth_provider.dart';

class ParentProvider with ChangeNotifier {
  final ParentService _parentService;
  final AuthProvider _authProvider;

  ParentProvider(this._parentService, this._authProvider) {
    _authProvider.addListener(_onAuthChanged);
    if (_authProvider.isAuthenticated) {
      _initializeParentData();
    }
  }

  List<StudentRecord>? _children;
  final Map<int, List<StudentAttendance>> _attendanceRecords = {};
  final Map<int, List<Mark>> _grades = {};
  final Map<int, List<TimeTable>> _timetables = {};
  final Map<int, List<Exam>> _exams = {};
  final Map<int, List<Payment>> _payments = {};

  String? _error;
  bool _isLoading = false;

  List<StudentRecord>? get children => _children;
  String? get error => _error;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    debugPrint('🔄 Auth changed: ${_authProvider.isAuthenticated}');
    if (_authProvider.isAuthenticated) {
      _initializeParentData();
    } else {
      _children = null;
      _error = null;
      notifyListeners();
    }
  }

  Future<void> _initializeParentData() async {
    debugPrint('🔄 Initializing parent data...');
    await fetchChildren();
  }

  Future<void> fetchChildren() async {
    if (!_authProvider.isAuthenticated) {
      debugPrint('❌ Not authenticated, skipping fetch');
      return;
    }

    try {
      debugPrint('🔄 Starting to fetch children...');
      debugPrint('🔐 Auth status: ${_authProvider.isAuthenticated}');
      debugPrint('🔐 Auth token: ${_authProvider.token}');
      
      _setLoading(true);
      _error = null;
      
      debugPrint('🔄 Calling parent service to fetch children...');
      final children = await _parentService.getChildren();
      
      debugPrint('✅ Fetched ${children.length} children');
      _children = children;
      
      if (_children?.isEmpty ?? true) {
        debugPrint('⚠️ No children found for this parent');
        _error = 'No children records found';
      } else {
        debugPrint('📦 Children data: $_children');
      }
    } catch (e) {
      debugPrint('❌ Error fetching children: $e');
      _error = 'Failed to load children: $e';
      _children = null;
    } finally {
      _setLoading(false);
      debugPrint('🔄 Children fetch completed. Error: $_error, Loading: $_isLoading');
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<StudentAttendance>> getChildAttendance(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      final attendance = await _parentService.getChildAttendance(studentId);
      _attendanceRecords[studentId] = attendance;
      return attendance;
    } catch (e) {
      debugPrint('❌ Error getting child attendance: $e');
      rethrow;
    }
  }

  Future<List<Mark>> getChildGrades(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      final grades = await _parentService.getChildGrades(studentId);
      _grades[studentId] = grades;
      return grades;
    } catch (e) {
      debugPrint('❌ Error getting child grades: $e');
      rethrow;
    }
  }

  Future<Map<String, int>> getAttendanceStats(int studentId) async {
    try {
      final attendanceList = await getChildAttendance(studentId);
      final stats = <String, int>{
        'present': 0,
        'absent': 0,
        'late': 0,
      };

      for (final attendance in attendanceList) {
        switch (attendance.status.toLowerCase()) {
          case 'present':
            stats['present'] = (stats['present'] ?? 0) + 1;
            break;
          case 'absent':
            stats['absent'] = (stats['absent'] ?? 0) + 1;
            break;
          case 'late':
            stats['late'] = (stats['late'] ?? 0) + 1;
            break;
        }
      }

      return stats;
    } catch (e) {
      debugPrint('❌ Error getting attendance stats: $e');
      rethrow;
    }
  }

  Future<Map<String, int>> getGradeStats(int studentId) async {
    try {
      final gradesList = await getChildGrades(studentId);
      final stats = <String, int>{
        'excellent': 0,
        'good': 0,
        'average': 0,
        'poor': 0,
      };

      for (final mark in gradesList) {
        final percentage = mark.getPercentage();
        
        if (percentage == null) continue; // Skip marks without a percentage
        
        if (percentage >= 90) {
          stats['excellent'] = (stats['excellent'] ?? 0) + 1;
        } else if (percentage >= 75) {
          stats['good'] = (stats['good'] ?? 0) + 1;
        } else if (percentage >= 60) {
          stats['average'] = (stats['average'] ?? 0) + 1;
        } else {
          stats['poor'] = (stats['poor'] ?? 0) + 1;
        }
      }

      return stats;
    } catch (e) {
      debugPrint('❌ Error getting grade stats: $e');
      rethrow;
    }
  }

  Future<List<Payment>> getChildPayments(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      final payments = await _parentService.getChildPayments(studentId);
      _payments[studentId] = payments;
      return payments;
    } catch (e) {
      debugPrint('❌ Error getting child payments: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> getPaymentStats(int studentId) async {
    try {
      final paymentsList = await getChildPayments(studentId);
      final stats = <String, double>{
        'total': 0.0,
        'paid': 0.0,
        'pending': 0.0,
      };

      for (final payment in paymentsList) {
        stats['total'] = (stats['total'] ?? 0.0) + payment.amount;
        if (payment.isPaid) {
          stats['paid'] = (stats['paid'] ?? 0.0) + payment.amount;
        } else {
          stats['pending'] = (stats['pending'] ?? 0.0) + payment.amount;
        }
      }

      return stats;
    } catch (e) {
      debugPrint('❌ Error getting payment stats: $e');
      rethrow;
    }
  }

  Future<void> getChildTimetable(int studentId) async {
    if (!_authProvider.isAuthenticated) return;

    try {
      _setLoading(true);
      _error = null;

      final timetable = await getChildTimetableFromServer(studentId);
      _timetables[studentId] = timetable;
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load timetable: $e';
      _timetables.remove(studentId);
    } finally {
      _setLoading(false);
    }
  }

  List<TimeTable>? getTimetable(int studentId) {
    return _timetables[studentId];
  }

  List<TimeTable>? getTimetableForDay(int studentId, String dayNum) {
    final timetable = _timetables[studentId];
    if (timetable == null) return null;
    return timetable.where((entry) => entry.dayNum == dayNum).toList();
  }

  Future<List<TimeTable>> getChildTimetableFromServer(int studentId) async {
    if (_authProvider.token == null) {
      throw Exception('Authentication token is required');
    }

    try {
      return await _parentService.getChildTimetable(studentId);
    } catch (e) {
      debugPrint('❌ Error fetching timetable: $e');
      rethrow;
    }
  }

  // Get cached grades
  List<Mark>? getGrades(int studentId) {
    return _grades[studentId];
  }

  // Fetch grades from server
  Future<void> fetchChildGrades(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      _setLoading(true);
      _error = null;
      
      final grades = await _parentService.getChildGrades(studentId);
      _grades[studentId] = grades;
    } catch (e) {
      debugPrint('❌ Error fetching grades: $e');
      _error = 'Failed to load grades: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get cached exams
  List<Exam>? getExams(int studentId) {
    return _exams[studentId];
  }

  // Fetch exams from server
  Future<void> fetchChildExams(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      _setLoading(true);
      _error = null;
      
      final exams = await _parentService.getChildExams(studentId);
      _exams[studentId] = exams;
    } catch (e) {
      debugPrint('❌ Error fetching exams: $e');
      _error = 'Failed to load exams: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get cached attendance records
  List<StudentAttendance>? getAttendance(int studentId) {
    return _attendanceRecords[studentId];
  }

  // Fetch attendance from server
  Future<void> fetchChildAttendance(int studentId) async {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
    }

    try {
      _setLoading(true);
      _error = null;
      
      final attendance = await _parentService.getChildAttendance(studentId);
      _attendanceRecords[studentId] = attendance;
    } catch (e) {
      debugPrint('❌ Error fetching attendance: $e');
      _error = 'Failed to load attendance: $e';
    } finally {
      _setLoading(false);
    }
  }
}

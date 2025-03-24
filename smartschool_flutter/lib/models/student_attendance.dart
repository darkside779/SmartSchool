import 'base_model.dart';

class StudentAttendance extends BaseModel {
  final int studentId;
  final int classId;
  final int sectionId;
  final DateTime date;
  final String status;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? remark;
  final String? className;
  final String? sectionName;

  StudentAttendance({
    required super.id,
    required this.studentId,
    required this.classId,
    required this.sectionId,
    required this.date,
    required this.status,
    this.timeIn,
    this.timeOut,
    this.remark,
    this.className,
    this.sectionName,
    super.createdAt,
    super.updatedAt,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    // Parse date
    final date = DateTime.parse(json['date']);
    
    // Parse time_in by combining date with time
    DateTime? timeIn;
    if (json['time_in'] != null) {
      final timeParts = json['time_in'].split(':');
      timeIn = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
        int.parse(timeParts[2]),
      );
    }

    // Parse time_out by combining date with time
    DateTime? timeOut;
    if (json['time_out'] != null) {
      final timeParts = json['time_out'].split(':');
      timeOut = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
        int.parse(timeParts[2]),
      );
    }

    return StudentAttendance(
      id: json['id'],
      studentId: json['student_id'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      date: date,
      status: json['status'],
      timeIn: timeIn,
      timeOut: timeOut,
      remark: json['remark'],
      className: json['class'],
      sectionName: json['section'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'section_id': sectionId,
      'date': date.toIso8601String(),
      'status': status,
      'time_in': timeIn?.toIso8601String(),
      'time_out': timeOut?.toIso8601String(),
      'remark': remark,
      'class': className,
      'section': sectionName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters for status checks
  bool get isPresent => status.toLowerCase() == 'present';
  bool get isAbsent => status.toLowerCase() == 'absent';
  bool get isLate => status.toLowerCase() == 'late';

  // Helper for getting status color
  String getStatusColor() {
    switch (status.toLowerCase()) {
      case 'present':
        return '#4CAF50'; // Green
      case 'absent':
        return '#F44336'; // Red
      case 'late':
        return '#FFC107'; // Amber
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Factory constructor for creating an empty/unknown attendance record
  factory StudentAttendance.unknown({
    required int studentId,
    required DateTime date,
  }) {
    return StudentAttendance(
      id: -1,
      studentId: studentId,
      classId: -1,
      sectionId: -1,
      date: date,
      status: 'unknown',
    );
  }
}

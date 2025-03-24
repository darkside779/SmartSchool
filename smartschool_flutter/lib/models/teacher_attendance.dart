import 'base_model.dart';
import 'staff_record.dart';

class TeacherAttendance extends BaseModel {
  final StaffRecord teacher;
  final DateTime date;
  final String status; // present, absent, late, leave
  final String? remarks;
  final String? leaveType;
  final String? leaveReason;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  TeacherAttendance({
    required super.id,
    required this.teacher,
    required this.date,
    required this.status,
    this.remarks,
    this.leaveType,
    this.leaveReason,
    this.checkInTime,
    this.checkOutTime,
    super.createdAt,
    super.updatedAt,
  });

  factory TeacherAttendance.fromJson(Map<String, dynamic> json) {
    return TeacherAttendance(
      id: json['id'],
      teacher: StaffRecord.fromJson(json['teacher']),
      date: DateTime.parse(json['date']),
      status: json['status'],
      remarks: json['remarks'],
      leaveType: json['leave_type'],
      leaveReason: json['leave_reason'],
      checkInTime: BaseModel.parseDateTime(json['check_in_time']),
      checkOutTime: BaseModel.parseDateTime(json['check_out_time']),
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher': teacher.toJson(),
      'date': date.toIso8601String(),
      'status': status,
      'remarks': remarks,
      'leave_type': leaveType,
      'leave_reason': leaveReason,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isPresent => status.toLowerCase() == 'present';
  bool get isAbsent => status.toLowerCase() == 'absent';
  bool get isLate => status.toLowerCase() == 'late';
  bool get isOnLeave => status.toLowerCase() == 'leave';

  Duration? get workingHours {
    if (checkInTime == null || checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime!);
  }
}

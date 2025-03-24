import 'base_model.dart';
import 'subject.dart';
import 'staff_record.dart';

class TimeTableRecord extends BaseModel {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String startTime;
  final String endTime;
  final Subject subject;
  final StaffRecord teacher;
  final String? roomNumber;
  final bool isActive;

  TimeTableRecord({
    required super.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.teacher,
    required this.isActive,
    this.roomNumber,
    super.createdAt,
    super.updatedAt,
  });

  factory TimeTableRecord.fromJson(Map<String, dynamic> json) {
    return TimeTableRecord(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      subject: Subject.fromJson(json['subject']),
      teacher: StaffRecord.fromJson(json['teacher']),
      roomNumber: json['room_number'],
      isActive: json['is_active'] == 1,
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'subject': subject.toJson(),
      'teacher': teacher.toJson(),
      'room_number': roomNumber,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  bool get isCurrentPeriod {
    if (!isActive) return false;
    
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return now.weekday == dayOfWeek &&
        currentTime.compareTo(startTime) >= 0 &&
        currentTime.compareTo(endTime) <= 0;
  }
}

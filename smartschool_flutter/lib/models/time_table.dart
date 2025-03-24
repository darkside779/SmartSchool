import 'base_model.dart';

class TimeTableSubject {
  final int id;
  final String name;
  final int teacherId;

  TimeTableSubject({
    required this.id,
    required this.name,
    required this.teacherId,
  });

  factory TimeTableSubject.fromJson(Map<String, dynamic> json) {
    return TimeTableSubject(
      id: json['id'],
      name: json['name'],
      teacherId: json['teacher_id'],
    );
  }
}

class TimeTableSlot {
  final String timeFrom;
  final String timeTo;
  final String full;

  TimeTableSlot({
    required this.timeFrom,
    required this.timeTo,
    required this.full,
  });

  factory TimeTableSlot.fromJson(Map<String, dynamic> json) {
    return TimeTableSlot(
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      full: json['full'],
    );
  }
}

class TimeTable extends BaseModel {
  final String? day;
  final String? dayNum;
  final TimeTableSubject subject;
  final TimeTableSlot timeSlot;
  final String? examDate;
  final bool isExam;

  TimeTable({
    required super.id,
    this.day,
    this.dayNum,
    required this.subject,
    required this.timeSlot,
    this.examDate,
    required this.isExam,
    super.createdAt,
    super.updatedAt,
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      id: json['id'],
      day: json['day'] ?? (json['exam_date'] == null ? 'Monday' : null),
      dayNum: json['day_num']?.toString() ?? (json['exam_date'] == null ? '1' : null),
      subject: TimeTableSubject.fromJson(json['subject']),
      timeSlot: TimeTableSlot.fromJson(json['time_slot']),
      examDate: json['exam_date'],
      isExam: json['is_exam'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'day_num': dayNum,
      'subject': {
        'id': subject.id,
        'name': subject.name,
        'teacher_id': subject.teacherId,
      },
      'time_slot': {
        'time_from': timeSlot.timeFrom,
        'time_to': timeSlot.timeTo,
        'full': timeSlot.full,
      },
      'exam_date': examDate,
      'is_exam': isExam,
    };
  }

  String get formattedExamDate {
    if (examDate == null) return '';
    return examDate!;
  }
}

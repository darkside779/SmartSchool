import 'base_model.dart';
import 'subject.dart';
import 'mark.dart';

class ExamRecord extends BaseModel {
  final Subject subject;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int totalMarks;
  final int passingMarks;
  final String? roomNumber;
  final List<Mark>? marks;

  ExamRecord({
    required super.id,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalMarks,
    required this.passingMarks,
    this.roomNumber,
    this.marks,
    super.createdAt,
    super.updatedAt,
  });

  factory ExamRecord.fromJson(Map<String, dynamic> json) {
    return ExamRecord(
      id: json['id'],
      subject: Subject.fromJson(json['subject']),
      date: DateTime.parse(json['date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalMarks: json['total_marks'],
      passingMarks: json['passing_marks'],
      roomNumber: json['room_number'],
      marks: json['marks'] != null
          ? (json['marks'] as List).map((mark) => Mark.fromJson(mark)).toList()
          : null,
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject.toJson(),
      'date': date.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'total_marks': totalMarks,
      'passing_marks': passingMarks,
      'room_number': roomNumber,
      'marks': marks?.map((mark) => mark.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  } 

  bool get isUpcoming {
    final now = DateTime.now();
    final examDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(startTime.split(':')[0]),
      int.parse(startTime.split(':')[1]),
    );
    return now.isBefore(examDateTime);
  }

  String get status {
    if (isUpcoming) return 'Upcoming';
    return 'Completed';
  }

  double? getAverageScore() {
    if (marks == null || marks!.isEmpty) return null;
    
    final validMarks = marks!.where((mark) => mark.marks != null);
    if (validMarks.isEmpty) return null;
    
    final total = validMarks.fold(0.0, (sum, mark) => sum + (mark.marks ?? 0));
    return total / validMarks.length;
  }

  int getPassedSubjectsCount(int defaultPassingMarks) {
    if (marks == null || marks!.isEmpty) return 0;
    
    return marks!.where((mark) {
      if (mark.isPassed()) return true;
      final passingMarks = mark.subject?.passingMarks ?? defaultPassingMarks;
      return mark.marks != null && mark.marks! >= passingMarks;
    }).length;
  }
}

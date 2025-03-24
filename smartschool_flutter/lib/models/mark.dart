import 'base_model.dart';
import 'subject.dart';

class ExamGrade {
  final int id;
  final String name;
  final String remark;
  final int markFrom;
  final int markTo;

  ExamGrade({
    this.id = 0,
    this.name = '',
    this.remark = '',
    this.markFrom = 0,
    this.markTo = 0,
  });

  factory ExamGrade.fromJson(Map<String, dynamic> json) {
    return ExamGrade(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      remark: json['remark'] ?? '',
      markFrom: json['mark_from'] ?? 0,
      markTo: json['mark_to'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'remark': remark,
      'mark_from': markFrom,
      'mark_to': markTo,
    };
  }
}

class ExamInfo {
  final int id;
  final String name;
  final String term;
  final String year;

  ExamInfo({
    this.id = 0,
    this.name = '',
    this.term = '',
    this.year = '',
  });

  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      term: (json['term'] ?? '').toString(),
      year: (json['year'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'term': term,
      'year': year,
    };
  }
}

class Mark extends BaseModel {
  final int studentId;
  final int subjectId;
  final int examId;
  final double? marks;
  final ExamGrade? grade;
  final Subject? subject;
  final ExamInfo? exam;
  final String? remarks;

  Mark({
    required super.id,
    this.studentId = 0,
    this.subjectId = 0,
    this.examId = 0,
    this.marks,
    this.grade,
    this.subject,
    this.exam,
    this.remarks,
    super.createdAt,
    super.updatedAt,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      subjectId: json['subject_id'] ?? 0,
      examId: json['exam_id'] ?? 0,
      marks: json['marks']?.toDouble(),
      grade: json['grade'] != null ? ExamGrade.fromJson(json['grade']) : null,
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      exam: json['exam'] != null ? ExamInfo.fromJson(json['exam']) : null,
      remarks: json['remarks'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_id': subjectId,
      'exam_id': examId,
      'marks': marks,
      'grade': grade?.toJson(),
      'subject': subject?.toJson(),
      'exam': exam?.toJson(),
      'remarks': remarks,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool isPassed() {
    if (grade != null) {
      // Consider passing if grade is present (teacher has assigned a grade)
      return true;
    }
    if (marks == null) return false;
    
    // Use subject's passing marks if available, otherwise use default 50%
    final passingMark = subject?.passingMarks ?? 50;
    return marks! >= passingMark;
  }

  String getGradeDisplay() {
    if (grade != null) {
      return '${grade!.name} (${grade!.remark})';
    }
    return marks?.toString() ?? 'N/A';
  }

  double? getPercentage() {
    if (marks == null) return null;
    final totalMarks = subject?.totalMarks ?? 100;  // Default to 100 if not specified
    return (marks! / totalMarks) * 100;
  }
}

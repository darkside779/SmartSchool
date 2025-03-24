class StudentGrade {
  final int id;
  final int studentId;
  final int subjectId;
  final int examId;
  final double? marks;
  final Grade? grade;
  final Subject? subject;
  final Exam? exam;

  StudentGrade({
    this.id = 0,
    this.studentId = 0,
    this.subjectId = 0,
    this.examId = 0,
    this.marks,
    this.grade,
    this.subject,
    this.exam,
  });

  factory StudentGrade.fromJson(Map<String, dynamic> json) {
    return StudentGrade(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      subjectId: json['subject_id'] ?? 0,
      examId: json['exam_id'] ?? 0,
      marks: json['marks']?.toDouble(),
      grade: json['grade'] != null ? Grade.fromJson(json['grade']) : null,
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      exam: json['exam'] != null ? Exam.fromJson(json['exam']) : null,
    );
  }

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
    };
  }
}

class Grade {
  final int id;
  final String name;
  final String remark;
  final int markFrom;
  final int markTo;

  Grade({
    this.id = 0,
    this.name = '',
    this.remark = '',
    this.markFrom = 0,
    this.markTo = 0,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
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

class Subject {
  final int id;
  final String name;
  final String slug;

  Subject({
    this.id = 0,
    this.name = '',
    this.slug = '',
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class Exam {
  final int id;
  final String name;
  final int term;
  final String year;

  Exam({
    this.id = 0,
    this.name = '',
    this.term = 0,
    this.year = '',
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      term: json['term'] is String ? int.parse(json['term']) : (json['term'] ?? 0),
      year: json['year']?.toString() ?? '',
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

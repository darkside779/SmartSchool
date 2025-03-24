import 'user_model.dart';
import 'student_record.dart';

class Section {
  final int id;
  final String name;
  final int myClassId;
  final bool active;
  final int? teacherId;
  final User? teacher;
  final List<StudentRecord>? students;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Section({
    required this.id,
    required this.name,
    required this.myClassId,
    required this.active,
    this.teacherId,
    this.teacher,
    this.students,
    this.createdAt,
    this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      myClassId: json['my_class_id'],
      active: json['active'] == 1 || json['active'] == true,
      teacherId: json['teacher_id'],
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
      students: json['student_record'] != null
          ? (json['student_record'] as List)
              .map((i) => StudentRecord.fromJson(i))
              .toList()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'my_class_id': myClassId,
      'active': active ? 1 : 0,
      'teacher_id': teacherId,
      'teacher': teacher?.toJson(),
      'student_record': students?.map((s) => s.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  int get studentCount => students?.length ?? 0;

  bool hasTeacher() => teacherId != null && teacher != null;

  List<StudentRecord> getActiveStudents() {
    if (students == null) return [];
    return students!.where((s) => s.active).toList();
  }
}

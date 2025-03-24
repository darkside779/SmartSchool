import 'base_model.dart';

class Subject extends BaseModel {
  final String name;
  final String slug;
  final String? description;
  final int creditHours;
  final bool isActive;
  final String? type; // theory, practical, both
  final int? passingMarks;
  final int? totalMarks;

  Subject({
    required super.id,
    required this.name,
    required this.slug,
    this.creditHours = 0,
    this.isActive = true,
    this.description,
    this.type,
    this.passingMarks,
    this.totalMarks,
    super.createdAt,
    super.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      creditHours: json['credit_hours'] ?? 0,
      isActive: json['is_active'] == 1,
      type: json['type'],
      passingMarks: json['passing_marks'],
      totalMarks: json['total_marks'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'credit_hours': creditHours,
      'is_active': isActive ? 1 : 0,
      'type': type,
      'passing_marks': passingMarks,
      'total_marks': totalMarks,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

import 'base_model.dart';

class Exam extends BaseModel {
  final String name;
  final String term;
  final String year;

  Exam({
    required super.id,
    required this.name,
    required this.term,
    required this.year,
    super.createdAt,
    super.updatedAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      term: (json['term'] ?? '').toString(),
      year: (json['year'] ?? '').toString(),
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'term': term,
      'year': year,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

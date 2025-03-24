import 'base_model.dart';

class UserType extends BaseModel {
  final String name;
  final String code;
  final String? description;

  UserType({
    required super.id,
    required this.name,
    required this.code,
    this.description,
    super.createdAt,
    super.updatedAt,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

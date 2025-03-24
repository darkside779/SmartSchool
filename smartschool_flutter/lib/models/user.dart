import 'base_model.dart';

class User extends BaseModel {
  final String name;
  final String email;
  final String userType;
  final String? phone;
  final String gender;
  final String? dob;

  User({
    required super.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    required this.gender,
    this.dob,
    super.createdAt,
    super.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userType: json['user_type'] ?? '',
      phone: json['phone'],
      gender: json['gender'] ?? '',
      dob: json['dob'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

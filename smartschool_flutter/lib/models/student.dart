import 'base_model.dart';
import 'user.dart';

class Student extends BaseModel {
  final User user;
  final String? admissionNumber;
  final String? rollNumber;
  final String currentClass;
  final String section;
  final String? admissionDate;
  final String parentName;
  final String? parentPhone;
  final String parentEmail;
  final String address;
  final String? bloodGroup;
  final String? dateOfBirth;
  final String gender;
  final bool isActive;

  Student({
    required super.id,
    required this.user,
    this.admissionNumber,
    this.rollNumber,
    required this.currentClass,
    required this.section,
    this.admissionDate,
    required this.parentName,
    this.parentPhone,
    required this.parentEmail,
    required this.address,
    this.bloodGroup,
    this.dateOfBirth,
    required this.gender,
    required this.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      admissionNumber: json['admission_number'],
      rollNumber: json['roll_number'],
      currentClass: json['current_class'] ?? '',
      section: json['section'] ?? '',
      admissionDate: json['admission_date']?.toString(),
      parentName: json['parent_name'] ?? '',
      parentPhone: json['parent_phone'],
      parentEmail: json['parent_email'] ?? '',
      address: json['address'] ?? '',
      bloodGroup: json['blood_group'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'current_class': currentClass,
      'section': section,
      'admission_date': admissionDate,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'parent_email': parentEmail,
      'address': address,
      'blood_group': bloodGroup,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

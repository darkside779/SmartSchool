import 'package:smartschool_flutter/models/user_model.dart';

import 'base_model.dart';


class StaffRecord extends BaseModel {
  final User user;
  final String employeeId;
  final String designation;
  final String? department;
  final DateTime? joiningDate;
  final String? qualification;
  final String? experience;
  final String? address;
  final String? phone;
  final bool isActive;
  final List<String>? subjects;
  final List<String>? classes;

  StaffRecord({
    required super.id,
    required this.user,
    required this.employeeId,
    required this.designation,
    required this.isActive,
    this.department,
    this.joiningDate,
    this.qualification,
    this.experience,
    this.address,
    this.phone,
    this.subjects,
    this.classes,
    super.createdAt,
    super.updatedAt,
  });

  factory StaffRecord.fromJson(Map<String, dynamic> json) {
    return StaffRecord(
      id: json['id'],
      user: User.fromJson(json['user']),
      employeeId: json['employee_id'],
      designation: json['designation'],
      department: json['department'],
      joiningDate: BaseModel.parseDateTime(json['joining_date']),
      qualification: json['qualification'],
      experience: json['experience'],
      address: json['address'],
      phone: json['phone'],
      isActive: json['is_active'] == 1,
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : null,
      classes: json['classes'] != null
          ? List<String>.from(json['classes'])
          : null,
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'employee_id': employeeId,
      'designation': designation,
      'department': department,
      'joining_date': joiningDate?.toIso8601String(),
      'qualification': qualification,
      'experience': experience,
      'address': address,
      'phone': phone,
      'is_active': isActive ? 1 : 0,
      'subjects': subjects,
      'classes': classes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

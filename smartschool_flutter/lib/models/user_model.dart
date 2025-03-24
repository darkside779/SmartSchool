
class User {
  final int id;
  final String name;
  final String email;
  final String userType;
  final bool isAdmin;
  final bool isTeacher;
  final bool isStudent;
  final bool isParent;
  final String? dob; // Add this
  final String? gender; // Add this
  final String? bloodGroup;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.isAdmin,
    required this.isTeacher,
    required this.isStudent,
    required this.isParent,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      isAdmin: json['is_admin'] as bool? ?? false,
      isTeacher: json['is_teacher'] as bool? ?? false,
      isStudent: json['is_student'] as bool? ?? false,
      isParent: json['is_parent'] as bool? ?? false,
      dob: json['dob'],
      gender: json['gender'],
      bloodGroup: json['blood_group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'is_admin': isAdmin,
      'is_teacher': isTeacher,
      'is_student': isStudent,
      'is_parent': isParent,
    };
  }
}

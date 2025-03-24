import 'package:flutter/material.dart';
import '../core/utils/user_roles.dart';

class RoleBasedAccessWidget extends StatelessWidget {
  final UserRole userRole;
  final Widget child;

  const RoleBasedAccessWidget({super.key, required this.userRole, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case UserRole.admin:
        return child; // Admin has access to everything
      case UserRole.teacher:
        return child; // Teacher has access to certain features
      case UserRole.parent:
        return child; // Parent has access to their child's information
      case UserRole.student:
        return child; // Student has limited access
      // ignore: unreachable_switch_default
      default:
        return NoAccessScreen(); // No access for undefined roles
    }
  }
}

class NoAccessScreen extends StatelessWidget {
  const NoAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Denied'),
      ),
      body: Center(
        child: Text('You do not have access to this feature.'),
      ),
    );
  }
}

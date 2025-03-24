// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/parent_provider.dart';
import '../../models/student_record.dart';
import 'child_attendance_screen.dart';
import 'child_grades_screen.dart';
import 'child_timetable_screen.dart';

class ChildrenOverviewScreen extends StatefulWidget {
  const ChildrenOverviewScreen({super.key});

  @override
  State<ChildrenOverviewScreen> createState() => _ChildrenOverviewScreenState();
}

class _ChildrenOverviewScreenState extends State<ChildrenOverviewScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('🔄 ChildrenOverviewScreen initialized');
    Future.microtask(() {
      debugPrint('🔄 Starting to fetch children...');
      final authProvider = context.read<AuthProvider>();
      final parentProvider = context.read<ParentProvider>();
      debugPrint('🔐 Auth status: ${authProvider.isAuthenticated}');
      parentProvider.fetchChildren();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 Building ChildrenOverviewScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              debugPrint('🔄 Manual refresh triggered');
              context.read<ParentProvider>().fetchChildren();
            },
          ),
        ],
      ),
      body: Consumer<ParentProvider>(
        builder: (context, provider, child) {
          debugPrint('🔄 Provider state - Loading: ${provider.isLoading}, Error: ${provider.error}');
          
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('🔄 Retry button pressed');
                      provider.fetchChildren();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final children = provider.children;
          debugPrint('📦 Children data available: ${children?.length ?? 0}');
          
          if (children == null || children.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No children found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('🔄 Refresh button pressed');
                      provider.fetchChildren();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return _buildChildCard(context, child, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    StudentRecord child,
    ParentProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(child.user.name[0]),
            ),
            title: Text(child.user.name),
            subtitle: Text('Class: ${child.currentClass}'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Admission No:', child.admissionNumber),
                if (child.rollNumber != null)
                  _buildInfoRow('Roll No:', child.rollNumber!),
                _buildInfoRow('Section:', child.section),
              ],
            ),
          ),
          _buildProgressSection(context, child.id, provider),
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                'Attendance',
                Icons.calendar_today,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildAttendanceScreen(
                      studentId: child.id,
                      studentName: child.user.name,
                    ),
                  ),
                ),
              ),
              _buildActionButton(
                context,
                'Grades',
                Icons.grade,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildGradesScreen(
                      studentId: child.id,
                      studentName: child.user.name,
                    ),
                  ),
                ),
              ),
              _buildActionButton(
                context,
                'Timetable',
                Icons.schedule,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildTimetableScreen(
                      studentId: child.id,
                      studentName: child.user.name,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    int studentId,
    ParentProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, dynamic>>(
            future: Future.wait([
              provider.getAttendanceStats(studentId),
              provider.getGradeStats(studentId),
              provider.getPaymentStats(studentId),
            ]).then((results) {
              final attendanceStats = results[0] as Map<String, int>;
              final gradeStats = results[1] as Map<String, int>;
              final paymentStats = results[2] as Map<String, double>;
              
              return {
                'attendance': (attendanceStats['present'] ?? 0) / 
                            (attendanceStats['present'] ?? 0 + 
                             attendanceStats['absent']!) * 100,
                'grades': gradeStats['excellent'] != null ? 
                         ((gradeStats['excellent']! * 100 + 
                           gradeStats['good']! * 80 + 
                           gradeStats['average']! * 60) / 
                          (gradeStats['excellent']! + 
                           gradeStats['good']! + 
                           gradeStats['average']! + 
                           gradeStats['poor']!)) : 0.0,
                'fees': paymentStats['total'] != null && paymentStats['total']! > 0 ?
                       (paymentStats['paid'] ?? 0) / paymentStats['total']! * 100 : 0.0,
              };
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final data = snapshot.data!;
              return Row(
                children: [
                  Expanded(
                    child: _buildProgressIndicator(
                      'Attendance',
                      data['attendance'] as double,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildProgressIndicator(
                      'Grades',
                      data['grades'] as double,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildProgressIndicator(
                      'Fees',
                      data['fees'] as double,
                      Colors.orange,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double value, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey[200],
                color: color,
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  '${value.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

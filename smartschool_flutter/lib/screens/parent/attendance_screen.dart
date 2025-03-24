// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  final String studentName;
  final String className;

  const AttendanceScreen({
    super.key,
    required this.studentName,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(studentName),
            Text(
              className,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAttendanceSummary(context),
            const SizedBox(height: 24),
            Text(
              'Monthly Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMonthlyOverview(context),
            const SizedBox(height: 24),
            Text(
              'Recent Attendance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildRecentAttendance(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttendanceStats(
                  context,
                  'Present',
                  '85',
                  Colors.green,
                ),
                _buildAttendanceStats(
                  context,
                  'Absent',
                  '10',
                  Colors.red,
                ),
                _buildAttendanceStats(
                  context,
                  'Late',
                  '5',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              '$value%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'January 2025',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                      iconSize: 16,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                      iconSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 31,
              itemBuilder: (context, index) {
                final day = index + 1;
                final status = _getAttendanceStatus(day);
                return _buildDayCell(context, day, status);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int day, String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'present':
        backgroundColor = Colors.green.withOpacity(0.2);
        break;
      case 'absent':
        backgroundColor = Colors.red.withOpacity(0.2);
        break;
      case 'late':
        backgroundColor = Colors.orange.withOpacity(0.2);
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildRecentAttendance(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(index),
              child: Icon(
                _getStatusIcon(index),
                color: Colors.white,
                size: 16,
              ),
            ),
            title: Text('January ${28 - index}, 2025'),
            subtitle: Text(_getAttendanceStatus(28 - index)),
            trailing: Text(_getAttendanceTime(index)),
          );
        },
      ),
    );
  }

  String _getAttendanceStatus(int day) {
    // TODO: Get real attendance data from API
    if (day % 3 == 0) return 'Present';
    if (day % 7 == 0) return 'Absent';
    if (day % 5 == 0) return 'Late';
    return 'Present';
  }

  Color _getStatusColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(int index) {
    switch (index % 3) {
      case 0:
        return Icons.check;
      case 1:
        return Icons.access_time;
      default:
        return Icons.close;
    }
  }

  String _getAttendanceTime(int index) {
    switch (index % 3) {
      case 0:
        return '8:00 AM';
      case 1:
        return '8:15 AM';
      default:
        return '-';
    }
  }
}

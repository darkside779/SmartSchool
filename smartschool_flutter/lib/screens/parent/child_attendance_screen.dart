// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parent_provider.dart';
import '../../models/student_attendance.dart';

class ChildAttendanceScreen extends StatefulWidget {
  final int studentId;
  final String studentName;

  const ChildAttendanceScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<ChildAttendanceScreen> createState() => _ChildAttendanceScreenState();
}

class _ChildAttendanceScreenState extends State<ChildAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _months.length, vsync: this);
    Future.microtask(
      () => context.read<ParentProvider>().fetchChildAttendance(widget.studentId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.studentName),
            Text(
              'Attendance Record',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _months.map((month) => Tab(text: month)).toList(),
        ),
      ),
      body: Consumer<ParentProvider>(
        builder: (context, provider, child) {
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
                    onPressed: () => provider.fetchChildAttendance(widget.studentId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final attendance = provider.getAttendance(widget.studentId);
          if (attendance == null || attendance.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No attendance records found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchChildAttendance(widget.studentId),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: _months.map((month) {
              final monthAttendance = _filterAttendanceByMonth(attendance, month);
              if (monthAttendance.isEmpty) {
                return const Center(
                  child: Text('No attendance records for this month'),
                );
              }
              return _buildMonthView(attendance, month);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildMonthView(List<StudentAttendance> attendance, String month) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceSummary(attendance, month),
          const SizedBox(height: 24),
          _buildCalendarView(attendance, month),
          const SizedBox(height: 24),
          _buildDetailedList(attendance, month),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary(
    List<StudentAttendance> attendance,
    String month,
  ) {
    final monthAttendance = _filterAttendanceByMonth(attendance, month);
    int present = 0;
    int absent = 0;
    int late = 0;

    for (var record in monthAttendance) {
      if (record.isPresent) {
        present++;
      } else if (record.isAbsent) {
        absent++;
      } else if (record.isLate) {
        late++;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Present', present, Colors.green),
                _buildSummaryItem('Absent', absent, Colors.red),
                _buildSummaryItem('Late', late, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildCalendarView(
    List<StudentAttendance> attendance,
    String month,
  ) {
    final monthAttendance = _filterAttendanceByMonth(attendance, month);
    final daysInMonth = _getDaysInMonth(month);
    final monthIndex = _months.indexOf(month) + 1;
    final year = DateTime.now().year;
    final firstDayOfMonth = DateTime(year, monthIndex, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar View',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
                Text('Sun'),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 weeks * 7 days
              itemBuilder: (context, index) {
                // Add empty cells for days before the first day of month
                if (index < firstWeekdayOfMonth - 1) {
                  return Container();
                }
                
                final day = index - (firstWeekdayOfMonth - 1) + 1;
                if (day > daysInMonth) {
                  return Container();
                }

                final record = monthAttendance.firstWhere(
                  (r) => r.date.day == day,
                  orElse: () => StudentAttendance.unknown(
                    studentId: widget.studentId,
                    date: DateTime(year, monthIndex, day),
                  ),
                );

                return _buildDayCell(day, record);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, StudentAttendance record) {
    Color backgroundColor;
    IconData? icon;
    Color textColor;

    switch (record.status.toLowerCase()) {
      case 'present':
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'absent':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red;
        icon = Icons.cancel;
        break;
      case 'late':
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange;
        icon = Icons.access_time;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
        icon = null;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (icon != null)
            Positioned(
              right: 4,
              bottom: 4,
              child: Icon(
                icon,
                size: 12,
                color: textColor,
              ),
            ),
          if (record.timeIn != null)
            Positioned(
              left: 4,
              top: 4,
              child: Text(
                '${record.timeIn!.hour.toString().padLeft(2, '0')}:${record.timeIn!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 8,
                  color: textColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedList(
    List<StudentAttendance> attendance,
    String month,
  ) {
    final monthAttendance = _filterAttendanceByMonth(attendance, month);
    
    if (monthAttendance.isEmpty) {
      return const Center(
        child: Text('No attendance records for this month'),
      );
    }

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: monthAttendance.length,
        itemBuilder: (context, index) {
          final record = monthAttendance[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(record.status).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(record.status),
                color: _getStatusColor(record.status),
              ),
            ),
            title: Text(
              '${record.date.day} ${_getMonthName(record.date.month)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (record.className != null)
                  Text('Class: ${record.className}'),
                if (record.remark?.isNotEmpty ?? false)
                  Text(
                    record.remark!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            trailing: record.timeIn != null
                ? Text(
                    '${record.timeIn!.hour}:${record.timeIn!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  List<StudentAttendance> _filterAttendanceByMonth(
    List<StudentAttendance> attendance,
    String month,
  ) {
    final monthIndex = _months.indexOf(month) + 1;
    return attendance
        .where((record) => record.date.month == monthIndex)
        .toList();
  }

  int _getDaysInMonth(String month) {
    final monthIndex = _months.indexOf(month) + 1;
    final year = DateTime.now().year;
    return DateTime(year, monthIndex + 1, 0).day;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check;
      case 'absent':
        return Icons.close;
      case 'late':
        return Icons.access_time;
      default:
        return Icons.question_mark;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

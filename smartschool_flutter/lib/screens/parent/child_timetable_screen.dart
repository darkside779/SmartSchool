// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/time_table.dart';
import '../../providers/parent_provider.dart';

class ChildTimetableScreen extends StatefulWidget {
  final int studentId;
  final String studentName;

  const ChildTimetableScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<ChildTimetableScreen> createState() => _ChildTimetableScreenState();
}

class _ChildTimetableScreenState extends State<ChildTimetableScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDay = DateTime.now().weekday.toString();
  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentProvider>().getChildTimetable(widget.studentId);
    });
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
              'Schedule',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Class Schedule'),
            Tab(text: 'Exam Schedule'),
          ],
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
                    onPressed: () => provider.getChildTimetable(widget.studentId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final timetable = provider.getTimetable(widget.studentId);
          if (timetable == null || timetable.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No schedule available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.getChildTimetable(widget.studentId),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildClassSchedule(timetable.where((t) => !t.isExam).toList()),
              _buildExamSchedule(timetable.where((t) => t.isExam).toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildClassSchedule(List<TimeTable> timetable) {
    if (timetable.isEmpty) {
      return const Center(
        child: Text('No class schedule available'),
      );
    }

    // Filter schedules for selected day
    final daySchedules = timetable.where((t) => t.dayNum == _selectedDay).toList()
      ..sort((a, b) => a.timeSlot.timeFrom.compareTo(b.timeSlot.timeFrom));

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: _weekDays.asMap().entries.map((entry) {
              final index = (entry.key + 1).toString();
              final day = entry.value;
              final hasClasses = timetable.any((t) => t.dayNum == index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(day),
                  selected: _selectedDay == index,
                  onSelected: hasClasses ? (selected) {
                    if (selected) {
                      setState(() => _selectedDay = index);
                    }
                  } : null,
                  showCheckmark: false,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundColor: hasClasses ? null : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        ),
        if (daySchedules.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No classes scheduled for this day'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daySchedules.length,
              itemBuilder: (context, index) {
                final entry = daySchedules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(entry.subject.name),
                    subtitle: Text(entry.timeSlot.full),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildExamSchedule(List<TimeTable> exams) {
    if (exams.isEmpty) {
      return const Center(
        child: Text('No exam schedule available'),
      );
    }

    // Sort exams by date
    exams.sort((a, b) {
      if (a.examDate == null || b.examDate == null) return 0;
      return a.examDate!.compareTo(b.examDate!);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(exam.subject.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam.timeSlot.full),
                const SizedBox(height: 4),
                Text(
                  'Exam Date: ${exam.formattedExamDate}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

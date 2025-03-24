import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  final String studentName;
  final String className;

  const TimetableScreen({
    super.key,
    required this.studentName,
    required this.className,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDay = DateTime.now().weekday - 1;
  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.studentName),
            Text(
              widget.className,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_weekDays[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDay = index;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6, // Number of periods
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_getSubjectName(index)),
                    subtitle: Text(_getTimeSlot(index)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getTeacherName(index),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _getClassroom(index),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSubjectName(int period) {
    // TODO: Get actual subject data from API
    final subjects = [
      'Mathematics',
      'Science',
      'English',
      'History',
      'Physical Education',
      'Art',
    ];
    return subjects[period % subjects.length];
  }

  String _getTimeSlot(int period) {
    // TODO: Get actual time slots from API
    final startHour = 8 + period;
    final endHour = startHour + 1;
    return '$startHour:00 - $endHour:00';
  }

  String _getTeacherName(int period) {
    // TODO: Get actual teacher data from API
    final teachers = [
      'Mr. Smith',
      'Mrs. Johnson',
      'Ms. Davis',
      'Mr. Wilson',
      'Mrs. Brown',
      'Mr. Taylor',
    ];
    return teachers[period % teachers.length];
  }

  String _getClassroom(int period) {
    // TODO: Get actual classroom data from API
    return 'Room ${101 + period}';
  }
}

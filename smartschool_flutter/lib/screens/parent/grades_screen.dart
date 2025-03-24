import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  final String studentName;
  final String className;

  const GradesScreen({
    super.key,
    required this.studentName,
    required this.className,
  });

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _terms = ['Term 1', 'Term 2', 'Term 3'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _terms.length, vsync: this);
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
              widget.className,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _terms.map((term) => Tab(text: term)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _terms.map((term) => _buildGradesList(term)).toList(),
      ),
    );
  }

  Widget _buildGradesList(String term) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallProgress(),
          const SizedBox(height: 24),
          Text(
            'Subject Grades',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getDummySubjects().length,
            itemBuilder: (context, index) {
              final subject = _getDummySubjects()[index];
              return Card(
                child: ListTile(
                  title: Text(subject['name']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: double.parse(subject['percentage']!) / 100,
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grade: ${subject['grade']}'),
                          Text('${subject['percentage']}%'),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _showGradeDetails(context, subject),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressIndicator(
                  'GPA',
                  '3.8',
                  '4.0',
                  Colors.blue,
                ),
                _buildProgressIndicator(
                  'Attendance',
                  '95',
                  '100',
                  Colors.green,
                ),
                _buildProgressIndicator(
                  'Rank',
                  '5',
                  '50',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    String label,
    String value,
    String total,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  value: double.parse(value) / double.parse(total),
                  backgroundColor: Colors.grey[200],
                  color: color,
                  strokeWidth: 8,
                ),
              ),
              Center(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'out of $total',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showGradeDetails(BuildContext context, Map<String, String> subject) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject['name']!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildGradeDetailRow('Grade', subject['grade']!),
            _buildGradeDetailRow('Percentage', '${subject['percentage']}%'),
            _buildGradeDetailRow('Teacher', subject['teacher']!),
            const SizedBox(height: 16),
            const Text('Grade Breakdown:'),
            const SizedBox(height: 8),
            _buildGradeDetailRow('Assignments', '90%'),
            _buildGradeDetailRow('Tests', '85%'),
            _buildGradeDetailRow('Projects', '95%'),
            _buildGradeDetailRow('Class Participation', '88%'),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(value),
        ],
      ),
    );
  }

  List<Map<String, String>> _getDummySubjects() {
    return [
      {
        'name': 'Mathematics',
        'grade': 'A',
        'percentage': '95',
        'teacher': 'Mr. Smith',
      },
      {
        'name': 'Science',
        'grade': 'A-',
        'percentage': '90',
        'teacher': 'Mrs. Johnson',
      },
      {
        'name': 'English',
        'grade': 'B+',
        'percentage': '88',
        'teacher': 'Ms. Davis',
      },
      {
        'name': 'History',
        'grade': 'A',
        'percentage': '93',
        'teacher': 'Mr. Wilson',
      },
      {
        'name': 'Physical Education',
        'grade': 'A+',
        'percentage': '98',
        'teacher': 'Mrs. Brown',
      },
      {
        'name': 'Art',
        'grade': 'A',
        'percentage': '92',
        'teacher': 'Mr. Taylor',
      },
    ];
  }
}

// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parent_provider.dart';
import '../../models/exam.dart';

class ChildGradesScreen extends StatefulWidget {
  final int studentId;
  final String studentName;

  const ChildGradesScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<ChildGradesScreen> createState() => _ChildGradesScreenState();
}

class _ChildGradesScreenState extends State<ChildGradesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _terms = ['Term 1', 'Term 2', 'Term 3'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _terms.length, vsync: this);
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final provider = context.read<ParentProvider>();
      provider.fetchChildGrades(widget.studentId);
      provider.fetchChildExams(widget.studentId);
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
              'Academic Performance',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _terms.map((term) => Tab(text: term)).toList(),
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
                    onPressed: () {
                      provider.fetchChildGrades(widget.studentId);
                      provider.fetchChildExams(widget.studentId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final grades = provider.getGrades(widget.studentId);
          final exams = provider.getExams(widget.studentId);

          if (grades == null || grades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No grades available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchChildGrades(widget.studentId);
                      provider.fetchChildExams(widget.studentId);
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: _terms.map((term) {
              final termGrades = grades.where((grade) {
                final examForGrade = exams?.firstWhere(
                  (exam) => exam.id == grade.exam?.id,
                  orElse: () => Exam(
                    id: -1,
                    name: 'Unknown',
                    term: 'Unknown',
                    year: 'Unknown',
                  ),
                );
                // Convert term from API (1, 2, 3) to match our UI terms (Term 1, Term 2, Term 3)
                final termNumber = term.replaceAll('Term ', '');
                return examForGrade?.term.toString() == termNumber;
              }).toList();

              if (termGrades.isEmpty) {
                return const Center(
                  child: Text('No grades available for this term'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: termGrades.length,
                itemBuilder: (context, index) {
                  final grade = termGrades[index];
                  final exam = exams?.firstWhere(
                    (e) => e.id == grade.exam?.id,
                    orElse: () => Exam(
                      id: -1,
                      name: 'Unknown',
                      term: 'Unknown',
                      year: 'Unknown',
                    ),
                  );

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          grade.subject?.name ?? 'Unknown Subject',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Exam: ${exam?.name ?? 'Unknown'}'),
                            Text('Year: ${exam?.year ?? 'Unknown'}'),
                          ],
                        ),
                        trailing: Container(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Score: ${grade.marks?.toString() ?? 'N/A'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (grade.grade != null)
                                Text(
                                  grade.grade!.name,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              if (grade.grade?.remark != null)
                                Text(
                                  grade.grade!.remark,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ... rest of the code remains the same ...
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartschool_flutter/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/parent_provider.dart';
import '../../models/student_record.dart';
import 'children_overview_screen.dart';
import 'child_attendance_screen.dart';
import 'child_grades_screen.dart';
import 'child_timetable_screen.dart';
import 'payment_receipts_screen.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  @override
  void initState() {
    super.initState();
    // Fetch children data when dashboard loads
    Future.microtask(
      // ignore: use_build_context_synchronously
      () => context.read<ParentProvider>().fetchChildren(),
    );
  }

  void _showChildrenList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChildrenOverviewScreen(),
      ),
    );
  }

  void _showChildAttendance(BuildContext context, StudentRecord child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildAttendanceScreen(
          studentId: child.id,
          studentName: child.user.name,
        ),
      ),
    );
  }

  void _showChildGrades(BuildContext context, StudentRecord child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildGradesScreen(
          studentId: child.id,
          studentName: child.user.name,
        ),
      ),
    );
  }

  void _showChildTimetable(BuildContext context, StudentRecord child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildTimetableScreen(
          studentId: child.id,
          studentName: child.user.name,
        ),
      ),
    );
  }

  void _showPaymentReceipts(BuildContext context, StudentRecord child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentReceiptsScreen(
          studentId: child.id,
          studentName: child.user.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User? user = authProvider.userData;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Consumer<ParentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final children = provider.children;
          
          // Show error state
          if (provider.error != null) {
            return SizedBox.expand(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => provider.fetchChildren(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Show empty state
          if (children == null || children.isEmpty) {
            return SizedBox.expand(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No children found',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'There are no children associated with your account',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => provider.fetchChildren(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Show children list
          return RefreshIndicator(
            onRefresh: () => provider.fetchChildren(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: children.length + 2, // +2 for header card and section title
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.people),
                      ),
                      title: const Text('Children Overview'),
                      subtitle: Text('${children.length} children'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showChildrenList(context),
                    ),
                  );
                }

                if (index == 1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 16),
                      Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                }

                final child = children[index - 2];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(child.user.name[0].toUpperCase()),
                        ),
                        title: Text(child.user.name),
                        subtitle: Text('Class: ${child.currentClass}'),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showChildAttendance(context, child),
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Attendance'),
                            ),
                            TextButton.icon(
                              onPressed: () => _showChildGrades(context, child),
                              icon: const Icon(Icons.grade),
                              label: const Text('Grades'),
                            ),
                            TextButton.icon(
                              onPressed: () => _showChildTimetable(context, child),
                              icon: const Icon(Icons.schedule),
                              label: const Text('Timetable'),
                            ),
                            TextButton.icon(
                              onPressed: () => _showPaymentReceipts(context, child),
                              icon: const Icon(Icons.receipt_long),
                              label: const Text('Payment Receipts'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../models/student_record.dart';
import 'package:provider/provider.dart';
import '../../providers/parent_provider.dart';
import '../../providers/auth_provider.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  _ChildrenListScreenState createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndFetchChildren();
  }

  Future<void> _checkAuthAndFetchChildren() async {
    final authProvider = context.read<AuthProvider>();
    context.read<ParentProvider>();

    debugPrint('👤 Checking auth status...');
    debugPrint('🔐 Is authenticated: ${authProvider.isAuthenticated}');
    debugPrint('👨‍👦 Is parent: ${authProvider.userData?.isParent}');
    
    if (!authProvider.isAuthenticated) {
      debugPrint('❌ Not authenticated!');
      return;
    }

    if (authProvider.userData?.isParent != true) {
      debugPrint('❌ User is not a parent!');
      return;
    }

    await _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    try {
      debugPrint('🔄 Fetching children...');
      await context.read<ParentProvider>().fetchChildren();
      debugPrint('✅ Children fetched successfully');
    } catch (e) {
      debugPrint('❌ Error fetching children: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/parent/dashboard');
          },
        ),
        title: const Text('My Children'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchChildren,
          ),
        ],
      ),
      body: Consumer<ParentProvider>(
        builder: (context, parentProvider, child) {
          if (parentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (parentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    parentProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchChildren,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final children = parentProvider.children;
          if (children == null || children.isEmpty) {
            return const Center(
              child: Text(
                'No children records found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _fetchChildren,
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        child.user.name.substring(0, 1).toUpperCase(),
                      ),
                    ),
                    title: Text(child.user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Class: ${child.currentClass}'),
                        Text('Section: ${child.section}'),
                        Text('Admission No: ${child.admissionNumber}'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to child details
                      debugPrint('Tapped on child: ${child.user.name}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  void _showChildDetails(BuildContext context, StudentRecord child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                child.user.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Class', child.currentClass),
              _buildDetailRow('Roll Number', child.rollNumber ?? 'N/A'),
              _buildDetailRow('Section', child.section),
              _buildDetailRow('Date of Birth', child.user.dob ?? 'N/A'),
              _buildDetailRow('Gender', child.user.gender ?? 'N/A'),
              _buildDetailRow('Blood Group', child.user.bloodGroup ?? 'N/A'),
              _buildDetailRow('Address', child.address),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

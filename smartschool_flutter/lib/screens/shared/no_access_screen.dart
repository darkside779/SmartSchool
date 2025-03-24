import 'package:flutter/material.dart';

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

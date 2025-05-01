import 'package:flutter/material.dart';

class GuestActivitiesPage extends StatelessWidget {
  const GuestActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Activities'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Guest Activities Page'),
      ),
    );
  }
}
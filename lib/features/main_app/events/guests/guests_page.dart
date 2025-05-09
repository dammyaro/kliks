import 'package:flutter/material.dart';

class GuestsPage extends StatelessWidget {
  const GuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guests"),
      ),
      body: const Center(
        child: Text("Who can attend this event"),
      ),
    );
  }
}
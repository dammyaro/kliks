import 'package:flutter/material.dart';

class EntranceRequirementPage extends StatelessWidget {
  const EntranceRequirementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrance Requirement"),
      ),
      body: const Center(
        child: Text("Activate entrance points"),
      ),
    );
  }
}
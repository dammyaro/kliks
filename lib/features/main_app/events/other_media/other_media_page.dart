import 'package:flutter/material.dart';

class OtherMediaPage extends StatelessWidget {
  const OtherMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Other Media"),
      ),
      body: const Center(
        child: Text("Add other images related to this event"),
      ),
    );
  }
}
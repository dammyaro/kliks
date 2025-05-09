import 'package:flutter/material.dart';

class DateTimePage extends StatelessWidget {
  const DateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date and Time"),
      ),
      body: const Center(
        child: Text("When is it happening"),
      ),
    );
  }
}
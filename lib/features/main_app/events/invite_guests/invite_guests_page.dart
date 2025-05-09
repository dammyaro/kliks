import 'package:flutter/material.dart';

class InviteGuestsPage extends StatelessWidget {
  const InviteGuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite Guests"),
      ),
      body: const Center(
        child: Text("Add guests to this event"),
      ),
    );
  }
}
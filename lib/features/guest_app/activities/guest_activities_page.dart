import 'package:flutter/material.dart';
import 'package:kliks/shared/widgets/guest_create_account_prompt.dart';

class GuestActivitiesPage extends StatelessWidget {
  const GuestActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: GuestCreateAccountPrompt(),
      ),
    );
  }
}
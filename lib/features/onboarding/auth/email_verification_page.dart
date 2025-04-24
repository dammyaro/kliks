import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Verify Your Email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'We\'ve sent a verification link to your email address. Please check your inbox and click the link to verify your account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement verification check
                Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
              },
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                // Implement resend email logic
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
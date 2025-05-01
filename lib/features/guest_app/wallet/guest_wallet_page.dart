import 'package:flutter/material.dart';

class GuestWalletPage extends StatelessWidget {
  const GuestWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Wallet'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Guest Wallet Page'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class GuestMarketplacePage extends StatelessWidget {
  const GuestMarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Marketplace'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Guest Marketplace Page'),
      ),
    );
  }
}
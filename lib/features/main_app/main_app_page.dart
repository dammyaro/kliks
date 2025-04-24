import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/activities/activities_page.dart';
import 'package:kliks/features/main_app/home/home_page.dart';
import 'package:kliks/features/main_app/marketplace/marketplace_page.dart';
import 'package:kliks/features/main_app/wallet/wallet_page.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const WalletPage(),
    const MarketplacePage(),
    const ActivitiesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Activities',
          ),
        ],
      ),
    );
  }
}
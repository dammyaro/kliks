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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Theme.of(context).brightness == Brightness.dark
            ? (_currentIndex == 0
                ? 'assets/icons/home-darkmode-active.png'
                : 'assets/icons/home-darkmode-inactive.png')
            : (_currentIndex == 0
                ? 'assets/icons/home-lightmode-active.png'
                : 'assets/icons/home-lightmode-inactive.png'),
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Theme.of(context).brightness == Brightness.dark
            ? (_currentIndex == 1
                ? 'assets/icons/wallet-darkmode-active.png'
                : 'assets/icons/wallet-darkmode-inactive.png')
            : (_currentIndex == 1
                ? 'assets/icons/wallet-lightmode-active.png'
                : 'assets/icons/wallet-lightmode-inactive.png'),
              width: 24,
              height: 24,
            ),
            label: 'Wallet',
          ),
            // BottomNavigationBarItem(
            // icon: Image.asset(
            //   Theme.of(context).brightness == Brightness.dark
            // ? (_currentIndex == 2
            //   ? 'assets/icons/fab-darkmode-active.png'
            //   : 'assets/icons/fab-darkmode-inactive.png')
            // : (_currentIndex == 2
            //   ? 'assets/icons/fab-lightmode-active.png'
            //   : 'assets/icons/fab-lightmode-inactive.png'),
            //   width: 24,
            //   height: 24,
            // ),
            // label: 'FAB',
            // ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Theme.of(context).brightness == Brightness.dark
            ? (_currentIndex == 2
                ? 'assets/icons/marketplace-darkmode-active.png'
                : 'assets/icons/marketplace-darkmode-inactive.png')
            : (_currentIndex == 2
                ? 'assets/icons/marketplace-lightmode-active.png'
                : 'assets/icons/marketplace-lightmode-inactive.png'),
              width: 24,
              height: 24,
            ),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Theme.of(context).brightness == Brightness.dark
            ? (_currentIndex == 3
                ? 'assets/icons/activity-darkmode-active.png'
                : 'assets/icons/activity-darkmode-inactive.png')
            : (_currentIndex == 3
                ? 'assets/icons/activity-lightmode-active.png'
                : 'assets/icons/activity-lightmode-inactive.png'),
              width: 24,
              height: 24,
            ),
            label: 'Activities',
          ),
        ],
      ),
    );
  }
}
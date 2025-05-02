import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/activities/activities_page.dart';
import 'package:kliks/features/main_app/home/home_page.dart';
import 'package:kliks/features/main_app/marketplace/marketplace_page.dart';
import 'package:kliks/features/main_app/wallet/wallet_page.dart';
import 'package:kliks/features/main_app/map/map_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    const MapPage(), // Map page added here
    const MarketplacePage(),
    const ActivitiesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB action here
          print('FAB pressed');
        },
        backgroundColor: const Color(0xffbbd953), // Custom background color
        shape: CircleBorder(
          side: BorderSide(color: Colors.black, width: 2), // Black outline
        ),
        child: const Icon(Icons.add, color: Colors.black), // Black plus icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Shift FAB up slightly
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 90.h, // Set the height of the BottomNavigationBar
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Match scaffold background color
              border: Border(
                top: BorderSide(
                  color: Colors.grey[600]!, // Grey border at the top
                  width: 1.0, // Border width
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent, // Make the BottomNavigationBar background transparent
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  // Handle map button click
                  print('Map button clicked');
                  // Add your map functionality here
                } else {
                  setState(() => _currentIndex = index);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontFamily: 'Metropolis-ExtraBold', // Use Metropolis-ExtraBold when selected
                  ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                  ),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h), // Add space between icon and label
                    child: Image.asset(
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
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h), // Add space between icon and label
                    child: Image.asset(
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
                  ),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: () {
                      // Handle map button click without changing the current index
                      print('Map button clicked');
                      // Add your map functionality here
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h), // Add space between icon and label
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/icons/map-darkmode.png'
                            : 'assets/icons/map-lightmode.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h), // Add space between icon and label
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? (_currentIndex == 3
                              ? 'assets/icons/marketplace-darkmode-active.png'
                              : 'assets/icons/marketplace-darkmode-inactive.png')
                          : (_currentIndex == 3
                              ? 'assets/icons/marketplace-lightmode-active.png'
                              : 'assets/icons/marketplace-lightmode-inactive.png'),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  label: 'Marketplace',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h), // Add space between icon and label
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? (_currentIndex == 4
                              ? 'assets/icons/activity-darkmode-active.png'
                              : 'assets/icons/activity-darkmode-inactive.png')
                          : (_currentIndex == 4
                              ? 'assets/icons/activity-lightmode-active.png'
                              : 'assets/icons/activity-lightmode-inactive.png'),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  label: 'Activities',
                ),
              ],
            ),
          ),
          // Horizontal Indicator
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 5 * _currentIndex, // Position based on selected tab
            child: Container(
              width: MediaQuery.of(context).size.width / 5, // Divide equally among tabs
              height: 3.h, // Height of the indicator
              color: const Color(0xffbbd953), // Indicator color
            ),
          ),
        ],
      ),
    );
  }
}
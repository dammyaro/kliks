import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/features/main_app/activities/activities_page.dart';
import 'package:kliks/features/main_app/home/home_page.dart';
import 'package:kliks/features/main_app/marketplace/marketplace_page.dart';
import 'package:kliks/features/main_app/wallet/wallet_page.dart';
import 'package:kliks/features/main_app/map/map_page.dart';
import 'package:kliks/shared/widgets/create_event_bottomsheet.dart';

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
    const MapPage(),
    const MarketplacePage(),
    const ActivitiesPage(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CreateEventBottomSheet(),
          );
        },
        backgroundColor: const Color(0xffbbd953),
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 0),
        ),
        child: const Icon(Icons.add, color: Colors.black),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1, // Adaptive height
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[500]!,
                  width: 1.0,
                
                ),
              ),
            ),
            child: BottomNavigationBar(
              // backgroundColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  print('Map button clicked');
                } else {
                  setState(() => _currentIndex = index);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-ExtraBold',
                    color: Theme.of(context).primaryColor,
                  ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-SemiBold',
                  ),
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
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
                      filterQuality: FilterQuality.high,
                      colorBlendMode: BlendMode.dst,
                    
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
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
                    print('Map button clicked');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                      ? 'assets/icons/map-darkmode.png'
                      : 'assets/icons/map-lightmode.png',
                    width: 50,
                    height: 50,
                    filterQuality: FilterQuality.high,
                    ),
                  ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
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
                    padding: EdgeInsets.only(bottom: 8.h),
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
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 5 * _currentIndex,
            child: Container(
              width: MediaQuery.of(context).size.width / 5,
              height: 4.h,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
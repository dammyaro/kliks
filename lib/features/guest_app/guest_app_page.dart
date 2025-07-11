import 'package:flutter/material.dart';
import 'package:kliks/features/guest_app/home/guest_home_page.dart';
import 'package:kliks/features/guest_app/marketplace/guest_marketplace_page.dart';
import 'package:kliks/features/guest_app/activities/guest_activities_page.dart';
import 'package:kliks/features/guest_app/wallet/guest_wallet_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuestAppPage extends StatefulWidget {
  const GuestAppPage({super.key});

  @override
  State<GuestAppPage> createState() => _GuestAppPageState();
}

class _GuestAppPageState extends State<GuestAppPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GuestHomePage(),
    const GuestWalletPage(),
    const GuestMarketplacePage(),
    const GuestActivitiesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   backgroundColor: Colors.transparent,
          //   builder: (context) => const CreateEventBottomSheet(),
          // );
        },
        backgroundColor: const Color(0xffbbd953),
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 0),
        ),
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15, // Adaptive height
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
                    fontSize: 12.sp,
                    fontFamily: 'Metropolis-ExtraBold',
                    color: Theme.of(context).primaryColor,
                  ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
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
                      width: 24.w,
                      height: 24.h,
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
                      width: 24.w,
                      height: 24.h,
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
                    padding: EdgeInsets.only(bottom: 0.h),
                    child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                      ? 'assets/icons/map-darkmode.png'
                      : 'assets/icons/map-lightmode.png',
                    width: 50.w,
                    height: 50.h,
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
                      width: 24.w,
                      height: 24.h,
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
                      width: 24.w,
                      height: 24.h,
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
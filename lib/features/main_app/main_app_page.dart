import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/features/main_app/activities/activities_page.dart';
import 'package:provider/provider.dart';
import 'package:kliks/features/main_app/home/home_page.dart';
import 'package:kliks/features/main_app/marketplace/marketplace_page.dart';
import 'package:kliks/features/main_app/wallet/wallet_page.dart';
import 'package:kliks/features/main_app/map/map_page.dart';
import 'package:kliks/shared/widgets/create_event_bottomsheet.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/core/providers/main_app_navigation_provider.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> with TickerProviderStateMixin {
  int? _tappedIndex;
  final List<AnimationController?> _controllers = List.filled(5, null);

  final List<Widget> _pages = [
    const HomePage(),
    const WalletPage(),
    const MapPage(),
    const MarketplacePage(),
    const ActivitiesPage(),
  ];
  

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _controllers[i] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        lowerBound: 1.0,
        upperBound: 1.2,
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c?.dispose();
    }
    super.dispose();
  }

  void _onNavTap(int index) async {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.eventLocator);
      return;
    }
    setState(() => _tappedIndex = index);
    final controller = _controllers[index];
    if (controller != null) {
      await controller.forward();
      await controller.reverse();
    }
    Provider.of<MainAppNavigationProvider>(context, listen: false).setIndex(index);
    setState(() => _tappedIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<MainAppNavigationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: navigationProvider.selectedIndex,
          children: _pages,
        ),
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
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.14, // Adaptive height
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[500]!,
                  width: 0.5,
                
                ),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                currentIndex: navigationProvider.selectedIndex,
                onTap: _onNavTap,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Theme.of(context).iconTheme.color,
                selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Metropolis-ExtraBold',
                      color: Theme.of(context).primaryColor,
                    ),
                unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  for (int i = 0; i < 5; i++)
                    if (i == 2)
                      BottomNavigationBarItem(
                        icon: GestureDetector(
                          onTap: () {
                            _onNavTap(2);
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
                      )
                    else
                      BottomNavigationBarItem(
                        icon: AnimatedBuilder(
                          animation: _controllers[i]!,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: (_tappedIndex == i) ? _controllers[i]!.value : 1.0,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Image.asset(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? (navigationProvider.selectedIndex == i
                                          ? [
                                              'assets/icons/home-darkmode-active.png',
                                              'assets/icons/wallet-darkmode-active.png',
                                              '',
                                              'assets/icons/marketplace-darkmode-active.png',
                                              'assets/icons/activity-darkmode-active.png',
                                            ][i]
                                          : [
                                              'assets/icons/home-darkmode-inactive.png',
                                              'assets/icons/wallet-darkmode-inactive.png',
                                              '',
                                              'assets/icons/marketplace-darkmode-inactive.png',
                                              'assets/icons/activity-darkmode-inactive.png',
                                            ][i])
                                      : (navigationProvider.selectedIndex == i
                                          ? [
                                              'assets/icons/home-lightmode-active.png',
                                              'assets/icons/wallet-lightmode-active.png',
                                              '',
                                              'assets/icons/marketplace-lightmode-active.png',
                                              'assets/icons/activity-lightmode-active.png',
                                            ][i]
                                          : [
                                              'assets/icons/home-lightmode-inactive.png',
                                              'assets/icons/wallet-lightmode-inactive.png',
                                              '',
                                              'assets/icons/marketplace-lightmode-inactive.png',
                                              'assets/icons/activity-lightmode-inactive.png',
                                            ][i]),
                                  width: 24.w,
                                  height: 24.h,
                                  filterQuality: FilterQuality.high,
                                  colorBlendMode: BlendMode.dst,
                                ),
                              ),
                            );
                          },
                        ),
                        label: [
                          'Home',
                          'Wallet',
                          '',
                          'Marketplace',
                          'Activities',
                        ][i],
                      ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 5 * navigationProvider.selectedIndex,
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
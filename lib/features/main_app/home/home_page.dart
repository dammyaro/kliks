import 'package:flutter/material.dart';
import 'package:kliks/shared/widgets/main_app_bar.dart';
import 'package:kliks/shared/widgets/event_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/onboarding_prompt.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.h), 
          const MainAppBar(), 
          SizedBox(height: 5.h), 
          const EventFilter(),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                    TabBar(
                    labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                    unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                    labelStyle: const TextStyle(
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                    tabs: const [
                      Tab(text: 'All events'),
                      Tab(text: 'Social'),
                      Tab(text: 'Food & Drinks'),
                      Tab(text: 'Education'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(4, (index) {
                        return Column(
                          children: [
                            SizedBox(height: 20.h),
                            OnboardingPrompt(
                              onContinue: () {
                                
                                print('Onboarding continued');
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_off_outlined,
                                      size: 35.sp,
                                      color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No Events to show here',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 15.sp,
                                        fontFamily: 'Metropolis-SemiBold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'There are no events around you',
                                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
                                        fontSize: 12.sp,
                                        fontFamily: 'Metropolis-Regular',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
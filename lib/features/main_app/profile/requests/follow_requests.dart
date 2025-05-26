import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:random_avatar/random_avatar.dart';

class FollowRequestsPage extends StatefulWidget {
  const FollowRequestsPage({super.key});

  @override
  State<FollowRequestsPage> createState() => _FollowRequestsPageState();
}

class _FollowRequestsPageState extends State<FollowRequestsPage> {
  int _tabIndex = 0;

  final List<Map<String, String>> receivedRequests = [
    {
      'name': 'Jane Doe',
      'username': '@janedoe',
      'avatarSeed': 'janedoe',
    },
    {
      'name': 'Kunle A',
      'username': '@kunlearo',
      'avatarSeed': 'kunlearo',
    },
  ];

  final List<Map<String, String>> sentRequests = [
    {
      'name': 'John Smith',
      'username': '@johnsmith',
      'avatarSeed': 'johnsmith',
    },
    {
      'name': 'Ada Lovelace',
      'username': '@adalovelace',
      'avatarSeed': 'adalovelace',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget requestTile({
      required String name,
      required String username,
      required String avatarSeed,
      required List<Widget> actions,
    }) {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            RandomAvatar(
              avatarSeed,
              height: 44.sp,
              width: 44.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    username,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Follow requests'),
            SizedBox(height: 0.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _tabIndex = 0),
                      child: Column(
                        children: [
                          Text(
                            'Requests received',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: _tabIndex == 0
                                  ? const Color(0xffbbd953)
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 3.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              color: _tabIndex == 0
                                  ? const Color(0xffbbd953)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 24.w),
                    GestureDetector(
                      onTap: () => setState(() => _tabIndex = 1),
                      child: Column(
                        children: [
                          Text(
                            'Sent Requests',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: _tabIndex == 1
                                  ? const Color(0xffbbd953)
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 3.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              color: _tabIndex == 1
                                  ? const Color(0xffbbd953)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (_tabIndex == 0)
              ...receivedRequests.map(
                (user) => requestTile(
                  name: user['name']!,
                  username: user['username']!,
                  avatarSeed: user['avatarSeed']!,
                  actions: [
                    SizedBox(
                      width: 70.w,
                      child: CustomButton(
                        text: 'Reject',
                        borderRadius: 10,
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        hasBorder: true,
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Colors.red,
                        ),
                        height: 34.h,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 70.w,
                      child: CustomButton(
                        text: 'Accept',
                        borderRadius: 10,
                        onPressed: () {},
                        backgroundColor: const Color(0xffbbd953),
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Colors.black,
                        ),
                        height: 34.h,
                      ),
                    ),
                  ],
                ),
              ),
            if (_tabIndex == 1)
              ...sentRequests.map(
                (user) => requestTile(
                  name: user['name']!,
                  username: user['username']!,
                  avatarSeed: user['avatarSeed']!,
                  actions: [
                    SizedBox(
                      width: 110.w,
                      child: CustomButton(
                        text: 'Cancel request',
                        borderRadius: 10,
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        hasBorder: true,
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Colors.red,
                        ),
                        height: 34.h,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
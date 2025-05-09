import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        size: 24.sp,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'My Profile',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w), // Balance the row
                ],
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage:
                        const AssetImage('assets/icons/avatar-large.png'),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Olakunle',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 18.sp,
                                    fontFamily: 'Metropolis-SemiBold',
                                    letterSpacing: 0,
                                  ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.verified,
                                size: 16.sp, color: Colors.green),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '@kunlearoo',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 14.sp,
                                fontFamily: 'Metropolis-Regular',
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            // Icon(Icons.location_on_outlined,
                            //     size: 14.sp,
                            //     color: Theme.of(context)
                            //         .textTheme
                            //         .bodySmall
                            //         ?.color
                            //         ?.withOpacity(0.6)),
                            // SizedBox(width: 4.w),
                            Text(
                              'Ontario, Canada',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    fontFamily: 'Metropolis-Regular',
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert,
                        size: 24.sp,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(context, 'Attendance', '0%'),
                      // Container(
                      //   height: 40.h,
                      //   width: 1.w,
                      //   color: Theme.of(context).dividerColor,
                      // ),
                      _buildStatItem(context, 'Total events', '0'),
                    ],
                  ),
                  Divider(height: 32.h, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(context, 'Followers', '0'),
                      // Container(
                      //   height: 40.h,
                      //   width: 1.w,
                      //   color: Theme.of(context).dividerColor,
                      // ),
                      _buildStatItem(context, 'Following', '0'),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 32.h, thickness: 1),
            _buildSection(context, 'Bio',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
            Divider(height: 32.h, thickness: 1),
            _buildInterestsSection(context),
            Divider(height: 32.h, thickness: 1),
            _buildEventsSection(context),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontFamily: 'Metropolis-Regular',
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.6),
        ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: 0,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  fontFamily: 'Metropolis-Regular',
                ),
          ),
        ],
      ),
    );
  }

  
Widget _buildInterestsSection(BuildContext context) {
  final interests = [
    'Social & Networking',
    'Food & Drinks',
    'Games & Hobbies'
  ];
  
  return Padding(
    padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              Text(
                'Interests',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: 0,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: interests
                .map((interest) => Chip(
                      label: Text(interest),
                      backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                    ))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Events',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: 0,
                ),
          ),
        ),
        SizedBox(height: 16.h),
        DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodySmall?.color,
                labelStyle: const TextStyle(
                  fontFamily: 'Metropolis-SemiBold',
                ),
                tabs: const [
                  Tab(text: 'My Events'),
                  Tab(text: 'Blocked'),
                  Tab(text: 'Invitations'),
                  Tab(text: 'Saved'),
                ],
              ),
              SizedBox(
                height: 200.h,
                child: TabBarView(
                  children: List.generate(4, (index) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                            width: 35.sp,
                            height: 35.sp,
                            decoration: BoxDecoration(
                              color: const Color(0xffbbd953),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            ),
                          SizedBox(height: 16.h),
                          Text(
                            'No events',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 15.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Add new events, invite your friends,\nadded events will appear here',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withOpacity(0.4),
                                  fontSize: 12.sp,
                                  fontFamily: 'Metropolis-Regular',
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
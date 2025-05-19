import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart'; // Update this import path to the actual location of AuthProvider

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
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                      child: Image.asset(
                        'assets/icons/avatar-large.png',
                        width: 100.r,
                        height: 100.r,
                        // fit: BoxFit.cover,
                      ),
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
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontSize: 18.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.verified,
                              size: 16.sp,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '@kunlearoo',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontFamily: 'Metropolis-Regular',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              'Ontario, Canada',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                fontSize: 10.sp,
                                fontFamily: 'Metropolis-Regular',
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: 24.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // <-- Make the bottom sheet full width
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left:
                                  0, // Remove horizontal padding for full width
                              right: 0,
                              top: 30.h,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 25.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_add_outlined,
                                          size: 18.sp,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.copyWith(
                                                fontSize: 12.sp,
                                                fontFamily:
                                                    'Metropolis-SemiBold',
                                                letterSpacing: 0,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Follow requests ',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '+2',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14.sp,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                _buildSheetOption(
                                  context,
                                  icon: Icons.settings_outlined,
                                  text: 'Settings & Privacy',
                                    onTap: () {
                                    // Navigator.pop(context);
                                    Navigator.pushNamed(context, '/settings');
                                  },
                                ),
                                SizedBox(height: 8.h),
                                _buildSheetOption(
                                  context,
                                  icon: Icons.exit_to_app,
                                  text: 'Log out',
                                  onTap: () {
                                    Navigator.pop(context); // Close bottom sheet
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                      final screenWidth = MediaQuery.of(context).size.width;
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                        borderRadius:
                                          BorderRadius.circular(20.r),
                                        ),
                                        child: SizedBox(
                                        width: screenWidth * 0.9,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                            vertical: 32.h),
                                          child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                            Icons.exit_to_app_outlined,
                                            size: 30.sp,
                                            color: Colors.red,
                                            ),
                                            SizedBox(height: 24.h),
                                            Text(
                                            'Log out',
                                            style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                letterSpacing: 0,
                                                fontSize: 18.sp,
                                                fontFamily:
                                                  'Metropolis-SemiBold',
                                                
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                            Text(
                                            'Are you sure you want to log out\n@kunlearoo from Kliks',
                                            style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 12.sp,
                                                letterSpacing: 0,
                                                color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color
                                                  ?.withOpacity(0.7),
                                              ),
                                            textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 32.h),
                                            Row(
                                            children: [
                                              Expanded(
                                              child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Dismiss dialog
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(color: Colors.transparent), // invisible border
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                                ),
                                              ),
                                                child: Text(
                                                'Cancel',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontFamily: 'Metropolis-SemiBold',
                                                fontSize: 14.sp,
                                                ),
                                                ),
                                              ),
                                              
                                              ),
                                              SizedBox(width: 16.w),
                                              Expanded(
                                                child: TextButton(
                                                onPressed: () async {
                                                final navigator = Navigator.of(context);
                                                final provider = Provider.of<AuthProvider>(context, listen: false);
                                                await provider.logout();
                                                navigator.popUntil((route) => route.isFirst);
                                                },
                                                style: TextButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                side: BorderSide(color: Colors.transparent), // invisible border
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                                ),
                                                ),
                                                child: Text(
                                                'Log out',
                                                style: TextStyle(
                                                fontFamily: 'Metropolis-SemiBold',
                                                fontSize: 14.sp,
                                                color: Colors.red,
                                                ),
                                                ),
                                                ),
                                              ),
                                              
                                            ],
                                            ),
                                          ],
                                          ),
                                        ),
                                        ),
                                      );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 8.h),
                                _buildSheetOption(
                                  context,
                                  icon: Icons.share_outlined,
                                  text: 'Share profile',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Divider(height: 32.h, thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(context, 'Attendance', '0%'),
                      _buildStatItem(context, 'Total events', '0'),
                    ],
                  ),
                  Divider(height: 32.h, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(context, 'Followers', '0'),
                      _buildStatItem(context, 'Following', '0'),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 32.h, thickness: 1),
            _buildSection(
              context,
              'Bio',
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
            ),
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 16.sp,
            fontFamily: 'Metropolis-Regular',
            letterSpacing: -1,
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.6),
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
              fontSize: 12.sp,
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
      'Games & Hobbies',
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
              children:
                  interests
                      .map(
                  (interest) => Chip(
                    label: Text(
                      interest,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        letterSpacing: 0,
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                  ),
                      )
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
                labelStyle: const TextStyle(fontFamily: 'Metropolis-SemiBold'),
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Add new events, invite your friends,\nadded events will appear here',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.4),
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

  Widget _buildSheetOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: Theme.of(context).iconTheme.color),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                  color:
                      textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: 0,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}

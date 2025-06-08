import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart'; // Update this import path to the actual location of AuthProvider
import 'package:share_plus/share_plus.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).profile;
    // printWrapped('Profile: \\${profile}');
    final fullName = profile?['fullname'] ?? 'Kliks User';
    final username = profile?['username'] ?? '@kliksuser';
    final bio = profile?['about'] ?? '';
    final kycStatusSumsub = profile?['kycStatusSumub'];
    final userId = profile?['id'] ?? '';
    final interests = profile?['categories'];
    final profilePictureFileName = profile?['image'];
    final followerCount = profile?['followersCount'] ?? 0;
    final followingCount = profile?['followingCount'] ?? 0;
    // final location = profile?['location'] ?? 'Ontario, Canada';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  CustomNavBar(title: 'My Profile'),
                ],
              ),
            ),
            SizedBox(height: 0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    GestureDetector(
                      onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                      },
                      child: SizedBox(
                      width: 100.r,
                      height: 100.r,
                        child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: 
                              ProfilePicture(
                                  fileName: profilePictureFileName,
                                  folderName: 'profile_pictures',
                                  size: 100.r,
                                  userId: userId,
                                )
                              // : RandomAvatar(
                              //     userId,
                              //     height: 100.r,
                              //     width: 100.r,
                              //   ),
                          ),
                          Positioned(
                          bottom: -4.r,
                          right: -4.r,
                          child: Container(
                            decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              ),
                            ],
                            ),
                            padding: EdgeInsets.all(6.r),
                            child: Icon(
                            Icons.edit_outlined,
                            size: 20.sp,
                            color: Colors.green,
                            ),
                          ),
                          ),
                        ],
                        ),
                      ),
                    ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: [
                            Text(
                              fullName.length > 10
                                ? '${fullName.substring(0, 10)}...'
                                : fullName,
                              style: Theme.of(
                              context,
                              ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              letterSpacing: -1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            if (kycStatusSumsub == null)
                              TextButton(
                              onPressed: () {
                                // Navigate to verification page or handle verification
                                Navigator.pushNamed(context, '/settings');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                color: Colors.green,
                                width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                fontSize: 6.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                color: Colors.green,
                                ),
                              ),
                              )
                            else
                              Icon(
                              Icons.verified,
                              size: 16.sp,
                              color: Colors.green,
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '@$username',
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
                        // backgroundColor:
                        //     Theme.of(context).scaffoldBackgroundColor,
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
                              top: 20.h,
                              // bottom: MediaQuery.of(context).viewInsets.bottom,
                              bottom: 20.h
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // BackdropFilter(
                                //   filter: ImageFilter.blur(
                                //       sigmaX: 10.0, sigmaY: 10.0),
                                //   child: Container(
                                //     color: Colors.black.withOpacity(0.1),
                                //   ),
                                // ),
                                const HandleBar(),
                                // SizedBox(height: 16.h),
                                InkWell(
                                    onTap: () {
                                    // Navigator.pop(context);
                                    Navigator.pushNamed(context, '/follow-requests');
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
                                                    fontSize: 14.sp,
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
                                                // navigator.popUntil((route) => route.isFirst);
                                                navigator.pushReplacementNamed('/');
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
                                  onTap: () async {
                                    Navigator.pop(context);
                                    // Replace with your actual profile link or info
                                    await Share.share('Check out my Kliks profile: https://kliks.app/u/kunlearoo');
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
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildStatItem(context, 'Attendance', '0%', align: TextAlign.left)),
                    Expanded(child: _buildStatItem(context, 'Total events', '0', align: TextAlign.right)),
                  ],
                  ),
                  Divider(height: 32.h, thickness: 1),
                  GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/people');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(child: _buildStatItem(context, 'Followers', followerCount.toString(), align: TextAlign.left)),
                    Expanded(child: _buildStatItem(context, 'Following', followingCount.toString(), align: TextAlign.right)),
                    ],
                  ),
                  ),
                ],
              ),
            ),
            Divider(height: 32.h, thickness: 1),
            _buildSection(
              context,
              'Bio',
               bio,
            ),
            Divider(height: 32.h, thickness: 1),
            _buildInterestsSection(context, interests),
            Divider(height: 32.h, thickness: 1),
            _buildEventsSection(context),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, {TextAlign align = TextAlign.left}) {
    return Column(
      crossAxisAlignment: align == TextAlign.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          textAlign: align,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18.sp,
            fontFamily: 'Metropolis-SemiBold',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: align,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 14.sp,
            fontFamily: 'Metropolis-Regular',
            letterSpacing: -0.5,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(BuildContext context, dynamic interests) {
    final List<String> interestsList = interests != null && interests is List ? List<String>.from(interests) : [];
    final allInterests = [
      'Social & Networking',
      'Health & Wellness',
      'Education & Learning',
      'Sports & Fitness',
      'Environment & Nature',
      'Fashion & Beauty',
      'Technology & Science',
      'Arts & Culture',
      'Travel & Adventure',
      // 'Food & Drinks',
      // 'Games & Hobbies',
      // 'Tech & Startups',
      // 'Music & Concerts',
      // 'Business & Finance',
      // 'Photography',
      // 'Movies & Entertainment',
      // 'Volunteering',
      // 'Other',
    ];

    void showInterestSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) {
          // Use StatefulBuilder to manage selection state inside the bottom sheet
          List<String> tempSelected = List<String>.from(interestsList);
          bool isLoading = false;
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                  top: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HandleBar(),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        'Select your interests',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20.sp,
                          fontFamily: 'Metropolis-SemiBold',
                        ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                        'This will let us know what kind of events\nto show you',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontFamily: 'Metropolis-Regular',
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                        ),
                      ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          alignment: WrapAlignment.start,
                          children: [
                            for (var interest in allInterests)
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    if (tempSelected.contains(interest)) {
                                      tempSelected.remove(interest);
                                    } else {
                                      tempSelected.add(interest);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: tempSelected.contains(interest)
                                        ? (Theme.of(context).brightness == Brightness.light
                                            ? Colors.grey[800]
                                            : Colors.white)
                                        : (Theme.of(context).brightness == Brightness.light
                                            ? Colors.grey[300]
                                            : Colors.grey[800]),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        interest,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          letterSpacing: 0,
                                          color: tempSelected.contains(interest)
                                              ? (Theme.of(context).brightness == Brightness.light
                                                  ? Colors.white
                                                  : Colors.black)
                                              : (Theme.of(context).brightness == Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (tempSelected.contains(interest)) ...[
                                        SizedBox(width: 6.w),
                                        Icon(
                                          Icons.close,
                                          size: 13.sp,
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: StatefulBuilder(
                        builder: (context, setButtonState) {
                          Future<void> handleUpdateInterests() async {
                            setButtonState(() { isLoading = true; });
                            final provider = Provider.of<AuthProvider>(context, listen: false);
                            final success = await provider.updateCategories(categories: tempSelected);
                            setButtonState(() { isLoading = false; });
                            if (success) {
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to update interests')),
                              );
                            }
                          }

                          return CustomButton(
                            text: 'Save',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : handleUpdateInterests,
                            backgroundColor: const Color(0xffbbd953),
                            textColor: Colors.black,
                            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
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
              runSpacing: 0.h,
              children: [
                ...interestsList.map(
                  (interest) => Chip(
                    label: Text(
                      interest,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        letterSpacing: 0,
                      ),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                GestureDetector(
                  onTap: showInterestSheet,
                  child: Chip(
                    label: Icon(Icons.add_outlined, size: 16.sp, color: Theme.of(context).iconTheme.color),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
              ],
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
                  fontSize: 14.sp,
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

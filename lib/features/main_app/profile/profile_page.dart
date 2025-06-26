import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/utils/print_wrapped.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart'; // Update this import path to the actual location of AuthProvider
import 'package:share_plus/share_plus.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kliks/shared/widgets/create_event_bottomsheet.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/profile_event_card.dart';
import 'package:kliks/core/providers/saved_events_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<dynamic> _myEvents = [];
  bool _isLoadingEvents = true;

  // Add state for categories
  List<String> _allCategories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
    _fetchCategories();
  }

  Future<void> _loadMyEvents() async {
    setState(() => _isLoadingEvents = true);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final events = await eventProvider.getMyEvents();
    print('Events: \\$events');
    setState(() {
      _myEvents = events;
      _isLoadingEvents = false;
    });
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoadingCategories = true);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final cats = await eventProvider.getAllCategory();
    setState(() {
      _allCategories = cats.map<String>((cat) {
        if (cat is String) return cat;
        if (cat is Map && cat['category'] != null) return cat['category'].toString();
        return '';
      }).where((cat) => cat.isNotEmpty).toList();
      _isLoadingCategories = false;
    });
  }

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
    final followerCount = profile?['followerCount'] ?? 0;
    final followingCount = profile?['followingCount'] ?? 0;
    // final location = profile?['location'] ?? 'Ontario, Canada';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(children: [CustomNavBar(title: 'My Profile')]),
            ),
            // SizedBox(height: 24.h),
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
                            child: ProfilePicture(
                              fileName: profilePictureFileName,
                              folderName: 'profile_pictures',
                              size: 100.r,
                              userId: userId,
                            ),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                    child: _ProfileHeaderColumn(
                      fullName: fullName,
                      username: username,
                      kycStatusSumsub: kycStatusSumsub,
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
                              bottom: 20.h,
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
                                _buildSheetOption(
                                  context,
                                  icon: Icons.person_add_outlined,
                                  text: 'Follow requests',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/follow-requests',
                                    );
                                  },
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
                                    Navigator.pop(
                                      context,
                                    ); // Close bottom sheet
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        final screenWidth =
                                            MediaQuery.of(context).size.width;
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: screenWidth * 0.9,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 32.h,
                                              ),
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
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge?.copyWith(
                                                      letterSpacing: 0,
                                                      fontSize: 18.sp,
                                                      fontFamily:
                                                          'Metropolis-SemiBold',
                                                    ),
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  Text(
                                                    'Are you sure you want to log out\nfrom Kliks',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontSize: 12.sp,
                                                          letterSpacing: 0,
                                                          color: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color
                                                              ?.withOpacity(
                                                                0.7,
                                                              ),
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 32.h),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            ); // Dismiss dialog
                                                          },
                                                          style: OutlinedButton.styleFrom(
                                                            side: BorderSide(
                                                              color:
                                                                  Colors
                                                                      .transparent,
                                                            ), // invisible border
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12.r,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Cancel',
                                                            style: Theme.of(
                                                                  context,
                                                                )
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  fontFamily:
                                                                      'Metropolis-SemiBold',
                                                                  fontSize:
                                                                      14.sp,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 16.w),
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            final navigator =
                                                                Navigator.of(
                                                                  context,
                                                                );
                                                            final provider =
                                                                Provider.of<
                                                                  AuthProvider
                                                                >(
                                                                  context,
                                                                  listen: false,
                                                                );
                                                            final savedEventsProvider =
                                                                Provider.of<
                                                                  SavedEventsProvider
                                                                >(
                                                                  context,
                                                                  listen: false,
                                                                );
                                                            await savedEventsProvider
                                                                .clearSavedEvents();
                                                            await provider
                                                                .logout();
                                                            // navigator.popUntil((route) => route.isFirst);
                                                            navigator
                                                                .pushReplacementNamed(
                                                                  '/',
                                                                );
                                                          },
                                                          style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            side: BorderSide(
                                                              color:
                                                                  Colors
                                                                      .transparent,
                                                            ), // invisible border
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12.r,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Log out',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Metropolis-SemiBold',
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
                                    await Share.share(
                                      'Check out my Kliks profile: https://kliks.app/u/kunlearoo',
                                    );
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
            SizedBox(
              width: double.infinity,
              child: Divider(
                height: 32.h,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'Attendance',
                          '0%',
                          align: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'Total events',
                          '0',
                          align: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Divider(
                    height: 32.h,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/people');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Followers',
                            followerCount.toString(),
                            align: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Following',
                            followingCount.toString(),
                            align: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Divider(
                height: 32.h,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ),
            _buildSection(context, 'Bio', bio),
            SizedBox(
              width: double.infinity,
              child: Divider(
                height: 32.h,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ),
            _buildInterestsSection(context, interests),
            SizedBox(
              width: double.infinity,
              child: Divider(
                height: 32.h,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ),
            _buildEventsSection(context),
            SizedBox(height: 40.h),
            // SizedBox(height: 100.h), // Extra bottom padding for more events
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value, {
    TextAlign align = TextAlign.left,
  }) {
    return Column(
      crossAxisAlignment:
          align == TextAlign.right
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          textAlign: align,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 20.sp,
            fontFamily: 'Metropolis-SemiBold',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: align,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                fontSize: 14.sp,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(BuildContext context, dynamic interests) {
    final List<String> interestsList =
        interests != null && interests is List
            ? List<String>.from(interests)
            : [];

    void showInterestSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) {
          List<String> tempSelected = List<String>.from(interestsList);
          bool isLoading = false;
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 25.w,
                  right: 25.w,
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 20.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'This will let us know what kind of events\nto show you',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              fontFamily: 'Metropolis-Regular',
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Expanded(
                      child: _isLoadingCategories
                          ? Center(
                              child: CircularProgressIndicator(
                                color: const Color(0xffbbd953),
                              ),
                            )
                          : _allCategories.isEmpty
                              ? Center(
                                  child: Text(
                                    'No categories found',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 10.w,
                                    runSpacing: 10.h,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      for (var interest in _allCategories)
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
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
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
                                                ],
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
                            setButtonState(() {
                              isLoading = true;
                            });
                            final provider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            final success = await provider.updateCategories(
                              categories: tempSelected,
                            );
                            setButtonState(() {
                              isLoading = false;
                            });
                            if (success) {
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                    child: Text('Failed to update interests'),
                                  ),
                                ),
                              );
                            }
                          }

                          return CustomButton(
                            text: 'Save',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : handleUpdateInterests,
                            backgroundColor: const Color(0xffbbd953),
                            textColor: Colors.black,
                            textStyle: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
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
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0),
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
            padding: EdgeInsets.only(left: 0),
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
                        fontFamily: 'Metropolis-Medium',
                        letterSpacing: 0,
                      ),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                GestureDetector(
                  onTap: showInterestSheet,
                  child: Chip(
                    label: Icon(
                      Icons.add_outlined,
                      size: 14.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18.sp,
              fontFamily: 'Metropolis-SemiBold',
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 16.h),
          DefaultTabController(
            length: 4,
            child: Column(
              children: [
                TabBar(
                  isScrollable: false,
                  indicatorColor: const Color(0xffbbd953),
                  labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.bodySmall?.color,
                  labelStyle: const TextStyle(fontFamily: 'Metropolis-Medium'),
                  tabs: const [
                    Tab(text: 'My Events'),
                    Tab(text: 'Booked'),
                    Tab(text: 'Invitations'),
                    Tab(text: 'Saved'),
                  ],
                ),
                SizedBox(
                  height: 400.h, // Increased from 400.h by 100.h
                  child: TabBarView(
                    children: [
                      // My Events Tab
                      Builder(
                        builder: (context) {
                          return _PaginatedEventsTab(
                            events: _myEvents,
                            isLoading: _isLoadingEvents,
                            emptyText: 'No events',
                            emptySubText:
                                'Add new events, invite your friends,\nadded events will appear here',
                          );
                        },
                      ),
                      // Blocked Tab
                      Builder(
                        builder: (context) {
                          // Replace with actual blocked events list and loading state if available
                          final List<dynamic> bookedEvents = [];
                          final bool isLoadingBooked = false;
                          return _PaginatedEventsTab(
                            events: bookedEvents,
                            isLoading: isLoadingBooked,
                            emptyText: 'No booked events',
                            emptySubText:
                                'Events you have booked will appear here',
                          );
                        },
                      ),
                      // Invitations Tab
                      Builder(
                        builder: (context) {
                          final eventProvider = Provider.of<EventProvider>(
                            context,
                            listen: false,
                          );
                          return FutureBuilder<List<dynamic>>(
                            future: eventProvider.getInvitedEvents(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: const Color(0xffbbd953),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                );
                              }
                              final invitedEvents = snapshot.data ?? [];
                              return _PaginatedEventsTab(
                                events: invitedEvents,
                                isLoading: false,
                                emptyText: 'No invitations',
                                emptySubText:
                                    'Events you are invited to will appear here',
                              );
                            },
                          );
                        },
                      ),
                      // Saved Tab
                      Builder(
                        builder: (context) {
                          final savedEventsProvider =
                              Provider.of<SavedEventsProvider>(context);
                          final eventProvider = Provider.of<EventProvider>(
                            context,
                            listen: false,
                          );
                          final savedEventIds =
                              savedEventsProvider.getSavedEventIds();

                          if (savedEventIds.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No saved events',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontSize: 15.sp,
                                      fontFamily: 'Metropolis-Medium',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Events you save will appear here',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.4),
                                      fontSize: 10.sp,
                                      fontFamily: 'Metropolis-Regular',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return _SavedEventsPaginated(
                            savedEventIds: savedEventIds,
                            eventProvider: eventProvider,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: 0,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: [
                    TextSpan(text: text),
                  ],
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

class _ProfileHeaderColumn extends StatefulWidget {
  final String fullName;
  final String username;
  final dynamic kycStatusSumsub;
  const _ProfileHeaderColumn({
    required this.fullName,
    required this.username,
    required this.kycStatusSumsub,
  });

  @override
  State<_ProfileHeaderColumn> createState() => _ProfileHeaderColumnState();
}

class _ProfileHeaderColumnState extends State<_ProfileHeaderColumn> {
  String _locationText = 'Ontario, Canada';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _locationText = '${place.locality ?? ''}, ${place.country ?? ''}'
              .trim()
              .replaceAll(RegExp(r'^,|,$'), '');
        });
      } else {
        setState(() {
          _locationText = 'Location not found';
        });
      }
    } catch (e) {
      setState(() {
        _locationText = 'Location error';
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.fullName.length > 14
                  ? '${widget.fullName.substring(0, 14)}...'
                  : widget.fullName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20.sp,
                fontFamily: 'Metropolis-SemiBold',
                letterSpacing: -1,
              ),
            ),
            SizedBox(width: 4.w),
            if (widget.kycStatusSumsub != null)
              Icon(Icons.verified, size: 16.sp, color: Colors.green),
          ],
        ),
        if (widget.kycStatusSumsub == null) ...[
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(color: Colors.green, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Verify',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: Colors.green,
              ),
            ),
          ),
        ],
        SizedBox(height: 4.h),
        Text(
          '@${widget.username}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontFamily: 'Metropolis-Regular',
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: Text(
                _isLoadingLocation ? 'Getting location...' : _locationText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  fontFamily: 'Metropolis-Regular',
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SavedEventsPaginated extends StatefulWidget {
  final List<String> savedEventIds;
  final EventProvider eventProvider;
  const _SavedEventsPaginated({
    required this.savedEventIds,
    required this.eventProvider,
  });

  @override
  State<_SavedEventsPaginated> createState() => _SavedEventsPaginatedState();
}

class _SavedEventsPaginatedState extends State<_SavedEventsPaginated> {
  static const int pageSize = 4;
  int currentPage = 0;
  late Future<List<Map<String, dynamic>?>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _fetchEventsForPage(currentPage);
  }

  Future<List<Map<String, dynamic>?>> _fetchEventsForPage(int page) async {
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, widget.savedEventIds.length);
    final ids = widget.savedEventIds.sublist(start, end);
    return Future.wait(
      ids.map((id) => widget.eventProvider.getEventDetailById(id)),
    );
  }

  void _goToPage(int page) {
    setState(() {
      currentPage = page;
      _futureEvents = _fetchEventsForPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.savedEventIds.length / pageSize).ceil();
    return Column(
      children: [
        FutureBuilder<List<Map<String, dynamic>?>>(
          future: _futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: const Color(0xffbbd953),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No saved events'));
            }
            final savedEvents =
                snapshot.data!
                    .where((event) => event != null)
                    .map(
                      (event) =>
                          event?['eventDocument'] as Map<String, dynamic>?,
                    )
                    .where((eventDoc) => eventDoc != null)
                    .cast<Map<String, dynamic>>()
                    .toList();
            return GridView.builder(
              padding: EdgeInsets.only(top: 16.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.7,
              ),
              itemCount: savedEvents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, idx) {
                return ProfileEventCard(event: savedEvents[idx]);
              },
            );
          },
        ),
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (i) {
                final isSelected = i == currentPage;
                return GestureDetector(
                  onTap: () => _goToPage(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 24 : 16,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xffbbd953)
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _PaginatedEventsTab extends StatefulWidget {
  final List<dynamic> events;
  final bool isLoading;
  final String emptyText;
  final String emptySubText;
  const _PaginatedEventsTab({
    required this.events,
    required this.isLoading,
    required this.emptyText,
    required this.emptySubText,
  });

  @override
  State<_PaginatedEventsTab> createState() => _PaginatedEventsTabState();
}

class _PaginatedEventsTabState extends State<_PaginatedEventsTab> {
  static const int pageSize = 4;
  int currentPage = 0;

  void _goToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.events.length / pageSize).ceil();
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: const Color(0xffbbd953),
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (widget.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.emptyText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15.sp,
                fontFamily: 'Metropolis-Medium',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              widget.emptySubText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.4),
                fontSize: 10.sp,
                fontFamily: 'Metropolis-Regular',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    final start = currentPage * pageSize;
    final end = (start + pageSize).clamp(0, widget.events.length);
    final eventsToShow = widget.events.sublist(start, end);
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.only(top: 16.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.7,
          ),
          itemCount: eventsToShow.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            return ProfileEventCard(event: eventsToShow[idx]);
          },
        ),
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (i) {
                final isSelected = i == currentPage;
                return GestureDetector(
                  onTap: () => _goToPage(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 24 : 16,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xffbbd953)
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

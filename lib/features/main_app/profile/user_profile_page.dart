import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:kliks/core/debug/printWrapped.dart';

// TODO: Make sure Names are unique 

enum RequestStatus {
  notFollowing,
  requested,
  following,
}

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserProfilePage({
    super.key,
    required this.userData,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  RequestStatus _requestStatus = RequestStatus.notFollowing;
  bool _isLoading = false;
  Map<String, dynamic>? _extraUserData;
  bool _isExtraLoading = true;
  bool _isBlocking = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileAndFollowingStatus();
  }

  Future<void> _fetchUserProfileAndFollowingStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final followProvider = Provider.of<FollowProvider>(context, listen: false);
    final userId = widget.userData['id']?.toString();
    String? fullname;
    Map<String, dynamic>? extraData;
    if (userId != null) {
      extraData = await authProvider.getUserById(userId);
    }
    fullname = extraData?['fullname'] ?? widget.userData['fullname'];
    printWrapped('Fullname: $fullname');
    setState(() {
      _extraUserData = extraData;
    });
    RequestStatus status = RequestStatus.notFollowing;
    if (fullname != null) {
      final followings = await followProvider.fetchFollowings(searchName: fullname);
      printWrapped('Followings here: $followings');
      if (followings.isNotEmpty) {
        final following = followings.first;
        if (following['isAccepted'] == true) {
          status = RequestStatus.following;
        } else {
          status = RequestStatus.requested;
        }
      }
    }
    printWrapped('Status: $status');
    setState(() {
      _isExtraLoading = false;
      _requestStatus = status;
    });
  }

  Future<void> _handleFollow() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final userId = widget.userData['id'].toString();
    final success = await provider.followUser(userId);
    setState(() {
      _isLoading = false;
      if (success) _requestStatus = RequestStatus.following;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text(success ? 'Followed successfully' : 'Failed to follow')),
      ),
    );
  }

  Future<void> _handleRequest() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final userId = widget.userData['id'].toString();
    final success = await provider.followUser(userId);
    setState(() {
      _isLoading = false;
      if (success) _requestStatus = RequestStatus.requested;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text(success ? 'Request sent' : 'Failed to send request')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isExtraLoading) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }
    final fullName = _extraUserData?['fullname'] ?? widget.userData['fullname'] ?? 'Kliks User';
    final username = _extraUserData?['username'] ?? widget.userData['username'] ?? '@kliksuser';
    final bio = _extraUserData?['about'] ?? widget.userData['about'] ?? '';
    final userId = widget.userData['id'] ?? '';
    final interests = _extraUserData?['categories'] ?? widget.userData['categories'];
    final profilePictureFileName = _extraUserData?['image'] ?? widget.userData['image'];
    final followerCount = _extraUserData?['followersCount'] ?? widget.userData['followersCount'] ?? 0;
    final followingCount = _extraUserData?['followingCount'] ?? widget.userData['followingCount'] ?? 0;
    final isPrivateAccount = _extraUserData?['isPrivateAccount'] ?? widget.userData['isPrivateAccount'] ?? false;
    final allowFollowing = _extraUserData?['allowFollowing'] ?? widget.userData['allowFollowing'] ?? true;
    final showFollowers = _extraUserData?['showFollowers'] ?? widget.userData['showFollowers'] ?? true;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  CustomNavBar(title: '@$username'),
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
                      // Optionally allow viewing avatar fullscreen or similar
                    },
                    child: SizedBox(
                    width: 100.r,
                    height: 100.r,
                    child: ProfilePicture(
                      fileName: profilePictureFileName,
                      folderName: 'profile_pictures',
                      size: 100.r,
                      userId: userId,
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
                                    fullName,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 18.sp,
                                      fontFamily: 'Metropolis-SemiBold',
                                    ),
                            ),
                          ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '@$username',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      fontFamily: 'Metropolis-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert, size: 24.sp),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: 20.h,
                                        bottom: 20.h,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const HandleBar(),
                                          _buildSheetOption(
                                            context,
                                            icon: Icons.report_outlined,
                                            text: 'Report this person',
                                            textColor: Theme.of(context).textTheme.bodySmall?.color,
                                            onTap: () {
                                              Navigator.pop(context);
                                              // Handle report action
                                            },
                                          ),
                                          _buildSheetOption(
                                            context,
                                            icon: Icons.block_outlined,
                                            text: 'Block this person',
                                            textColor: Theme.of(context).textTheme.bodySmall?.color,
                                            onTap: () async {
                                              Navigator.pop(context);
                                              setState(() { _isBlocking = true; });
                                              final provider = Provider.of<FollowProvider>(context, listen: false);
                                              final success = await provider.blockUser(userId.toString());
                                              setState(() { _isBlocking = false; });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                        content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text(success ? 'User blocked successfully' : 'Failed to block user')),
                                                ),
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
            SizedBox(height: 8.h),
            Divider(height: 32.h, thickness: 1),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (allowFollowing)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: () {
                        if (isPrivateAccount) {
                          if (_requestStatus == RequestStatus.requested) {
                            return CustomButton(
                              text: 'Requested',
                              onPressed: null,
                              isLoading: _isLoading,
                              backgroundColor: Colors.grey.shade600,
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: Colors.black,
                              ),
                            );
                          } else if (_requestStatus == RequestStatus.following) {
                            return CustomButton(
                              text: 'Following',
                              onPressed: null,
                              isLoading: _isLoading,
                              backgroundColor: Colors.grey.shade600,
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: Colors.black,
                              ),
                            );
                          } else {
                            return CustomButton(
                              text: 'Request',
                              onPressed: _isLoading ? null : _handleRequest,
                              isLoading: _isLoading,
                              backgroundColor: const Color(0xffbbd953),
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: Colors.black,
                              ),
                            );
                          } 
                        } else {
                          if (_requestStatus == RequestStatus.following) {
                            return CustomButton(
                              text: 'Following',
                              onPressed: null,
                              isLoading: _isLoading,
                              backgroundColor: Colors.grey.shade600,
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: Colors.black,
                              ),
                            );
                          } else {
                            return CustomButton(
                              text: 'Follow',
                              onPressed: _isLoading ? null : _handleFollow,
                              isLoading: _isLoading,
                              backgroundColor: const Color(0xffbbd953),
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: Colors.black,
                              ),
                            );
                          }
                        }
                      }(),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildStatItem(context, 'Attendance', '0%', align: TextAlign.left)),
                        Expanded(child: _buildStatItem(context, 'Total events', '0', align: TextAlign.right)),
                      ],
                    ),
            ),
            Divider(height: 32.h, thickness: 1, indent: 0, endIndent: 0),
                    GestureDetector(
                      onTap: () {
                // Optionally navigate to people page
                      },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _buildStatItem(context, 'Followers', followerCount.toString(), align: TextAlign.left)),
                          Expanded(child: _buildStatItem(context, 'Following', followingCount.toString(), align: TextAlign.right)),
                        ],
                      ),
              ),
            ),
            Divider(height: 32.h, thickness: 1, indent: 0, endIndent: 0),
            _buildSection(context, 'Bio', bio),
            Divider(height: 32.h, thickness: 1, indent: 0, endIndent: 0),
            _buildInterestsSection(context, interests),
            Divider(height: 32.h, thickness: 1, indent: 0, endIndent: 0),
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
            letterSpacing: -1,
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
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
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 20.w, right: 20.w),
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
                    fontSize: 20.sp,
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
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        letterSpacing: 0,
                      ),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                labelStyle: const TextStyle(fontFamily: 'Metropolis-SemiBold'),
                tabs: const [
                  Tab(text: 'Events'),
                  Tab(text: 'Blocked'),
                ],
              ),
              SizedBox(
                height: 200.h,
                child: TabBarView(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No events',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'This user has no events yet',
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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No blocked users',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 15.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'You have not blocked any users yet',
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
                  ],
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
            Icon(icon, size: 18.sp, color: textColor ?? Theme.of(context).iconTheme.color),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
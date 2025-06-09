import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

//TODO: Change the following list to where isAccepted is false and userFollowing
// The list here just mimicks a private account

class FollowRequestsPage extends StatefulWidget {
  const FollowRequestsPage({super.key});

  @override
  State<FollowRequestsPage> createState() => _FollowRequestsPageState();
}

class _FollowRequestsPageState extends State<FollowRequestsPage> {
  int _tabIndex = 0;
  List<Map<String, dynamic>> receivedRequests = [];
  List<Map<String, dynamic>> followingRequests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFollowers();
    _fetchFollowings();
  }

  Future<void> _fetchFollowers() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final followers = await provider.fetchFollowers();
    setState(() {
      receivedRequests = followers;
      _isLoading = false;
    });
  }

  Future<void> _fetchFollowings() async {
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final followings = await provider.fetchFollowings();
    setState(() {
      followingRequests = followings;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget requestTile({
      required String name,
      required String username,
      required String avatarSeed,
      required List<Widget> actions,
      String? imageUrl,
      String? userId,
      required Map<String, dynamic> userData,
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
            GestureDetector(
              onTap: () {
                if (userId != null && userId.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/user-profile',
                    arguments: userData,
                  );
                }
              },
              child: ProfilePicture(
              fileName: imageUrl,
              userId: userId ?? '',
              size: 44.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (userId != null && userId.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          '/user-profile',
                          arguments: userData,
                        );
                      }
                    },
                    child: Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      ),
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
      body: RefreshIndicator(
        onRefresh: _fetchFollowers,
        child: Padding(
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
              if (_isLoading)
                Expanded(
                  child: Center(
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
                )
              else if (_tabIndex == 0)
                ...receivedRequests
                  .where((user) => user['isAccepted'] == false && user['userFollower'] != null)
                  .map((user) {
                    final follower = user['userFollower'];
                    final followerUserId = user['followerUserId']?.toString();
                    return requestTile(
                      name: follower['fullname'] ?? '',
                      username: '@${follower['username'] ?? ''}',
                      avatarSeed: follower['username'] ?? '',
                      imageUrl: follower['image'],
                      userId: followerUserId,
                      userData: follower,
                      actions: [
                        SizedBox(
                          width: 50.w,
                          child: CustomButton(
                            text: 'Reject',
                            borderRadius: 10,
                            onPressed: () async {
                              final provider = Provider.of<FollowProvider>(context, listen: false);
                              final success = await provider.rejectFollow(followerUserId ?? '');
                              if (success) {
                                await _fetchFollowers();
                                await _fetchFollowings();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Request rejected'))),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to reject request'))),
                                );
                              }
                            },
                            backgroundColor: Colors.transparent,
                            hasBorder: true,
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 8.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: Colors.red,
                            ),
                            height: 34.h,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          width: 55.w,
                          child: CustomButton(
                            text: 'Accept',
                            borderRadius: 10,
                            onPressed: () async {
                              final provider = Provider.of<FollowProvider>(context, listen: false);
                              final success = await provider.acceptFollow(followerUserId ?? '');
                              if (success) {
                                await _fetchFollowers();
                                await _fetchFollowings();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Request accepted'))),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to accept request'))),
                                );
                              }
                            },
                            backgroundColor: const Color(0xffbbd953),
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 8.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: Colors.black,
                            ),
                            height: 34.h,
                          ),
                        ),
                      ],
                    );
                  }),
              if (_tabIndex == 1)
                ...followingRequests
                  .where((user) => user['isAccepted'] == false && user['userFollowed'] != null)
                  .map((user) {
                    final following = user['userFollowed'];
                    final followingUserId = user['followedUserId']?.toString();
                    return requestTile(
                      name: following['fullname'] ?? '',
                      username: '@${following['username'] ?? ''}',
                      avatarSeed: following['username'] ?? '',
                      imageUrl: following['image'],
                      userId: followingUserId,
                      userData: following,
                      actions: [
                        SizedBox(
                          width: 110.w,
                          child: CustomButton(
                            text: 'Cancel request',
                            borderRadius: 10,
                            onPressed: () async {
                              final provider = Provider.of<FollowProvider>(context, listen: false);
                              final success = await provider.rejectFollow(followingUserId ?? '');
                              if (success) {
                                await _fetchFollowings();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Request cancelled'))),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to cancel request'))),
                                );
                              }
                            },
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
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
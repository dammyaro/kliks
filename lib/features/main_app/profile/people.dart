import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  int _tabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> followingList = [];
  List<Map<String, dynamic>> followersList = [];
  bool _isLoading = false;
  final Set<String> _loadingUserIds = {};

  @override
  void initState() {
    super.initState();
    _fetchFollowings();
    _fetchFollowers();
  }

  Future<void> _fetchFollowings() async {
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final followings = await provider.fetchFollowings();
    setState(() {
      followingList = followings.where((user) => user['isAccepted'] == true && user['userFollowed'] != null).toList();
    });
  }

  Future<void> _fetchFollowers() async {
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final followers = await provider.fetchFollowers();
    setState(() {
      followersList = followers.where((user) => user['isAccepted'] == true && user['userFollower'] != null).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget peopleTile({
      required String name,
      required String username,
      required String? imageUrl,
      required String? userId,
      required Widget action,
    }) {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            ProfilePicture(
              fileName: imageUrl,
              userId: userId ?? '',
              size: 44.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
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
            action,
          ],
        ),
      );
    }

    Widget buildTabContent({required Widget actionButton, required List<Map<String, dynamic>> dataList, required bool isFollowingTab}) {
      return Column(
        children: [
          TextFormWidget(
            name: 'search',
            controller: _searchController,
            labelText: 'Search',
            prefixIcon: Icon(Icons.search_outlined, color: theme.iconTheme.color?.withOpacity(0.5)),
            onChanged: (val) => setState(() {}),
          ),
          SizedBox(height: 24.h),
          ...dataList
              .where((user) {
                final displayName = isFollowingTab
                  ? (user['userFollowed']?['fullname'] ?? '')
                  : (user['userFollower']?['fullname'] ?? '');
                final displayUsername = isFollowingTab
                  ? (user['userFollowed']?['username'] ?? '')
                  : (user['userFollower']?['username'] ?? '');
                return displayName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                  displayUsername.toLowerCase().contains(_searchController.text.toLowerCase());
              })
              .map(
                (user) {
                  final display = _tabIndex == 2
                    ? (user['userFollowed'] ?? user['userFollower'])
                    : (isFollowingTab ? user['userFollowed'] : user['userFollower']);
                  // For followers tab, check if this follower is also in followingList
                  final isFollowersTab = !isFollowingTab && _tabIndex == 1;
                  final isConnectionsTab = _tabIndex == 2;
                  final isFollowingBack = followingList.any((f) =>
                    f['userFollowed'] != null &&
                    f['userFollowed']['id']?.toString() == display['id']?.toString()
                  );
                  return peopleTile(
                    name: display['fullname'] ?? '',
                    username: '@${display['username'] ?? ''}',
                    imageUrl: display['image'],
                    userId: display['id']?.toString(),
                    action: SizedBox(
                      width: 110.w,
                      child: isFollowingTab
                          ? Builder(
                              builder: (context) => CustomButton(
                                text: 'Unfollow',
                                borderRadius: 10,
                                isLoading: _loadingUserIds.contains(display['id']?.toString()),
                                onPressed: _loadingUserIds.contains(display['id']?.toString()) ? null : () async {
                                  final userId = display['id']?.toString();
                                  if (userId == null) return;
                                  setState(() {
                                    _loadingUserIds.add(userId);
                                  });
                                  final provider = Provider.of<FollowProvider>(context, listen: false);
                                  final success = await provider.unfollow(userId);
                                  setState(() {
                                    _loadingUserIds.remove(userId);
                                  });
                                  if (success) {
                                    await _fetchFollowings();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                          child: Text('Unfollowed successfully'),
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                          child: Text('Failed to unfollow'),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                backgroundColor: Colors.transparent,
                                hasBorder: true,
                                textStyle: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 10.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                height: 34.h,
                              ),
                            )
                          : isFollowersTab
                              ? (isFollowingBack
                                  ? CustomButton(
                                      text: 'Following',
                                      onPressed: null,
                                      backgroundColor: Colors.grey.shade600,
                                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 10.sp,
                                        fontFamily: 'Metropolis-SemiBold',
                                        color: Colors.black,
                                      ),
                                      height: 34.h,
                                    )
                                  : CustomButton(
                                      text: 'Follow back',
                                      borderRadius: 10,
                                      isLoading: _loadingUserIds.contains(display['id']?.toString()),
                                      onPressed: _loadingUserIds.contains(display['id']?.toString()) ? null : () async {
                                        final userId = display['id']?.toString();
                                        if (userId == null) return;
                                        setState(() {
                                          _loadingUserIds.add(userId);
                                        });
                                        final provider = Provider.of<FollowProvider>(context, listen: false);
                                        final success = await provider.followUser(userId);
                                        setState(() {
                                          _loadingUserIds.remove(userId);
                                        });
                                        if (success) {
                                          await _fetchFollowings();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                                child: Text('Followed back successfully'),
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                                child: Text('Failed to follow back'),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: const Color(0xffbbd953),
                                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 10.sp,
                                        fontFamily: 'Metropolis-SemiBold',
                                        color: Colors.black,
                                      ),
                                      height: 34.h,
                                    ))
                              : isConnectionsTab
                                  ? CustomButton(
                                      text: 'Following',
                                      onPressed: null,
                                      backgroundColor: Colors.grey.shade600,
                                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 10.sp,
                                        fontFamily: 'Metropolis-SemiBold',
                                        color: Colors.black,
                                      ),
                                      height: 34.h,
                                    )
                                  : actionButton,
                    ),
                  );
                },
              ),
        ],
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'People'),
            SizedBox(height: 5.h),
            Column(
              children: [
                Row(
                children: [
                  // Following - extreme left
                  Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      'Following',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: _tabIndex == 0
                          ? const Color(0xffbbd953)
                          : theme.textTheme.bodyMedium?.color,
                      ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                      height: 3.h,
                      width: 36.w,
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
                  ),
                  // Followers - center
                  Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 1),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      'Followers',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: _tabIndex == 1
                          ? const Color(0xffbbd953)
                          : theme.textTheme.bodyMedium?.color,
                      ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                      height: 3.h,
                      width: 36.w,
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
                  ),
                  // Connections - extreme right
                  Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 2),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                      'Connections',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: _tabIndex == 2
                          ? const Color(0xffbbd953)
                          : theme.textTheme.bodyMedium?.color,
                      ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                      height: 3.h,
                      width: 36.w,
                      decoration: BoxDecoration(
                        color: _tabIndex == 2
                          ? const Color(0xffbbd953)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      ),
                    ],
                    ),
                  ),
                  ),
                ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (_tabIndex == 0)
              buildTabContent(
                actionButton: CustomButton(
                  text: 'Unfollow',
                  borderRadius: 10,
                  onPressed: () {},
                  backgroundColor: Colors.transparent,
                  hasBorder: true,
                  textStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  height: 34.h,
                ),
                dataList: followingList,
                isFollowingTab: true,
              ),
            if (_tabIndex == 1)
              buildTabContent(
                actionButton: CustomButton(
                  text: 'Follow back',
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
                dataList: followersList,
                isFollowingTab: false,
              ),
            if (_tabIndex == 2)
              buildTabContent(
                actionButton: SizedBox.shrink(),
                dataList: followingList
                    .where((followingUser) =>
                        followersList.any((followerUser) =>
                            followerUser['userFollower'] != null &&
                            followingUser['userFollowed'] != null &&
                            followerUser['userFollower']['id']?.toString() ==
                                followingUser['userFollowed']['id']?.toString()))
                    .map((user) => {
                          'userFollower': followersList.firstWhere(
                              (followerUser) =>
                                  followerUser['userFollower'] != null &&
                                  user['userFollowed'] != null &&
                                  followerUser['userFollower']['id']?.toString() ==
                                      user['userFollowed']['id']?.toString(),
                              orElse: () => <String, dynamic>{}),
                          'userFollowed': user['userFollowed'],
                        })
                    .where((user) => user['userFollowed'] != null)
                    .toList(),
                isFollowingTab: false,
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> blockedUsers = [];
  bool _isLoading = false;
  final Set<String> _loadingUserIds = {};

  @override
  void initState() {
    super.initState();
    _fetchBlockedUsers();
  }

  Future<void> _fetchBlockedUsers() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final users = await provider.getBlockedUsers(searchName: _searchController.text);
    setState(() {
      blockedUsers = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Blocked Accounts'),
            // SizedBox(height: 5.h),
            TextFormWidget(
              name: 'search',
              controller: _searchController,
              labelText: 'Search',
              prefixIcon: Icon(Icons.search_outlined, color: theme.iconTheme.color?.withOpacity(0.5)),
              onChanged: (val) => _fetchBlockedUsers(),
            ),
            // SizedBox(height: 24.h),
            Expanded(
              child: _isLoading
                  ? Center(
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
                    )
                  : ListView(
                      children: blockedUsers.map(
                        (block) {
                          final user = block['userBlocked'] ?? {};
                          final userId = user['id']?.toString();
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                ProfilePicture(
                                  fileName: user['image'],
                                  folderName: 'profile_pictures',
                                  size: 44.sp,
                                  userId: user['id'],
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['fullname'] ?? user['name'] ?? '',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 12.sp,
                                          fontFamily: 'Metropolis-SemiBold',
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '@${user['username'] ?? ''}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 10.sp,
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 70.w,
                                  child: CustomButton(
                                    text: 'Unblock',
                                    borderRadius: 20,
                                    isLoading: _loadingUserIds.contains(userId),
                                    onPressed: _loadingUserIds.contains(userId) ? null : () async {
                                      if (userId == null) return;
                                      setState(() {
                                        _loadingUserIds.add(userId);
                                      });
                                      final provider = Provider.of<FollowProvider>(context, listen: false);
                                      final success = await provider.unblockUser(userId);
                                      setState(() {
                                        _loadingUserIds.remove(userId);
                                      });
                                      if (success) {
                                        await _fetchBlockedUsers();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('User unblocked successfully')),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to unblock user')),
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
                                    height: 30.h,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
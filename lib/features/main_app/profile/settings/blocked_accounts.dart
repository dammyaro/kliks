import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:random_avatar/random_avatar.dart';

class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> blockedUsers = [
    {
      'name': 'Jane Doe',
      'username': '@janedoe',
      'avatarSeed': 'janedoe',
    },
    {
      'name': 'Kunle Aro',
      'username': '@kunlearo',
      'avatarSeed': 'kunlearo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Blocked Accounts'),
            SizedBox(height: 10.h),
            TextFormWidget(
              name: 'search',
              controller: _searchController,
              labelText: 'Search',
              prefixIcon: Icon(Icons.search_outlined, color: theme.iconTheme.color?.withOpacity(0.5)),
              onChanged: (val) {
                setState(() {});
              },
            ),
            SizedBox(height: 24.h),
            ...blockedUsers
                .where((user) =>
                    user['name']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                    user['username']!.toLowerCase().contains(_searchController.text.toLowerCase()))
                .map(
                  (user) => Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        RandomAvatar(
                          user['avatarSeed']!,
                          height: 44.sp,
                          width: 44.sp,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name']!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                user['username']!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 90.w,
                          child: CustomButton(
                            text: 'Unblock',
                            onPressed: () {
                              // Handle unblock logic
                            },
                            backgroundColor: Colors.transparent,
                            hasBorder: true,
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                            height: 38.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
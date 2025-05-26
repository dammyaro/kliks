import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:random_avatar/random_avatar.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  int _tabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> people = [
    {'name': 'Jane Doe', 'username': '@janedoe', 'avatarSeed': 'janedoe'},
    {'name': 'Kunle A', 'username': '@kunlearo', 'avatarSeed': 'kunlearo'},
    {'name': 'John Smith', 'username': '@johnsmith', 'avatarSeed': 'johnsmith'},
    {'name': 'Ada Lovelace', 'username': '@adalovelace', 'avatarSeed': 'adalovelace'},
    {'name': 'Sam Lee', 'username': '@samlee', 'avatarSeed': 'samlee'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget peopleTile({
      required String name,
      required String username,
      required String avatarSeed,
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

    Widget buildTabContent({required Widget actionButton}) {
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
          ...people
              .where((user) =>
                  user['name']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                  user['username']!.toLowerCase().contains(_searchController.text.toLowerCase()))
              .map(
                (user) => peopleTile(
                  name: user['name']!,
                  username: user['username']!,
                  avatarSeed: user['avatarSeed']!,
                  action: SizedBox(
                    width: 110.w,
                    child: actionButton,
                  ),
                ),
              ),
        ],
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
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
              ),
            if (_tabIndex == 2)
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
              ),
          ],
        ),
      ),
    );
  }
}
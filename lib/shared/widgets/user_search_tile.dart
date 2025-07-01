import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class UserSearchTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserSearchTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = user['fullname'] ?? 'No Name';
    final username = user['username'] ?? '';

    if (fullName.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      leading: ProfilePicture(
        fileName: user['image'],
        userId: user['id']?.toString() ?? '',
        size: 40,
      ),
      onTap: () {
        Navigator.pushNamed(context, '/user-profile', arguments: user);
      },
      title: Text(
        fullName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 13.sp,
          fontFamily: 'Metropolis-Medium',
        ),
      ),
      subtitle: Text(
        '@$username',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10.sp,
          fontFamily: 'Metropolis-Light',
        ),
      ),
      trailing: Icon(
        Icons.north_west,
        size: 12.sp,
        color: const Color(0xffbbd953),
      ),
    );
  }
}

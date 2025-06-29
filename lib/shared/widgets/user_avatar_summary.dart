
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class UserAvatarSummary extends StatelessWidget {
  final List<dynamic> users;
  final double avatarSize;

  const UserAvatarSummary({
    super.key,
    required this.users,
    this.avatarSize = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayUsers = users.take(4).toList();
    final remainingCount = users.length - displayUsers.length;

    final double itemStep = avatarSize * 0.7;
    final double textGap = 8.0; // Space between avatars and text

    final double textLeft = (displayUsers.length * itemStep) + textGap;

    final double calculatedWidth = textLeft + avatarSize;

    return SizedBox(
      height: avatarSize,
      width: calculatedWidth,
      child: Stack(
        children: [
          ...List.generate(displayUsers.length, (index) {
            final user = displayUsers[index];
            final profilePic = user['image'] ?? '';
            final userId = user['id']?.toString() ?? '';

            return Positioned(
              left: index * itemStep,
              child: ProfilePicture(
                fileName: profilePic,
                size: avatarSize,
                userId: userId,
              ),
            );
          }),
          Positioned(
            left: textLeft,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              child: Center(
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kliks/core/services/media_service.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfilePicture extends StatelessWidget {
  final String? fileName;
  final double size;
  final String folderName;
  final String? userId;

  const ProfilePicture({
    super.key,
    required this.fileName,
    this.size = 80,
    this.folderName = 'profile_pictures',
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    if (fileName == null || fileName!.isEmpty) {
      return userId != null
          ? CircleAvatar(
              radius: size / 2,
              child: RandomAvatar(userId!, height: size, width: size),
            )
          : CircleAvatar(
              radius: size / 2,
              child: Icon(Icons.person, size: size * 0.6),
            );
    }
    final url = MediaService().getProfilePictureUrl(
      folderName: folderName,
      fileName: fileName!,
    );
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Image.network(
          // url,
          fileName!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return userId != null
                ? RandomAvatar(userId!, height: size, width: size)
                : Icon(Icons.person, size: size * 0.6);
          },
        ),
      ),
    );
  }
}

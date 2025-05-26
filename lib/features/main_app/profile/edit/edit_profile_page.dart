import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:random_avatar/random_avatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
      });
    }
  }

  Widget _buildBar({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 0.9.sw,
          height: 0.1.sh,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xff9b9b9b).withOpacity(0.05)
                : const Color(0x0ff2f1e6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        fontFamily: 'Metropolis-Medium',
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: const Color(0xff9b9b9b),
                      ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios, size: 14.sp, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).profile;
    final name = profile?['fullname'] ?? '';
    final username = profile?['username'] ?? '';
    final gender = profile?['gender'] ?? '';
    final bio = profile?['about'] ?? '';
    final userId = profile?['id'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w), // To balance the row
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // Avatar with overlay and camera icon
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: _selectedImage == null
                        ? RandomAvatar(
                            userId,
                            height: 100.r,
                            width: 100.r,
                          )
                        : Image.file(
                            File(_selectedImage!.path),
                            width: 100.r,
                            height: 100.r,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    width: 100.r,
                    height: 100.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Bars
            _buildBar(
              label: 'Name',
              value: name,
              onTap: () {
                Navigator.pushNamed(context, '/edit-name');
              },
            ),
            SizedBox(height: 10.h),
            _buildBar(
              label: 'Username',
              value: username,
              onTap: () {
                Navigator.pushNamed(context, '/edit-username');
              },
            ),
            SizedBox(height: 10.h),
            _buildBar(
              label: 'Gender',
              value: gender,
              onTap: () {
                Navigator.pushNamed(context, '/edit-gender');
              },
            ),
            SizedBox(height: 10.h),
            _buildBar(
              label: 'Bio',
              value: bio,
              onTap: () {
                Navigator.pushNamed(context, '/edit-bio');
              },
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
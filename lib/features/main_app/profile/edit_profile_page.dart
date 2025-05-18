import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
            : const Color(0xff2f1e6),
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
                color: Theme.of(context).primaryColor
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14.sp,
              fontFamily: 'Metropolis-SemiBold',
              color: Color(0xff9b9b9b),
              ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: Theme.of(context).iconTheme.color),
          ],
        ),
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                              letterSpacing: 0
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
                        ? Image.asset(
                            'assets/icons/avatar-large-main.png',
                            width: 100.r,
                            height: 100.r,
                            fit: BoxFit.cover,
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
              value: 'Olakunle',
              onTap: () {
                Navigator.pushNamed(context, '/edit-name');
              },
            ),
            // Divider(height: 1, thickness: 1),
             SizedBox(height: 10.h),
            _buildBar(
              label: 'Username',
              value: '@kunlearo',
              onTap: () {
                Navigator.pushNamed(context, '/edit-username');
              },
            ),
            // Divider(height: 1, thickness: 1),
             SizedBox(height: 10.h),
            _buildBar(
              label: 'Gender',
              value: 'Male',
              onTap: () {
                Navigator.pushNamed(context, '/edit-gender');
              },
            ),
            // Divider(height: 1, thickness: 1),
             SizedBox(height: 10.h),
            _buildBar(
              label: 'Bio',
                value: 'Lorem ipsum dolor\n sit amet.',
              onTap: () {
                Navigator.pushNamed(context, '/edit-bio');
              },
            ),
            // Divider(height: 1, thickness: 1),
             SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
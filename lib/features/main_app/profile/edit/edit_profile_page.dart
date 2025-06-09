import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:typed_data';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? _selectedImage;
  bool _isUploading = false;
  final CropController _cropController = CropController();
  Uint8List? _croppingImageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _croppingImageBytes = bytes;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.black,
            child: SizedBox(
              width: 350.w,
              height: 420.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Crop(
                      image: _croppingImageBytes!,
                      controller: _cropController,
                      onCropped: (result) async {
                        switch (result) {
                          case CropSuccess(:final croppedImage):
                            Navigator.of(context).pop();
                            final tempFile = File('${picked.path}_cropped.png');
                            await tempFile.writeAsBytes(croppedImage);
                            setState(() {
                              _selectedImage = XFile(tempFile.path);
                              _isUploading = true;
                            });
                            final provider = Provider.of<AuthProvider>(context, listen: false);
                            await provider.updateProfilePicture(tempFile);
                            setState(() {
                              _isUploading = false;
                            });
                            break;
                          case CropFailure(:final cause):
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to crop image: \\$cause')),
                            );
                            break;
                        }
                      },
                      baseColor: Colors.black,
                      maskColor: Colors.black.withOpacity(0.5),
                      cornerDotBuilder: (size, edgeAlignment) => const DotControl(color: Colors.white),
                      aspectRatio: 1,
                      interactive: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _cropController.crop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffbbd953),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Text('Crop & Save', style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(width: 16.w),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
    final profilePictureFileName = profile?['image'];

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
                    child: _selectedImage != null
                        ? Image.file(
                            File(_selectedImage!.path),
                            width: 100.r,
                            height: 100.r,
                            fit: BoxFit.cover,
                          )
                        : ProfilePicture(
                            fileName: profilePictureFileName,
                            userId: userId,
                            size: 100.r,
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
                  _isUploading
                      ? SizedBox(
                          width: 32.sp,
                          height: 32.sp,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
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
              value: bio.length > 28 ? '${bio.substring(0, 28)}...' : bio,
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
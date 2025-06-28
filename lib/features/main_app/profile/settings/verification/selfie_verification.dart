import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:permission_handler/permission_handler.dart';

class SelfieVerificationPage extends StatefulWidget {
  const SelfieVerificationPage({super.key});

  @override
  State<SelfieVerificationPage> createState() => _SelfieVerificationPageState();
}

class _SelfieVerificationPageState extends State<SelfieVerificationPage> {
  bool _cameraGranted = false;
  bool _checkedPermission = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _cameraGranted = status.isGranted;
      _checkedPermission = true;
    });
    if (!status.isGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPermissionModal();
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraGranted = status.isGranted;
    });
    if (!status.isGranted) {
      _showPermissionModal();
    } else {
      Navigator.of(context).pop(); // Close modal if granted
    }
  }

  void _showPermissionModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Allow Kliks to access camera on this device",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 17.sp,
                    fontFamily: 'Metropolis-SemiBold',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  "Allow access to camera to take your photo for this process",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    color: theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                TextButton(
                  onPressed: _requestCameraPermission,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    "Allow",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double boxHeight = MediaQuery.of(context).size.height * 0.7;

    return Scaffold(
      appBar: CustomNavBar(title: 'Selfie Verification'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Center(
              child: Container(
                width: double.infinity,
                height: boxHeight,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: !_checkedPermission
                    ? const SizedBox.shrink()
                    : !_cameraGranted
                        ? Icon(Icons.videocam_off, color: Colors.white.withOpacity(0.5), size: 48.sp)
                        : Text(
                            'Camera stream goes here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
              ),
            ),
            // const Spacer(),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Capture',
              onPressed: _cameraGranted
                  ? () {
                      // Handle capture logic
                    }
                  : null,
              backgroundColor: const Color(0xffbbd953),
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
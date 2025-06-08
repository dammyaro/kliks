import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _settingsTile({
    required IconData icon,
    required String label,
    String? subLabel,
    Color? subLabelColor,
    Color? iconColor,
    Color? labelColor,
    VoidCallback? onTap,
    bool isDestructive = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        child: Row(
          crossAxisAlignment: subLabel != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: iconColor ??
                  (isDestructive
                      ? theme.colorScheme.error
                      : theme.iconTheme.color),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontFamily: 'Metropolis-Bold',
                      color: labelColor ??
                          (isDestructive
                              ? theme.colorScheme.error
                              : theme.textTheme.bodyLarge?.color),
                    ),
                  ),
                  if (subLabel != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        subLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Metropolis-Regular',
                          color: subLabelColor ?? theme.hintColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: isDestructive ? theme.colorScheme.error : theme.iconTheme.color?.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = Provider.of<AuthProvider>(context).profile;
    // print('Profile: \\${profile}');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                child: Row(
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.arrow_back, size: 24.sp, color: theme.iconTheme.color),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                    // SizedBox(width: 8.w),
                    // Expanded(
                    //   // child: Center(
                    //     child: Text(
                    //       'Settings & Privacy',
                    //       style: theme.textTheme.bodyLarge?.copyWith(
                    //             fontSize: 16.sp,
                    //             fontFamily: 'Metropolis-SemiBold',
                    //           ),
                    //     ),
                    //   ),
                    // ),
                    CustomNavBar(title: "Settings & Privacy"),
                    // SizedBox(width: 48.w), // To balance the row
                  ],
                ),
              ),
              SizedBox(height: 0.h),
              // Profile Management Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile Management',
                    style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontFamily: 'Metropolis-ExtraBold',
                          color: theme.hintColor,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _settingsTile(
                icon: Icons.person_outline,
                label: 'User Information',
                onTap: () {
                  Navigator.pushNamed(context, '/user-information');
                },
                context: context,
              ),
                Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.verified_outlined,
                label: 'Verify your account',
                subLabel: 'Pending approval',
                subLabelColor: Colors.green,
                onTap: () {
                    showModalBottomSheet(
                    context: context,
                    // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    isScrollControlled: true,
                    builder: (context) {
                      final theme = Theme.of(context);
                      return Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 30.w,
                        top: 0,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        SizedBox(height: 24.h),
                        const HandleBar(),
                        SizedBox(height: 15.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                          'Identity Verification',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 20.sp,
                            fontFamily: 'Metropolis-ExtraBold',
                          ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                          'Provide the following information',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp,
                            color: theme.hintColor,
                          ),
                          textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Column(
                          children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context); // Close the first sheet if you want only one open at a time
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                                ),
                                builder: (context) {
                                  final theme = Theme.of(context);
                                  String? selectedIdType;
                                  String? selectedFilePath;
                                  final List<String> idTypes = [
                                    'Passport',
                                    'Drivers License',
                                    'National ID',
                                    'School ID',
                                  ];
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height * 0.9,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 15.w,
                                          right: 10.w,
                                          top: 0,
                                          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                                        ),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 24.h),
                                            const HandleBar(),
                                            SizedBox(height: 10.h),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Upload ID',
                                                style: theme.textTheme.bodyLarge?.copyWith(
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Metropolis-SemiBold',
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Select an identification type and upload\nan image',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  fontSize: 13.sp,
                                                  color: theme.hintColor,
                                                ),
                                                // textAlign: TextAlign.left,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            // Text(
                                            //   'Select an identification type and upload\nan image',
                                            //   style: theme.textTheme.bodySmall?.copyWith(
                                            //     fontSize: 13.sp,
                                            //     color: theme.hintColor,
                                            //   ),
                                            //   // textAlign: TextAlign.left,
                                            // ),
                                            SizedBox(height: 24.h),
                                            // ID Type Selection Bar
                                            InkWell(
                                              onTap: () async {
                                                final result = await showModalBottomSheet<String>(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                                                  ),
                                                  builder: (context) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: idTypes.map((type) {
                                                        return ListTile(
                                                          title: Text(type),
                                                          onTap: () => Navigator.pop(context, type),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                );
                                                if (result != null) {
                                                  setModalState(() {
                                                    selectedIdType = result;
                                                  });
                                                }
                                              },
                                              borderRadius: BorderRadius.circular(12.r),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        selectedIdType ?? 'Select Identification type',
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          fontSize: 15.sp,
                                                          fontFamily: 'Metropolis-SemiBold',
                                                          color: selectedIdType == null ? theme.hintColor : theme.textTheme.bodyMedium?.color,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(Icons.arrow_drop_down_outlined, color: theme.iconTheme.color?.withOpacity(0.7)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 18.h),
                                            // File Upload Bar
                                            InkWell(
                                              onTap: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                                if (result != null && result.files.single.path != null) {
                                                  setModalState(() {
                                                    selectedFilePath = result.files.single.path;
                                                  });
                                                }
                                              },
                                              borderRadius: BorderRadius.circular(12.r),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.upload_file_outlined, color: theme.iconTheme.color?.withOpacity(0.5), size: 22.sp),
                                                    SizedBox(width: 16.w),
                                                    Expanded(
                                                      child: Text(
                                                        selectedFilePath ?? 'Upload file',
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          fontSize: 15.sp,
                                                          fontFamily: 'Metropolis-SemiBold',
                                                          color: selectedFilePath == null ? theme.hintColor : theme.textTheme.bodyMedium?.color,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            CustomButton(
                                              text: 'Next',
                                              onPressed: (selectedIdType != null && selectedFilePath != null)
                                                  ? () {
                                                      // Handle next logic
                                                    }
                                                  : null,
                                              backgroundColor: (selectedIdType != null && selectedFilePath != null)
                                                  ? const Color(0xffbbd953)
                                                  : theme.disabledColor.withOpacity(0.2),
                                              textStyle: theme.textTheme.bodyMedium?.copyWith(
                                                fontSize: 14.sp,
                                                fontFamily: 'Metropolis-SemiBold',
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 24.h),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                              Icon(Icons.badge_outlined, color: theme.iconTheme.color, size: 22.sp),
                              SizedBox(width: 16.w),
                              Text(
                                'Identity verification',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                ),
                              ),
                              ],
                            ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                              Icon(Icons.camera_alt_outlined, color: theme.iconTheme.color, size: 22.sp),
                              SizedBox(width: 16.w),
                              Text(
                                'Selfie verification',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                ),
                              ),
                              ],
                            ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/selfie-verification');
                            },
                          ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: 'Continue',
                          onPressed: () {
                            // Handle continue logic
                          },
                          backgroundColor: const Color(0xffbbd953),
                          textStyle: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontFamily: 'Metropolis-SemiBold',
                            color: Colors.black,
                          ),
                        ),
                        ],
                      ),
                      );
                    },
                    );
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.lock_outline,
                label: 'Account Privacy',
                onTap: () {
                  Navigator.pushNamed(context, '/account-privacy');
                },
                context: context,
              ),
              SizedBox(height: 60.h),
              // User Management Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'User Management',
                    style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontFamily: 'Metropolis-ExtraBold',
                          color: theme.hintColor,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _settingsTile(
                icon: Icons.notifications_outlined,
                label: 'Notification settings',
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.location_on_outlined,
                label: 'My Location',
                subLabel: 'Ontario, Canada',
                subLabelColor: theme.hintColor,
                onTap: () {
                  Navigator.pushNamed(context, '/update-location');
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.link_outlined,
                label: 'Referrals',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    isScrollControlled: true,
                    builder: (context) {
                      final theme = Theme.of(context);
                      final inviteCode = profile != null && profile['myReferralCode'] != null ? profile['myReferralCode'] : "";
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 30.w,
                          right: 30.w,
                          top: 30.h,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HandleBar(),
                            SizedBox(height: 5.h),
                            Center(
                              child: Text(
                                'Referrals',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 18.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Earn 10 points from referring friends and family',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                color: theme.hintColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                      'Share invite & Earn',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 12.sp,
                                        fontFamily: 'Metropolis-Regular',
                                      ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                      children: [
                                        Icon(FontAwesomeIcons.facebook, color: Colors.blue, size: 40.sp),
                                        SizedBox(width: 15.w),
                                        Icon(FontAwesomeIcons.xTwitter, color: Colors.black, size: 40.sp), // X (Twitter) substitute
                                        SizedBox(width: 15.w),
                                        Icon(FontAwesomeIcons.instagram, color: Colors.purple, size: 40.sp), // Instagram substitute
                                        SizedBox(width: 15.w),
                                        Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 40.sp),
                                        SizedBox(width: 15.w),
                                        Icon(FontAwesomeIcons.telegram, color: Colors.blueAccent, size: 40.sp), // Telegram substitute
                                      ],
                                      ),
                                    ],
                                    
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Referral code',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      fontFamily: 'Metropolis-Regular',
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.link_outlined, size: 18.sp, color: theme.iconTheme.color),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            inviteCode,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontSize: 15.sp,
                                              fontFamily: 'Metropolis-SemiBold',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Copy code to clipboard
                                            Clipboard.setData(ClipboardData(text: inviteCode));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Referral code copied!')),
                                            );
                                          },
                                          child: Icon(Icons.copy_outlined, size: 18.sp, color: theme.iconTheme.color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            CustomButton(
                              text: 'Okay',
                              onPressed: () => Navigator.pop(context),
                              backgroundColor: const Color(0xffbbd953),
                              height: 45.h,
                              textStyle: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.block_outlined,
                label: 'Blocked Accounts',
                onTap: () {
                  Navigator.pushNamed(context, '/blocked-accounts');
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.dialpad_outlined,
                label: 'Contact support',
                onTap: () {
                  Navigator.pushNamed(context, '/contact-support');
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.apple_outlined,
                label: 'About Kliks',
                onTap: () {
                  Navigator.pushNamed(context, '/about-kliks');
                },
                context: context,
              ),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
              _settingsTile(
                icon: Icons.delete_outline,
                label: 'Delete Account',
                isDestructive: true,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String input = '';
                      return StatefulBuilder(
                        builder: (context, setState) {
                          final theme = Theme.of(context);
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 40.sp,
                                    color: theme.colorScheme.error,
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    'Delete Account?',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 20.sp,
                                      fontFamily: 'Metropolis-Regular',
                                      // color: theme.colorScheme.error,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'You can\'t undo this action,  type "delete" if you\'re sure about this.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      color: theme.hintColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 24.h),
                                  TextField(
                                    onChanged: (val) {
                                      setState(() => input = val);
                                    },
                                    decoration: InputDecoration(
                                      // hintText: 'Type "delete"',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: theme.textTheme.bodyMedium?.color,
                                            padding: EdgeInsets.symmetric(vertical: 14.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontFamily: 'Metropolis-Regular',
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: input.trim().toLowerCase() == 'delete'
                                              ? () {
                                                  // Handle delete logic here
                                                  Navigator.pop(context);
                                                }
                                              : null,
                                          style: TextButton.styleFrom(
                                            foregroundColor: input.trim().toLowerCase() == 'delete'
                                                ? Colors.red
                                                : theme.disabledColor,
                                            // backgroundColor: input.trim().toLowerCase() == 'delete'
                                            //     ? theme.colorScheme.error
                                            //     : theme.disabledColor.withOpacity(0.1),
                                            padding: EdgeInsets.symmetric(vertical: 14.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Confirm',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontFamily: 'Metropolis-Regular',
                                              fontSize: 15.sp,
                                              color: input.trim().toLowerCase() == 'delete'
                                                  ? Colors.red
                                                  : theme.disabledColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
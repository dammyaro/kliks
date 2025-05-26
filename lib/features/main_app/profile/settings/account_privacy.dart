import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';

class AccountPrivacyPage extends StatefulWidget {
  const AccountPrivacyPage({super.key});

  @override
  State<AccountPrivacyPage> createState() => _AccountPrivacyPageState();
}

class _AccountPrivacyPageState extends State<AccountPrivacyPage> {
  bool isPrivate = false;
  bool hideProfile = false;
  bool allowFollow = true;
  bool showFollowers = true;

  Widget _privacyTile({
    required String label,
    required String subText,
    required bool value,
    required ValueChanged<bool> onChanged,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Color(0xffffbf00),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  CustomNavBar(title: 'Account Privacy'),
                ],
              ),
              // SizedBox(height: 30.h),
              _privacyTile(
                label: 'Private account',
                subText:
                    'Switching to a private account lets you control who follows you and sees your profile. Only approved followers can view your profile.',
                value: isPrivate,
                onChanged: (val) => setState(() => isPrivate = val),
                context: context,
              ),
              _privacyTile(
                label: 'Hide my profile',
                subText:
                    'This allows you to hide your identity while you’re attending events. Your name and profile will be hidden once you’ve checked in.',
                value: hideProfile,
                onChanged: (val) => setState(() => hideProfile = val),
                context: context,
              ),
              _privacyTile(
                label: 'Allow follow',
                subText:
                    'Switching to a private account lets you control who follows you and sees your profile. Only approved followers can view your profile.',
                value: allowFollow,
                onChanged: (val) => setState(() => allowFollow = val),
                context: context,
              ),
              _privacyTile(
                label: 'Show followers / Following',
                subText:
                    'Switching to a private account lets you control who follows you and sees your profile. Only approved followers can view your profile.',
                value: showFollowers,
                onChanged: (val) => setState(() => showFollowers = val),
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
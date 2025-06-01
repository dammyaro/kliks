import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/privacy_provider.dart';
import 'package:kliks/core/models/privacy_settings.dart';

class AccountPrivacyPage extends StatefulWidget {
  const AccountPrivacyPage({super.key});

  @override
  State<AccountPrivacyPage> createState() => _AccountPrivacyPageState();
}

class _AccountPrivacyPageState extends State<AccountPrivacyPage> {
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
    final provider = Provider.of<PrivacyProvider>(context);
    final settings = provider.settings;

    if (settings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              _privacyTile(
                label: 'Private account',
                subText:
                    'When enabled, only people you approve can follow you and see your full profile. New follow requests must be approved by you.',
                value: settings.isPrivateAccount,
                onChanged: (val) => provider.updateSettings(settings.copyWith(isPrivateAccount: val)),
                context: context,
              ),
              _privacyTile(
                label: 'Allow follow',
                subText:
                    'Allow others to send you follow requests. If disabled, no one new can request to follow you.',
                value: settings.allowFollowing,
                onChanged: (val) => provider.updateSettings(settings.copyWith(allowFollowing: val)),
                context: context,
              ),
              _privacyTile(
                label: 'Show followers / Following',
                subText:
                    'Control whether your followers and following lists are visible to others on your profile.',
                value: settings.showFollowers,
                onChanged: (val) => provider.updateSettings(settings.copyWith(showFollowers: val)),
                context: context,
              ),
              _privacyTile(
                label: 'Hide profile',
                subText:
                    'Hide your profile from search and public listings. You will not appear to other users while hidden.',
                value: settings.isActive,
                onChanged: (val) => provider.updateSettings(settings.copyWith(isActive: val)),
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
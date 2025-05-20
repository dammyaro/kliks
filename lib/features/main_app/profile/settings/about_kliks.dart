import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutKliksPage extends StatelessWidget {
  const AboutKliksPage({super.key});

  Future<void> _launchLegalUrl() async {
    final url = Uri.parse('https://kliks.app/privacy-policy');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    

    final packageInfoFuture = PackageInfo.fromPlatform();

    Widget legalTile(String text) {
      return InkWell(
        onTap: _launchLegalUrl,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Metropolis-SemiBold',
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16.sp,
                color: theme.iconTheme.color?.withOpacity(0.5),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'About Kliks'),
            SizedBox(height: 0.h),
            Text(
              'Kliks offfers a variety of features to make digital interactions with people easier, and in-person networking the ultimate success.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 14.sp,
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 24.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            FutureBuilder<PackageInfo>(
              future: packageInfoFuture,
              builder: (context, snapshot) {
                String versionText = '';
                if (snapshot.connectionState == ConnectionState.waiting) {
                  versionText = 'Loading...';
                } else if (snapshot.hasError) {
                  versionText = 'Unknown';
                } else if (snapshot.hasData) {
                  versionText = snapshot.data!.version;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      Text(
                        'Version',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis-Regular',
                        ),
                      ),
                      Spacer(),
                      Text(
                        versionText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis-SemiBold',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            SizedBox(height: 18.h),
            Text(
              'Legal',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: 10.h),
            legalTile('Terms & Conditions'),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            legalTile('Legal Disclaimer'),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            legalTile('Privacy Policy'),
            SizedBox(height: 32.h),
            Spacer(), // <-- Add this to push the copyright
            Center(
              child: Text(
                'Copyright © 2024 Kliks. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
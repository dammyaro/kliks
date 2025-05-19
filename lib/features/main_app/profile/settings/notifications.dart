import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // State for switches
  bool nearbyEvent = true;
  bool eventAnnouncement = true;
  bool eventInvite = true;
  bool newFollower = true;
  bool profileView = false;
  bool pointsEarning = true;
  bool referralPoints = true;

  Widget _notificationTile({
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
        margin: EdgeInsets.symmetric(vertical: 0.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 0.w),
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
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 28.h, bottom: 8.h),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 13.sp,
          fontFamily: 'Metropolis-Regular',
          color: theme.hintColor,
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp, color: theme.iconTheme.color),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Notification settings',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                  ),
                ],
              ),
              // Events Section
              _sectionTitle(context, 'Events'),
              _notificationTile(
                label: 'Nearby event',
                subText: 'Notifies you when there’s a new event near your location',
                value: nearbyEvent,
                onChanged: (val) => setState(() => nearbyEvent = val),
                context: context,
              ),
              _notificationTile(
                label: 'Event announcement',
                subText: 'Notifies you when there are changes to your booked event details',
                value: eventAnnouncement,
                onChanged: (val) => setState(() => eventAnnouncement = val),
                context: context,
              ),
              _notificationTile(
                label: 'Event Invite',
                subText: 'Notifies you when you get invited to an event',
                value: eventInvite,
                onChanged: (val) => setState(() => eventInvite = val),
                context: context,
              ),
              // People Section
              _sectionTitle(context, 'People'),
              _notificationTile(
                label: 'New follower',
                subText: 'Notifies you when someone follows you',
                value: newFollower,
                onChanged: (val) => setState(() => newFollower = val),
                context: context,
              ),
              _notificationTile(
                label: 'Profile View',
                subText: 'Notifies you when someone views your profile',
                value: profileView,
                onChanged: (val) => setState(() => profileView = val),
                context: context,
              ),
              // Points Section
              _sectionTitle(context, 'Points'),
              _notificationTile(
                label: 'Points Earning',
                subText: 'Notifies you when you earn points from events',
                value: pointsEarning,
                onChanged: (val) => setState(() => pointsEarning = val),
                context: context,
              ),
              _notificationTile(
                label: 'Referral points',
                subText: 'Notifies you when you earn points from referrals',
                value: referralPoints,
                onChanged: (val) => setState(() => referralPoints = val),
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
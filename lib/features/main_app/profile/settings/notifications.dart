import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/notifications_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // State for switches, will be set from provider
  Map<String, bool> notificationSwitches = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<NotificationsProvider>(context, listen: false);
      await provider.getNotificationSettings();
      setState(() {
        notificationSwitches = provider.notificationSwitches;
        _loading = false;
      });
    });
  }

  Widget _notificationTile({
    required String label,
    required String subText,
    required String notificationType,
    required BuildContext context,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onChanged(!notificationSwitches[notificationType]!),
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
              value: notificationSwitches[notificationType] ?? false,
              onChanged: onChanged,
              activeColor: Color(0xffffbf00),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
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
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    CustomNavBar(title: 'Notification Settings'),
                  ],
                ),
              ),
              if (_loading)
                const Center(child: CircularProgressIndicator()),
              if (!_loading) ...[
              // Events Section
              _sectionTitle(context, 'Events'),
              _notificationTile(
                label: 'Nearby event',
                subText: 'Notifies you when there is a new event near your location',
                notificationType: 'NearbyEvent',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['NearbyEvent'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'NearbyEvent', isOn: val);
                },
              ),
              _notificationTile(
                label: 'Event announcement',
                subText: 'Notifies you when there are changes to your booked event details',
                notificationType: 'EventAnnouncement',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['EventAnnouncement'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'EventAnnouncement', isOn: val);
                },
              ),
              _notificationTile(
                label: 'Event Invite',
                subText: 'Notifies you when you get invited to an event',
                notificationType: 'InviteEvent',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['InviteEvent'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'InviteEvent', isOn: val);
                },
              ),
              // People Section
              _sectionTitle(context, 'People'),
              _notificationTile(
                label: 'New follower',
                subText: 'Notifies you when someone follows you',
                notificationType: 'Following',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['Following'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'Following', isOn: val);
                },
              ),
              _notificationTile(
                label: 'Profile View',
                subText: 'Notifies you when someone views your profile',
                notificationType: 'CheckProfile',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['CheckProfile'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'CheckProfile', isOn: val);
                },
              ),
              // Points Section
              _sectionTitle(context, 'Points'),
              _notificationTile(
                label: 'Points Earning',
                subText: 'Notifies you when you earn points from events',
                notificationType: 'Reward',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['Reward'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'Reward', isOn: val);
                },
              ),
              _notificationTile(
                label: 'Referral points',
                subText: 'Notifies you when you earn points from referrals',
                notificationType: 'Referral',
                context: context,
                onChanged: (val) async {
                  setState(() => notificationSwitches['Referral'] = val);
                  final provider = Provider.of<NotificationsProvider>(context, listen: false);
                  await provider.updateNotificationSetting(notificationType: 'Referral', isOn: val);
                },
              ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
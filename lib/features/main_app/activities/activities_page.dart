import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/notifications_provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final Map<String, Map<String, dynamic>> _followerProfiles = {};
  final Map<String, Map<String, dynamic>> _inviteEventCache = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationsProvider>(context, listen: false);
      provider.fetchMyNotifications(limit: 50);
    });
  }

  String _getRelativeTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds}s';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}hr';
      } else if (difference.inDays < 30) {
        return '${difference.inDays}d';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()}mo';
      } else {
        return '${(difference.inDays / 365).floor()}yr';
      }
    } catch (e) {
      return '';
    }
  }

  List<dynamic> _groupNotifications(List<dynamic> notifications) {
    final List<dynamic> groupedList = [];
    final Set<String> processedNotificationKeys = {};

    // Sort notifications by createdAt to ensure consistent grouping (newest first)
    notifications.sort((a, b) {
      final DateTime dateA = DateTime.parse(a['createdAt'] ?? DateTime.now().toIso8601String());
      final DateTime dateB = DateTime.parse(b['createdAt'] ?? DateTime.now().toIso8601String());
      return dateB.compareTo(dateA);
    });

    for (int i = 0; i < notifications.length; i++) {
      final notification = notifications[i];
      final type = notification['notificationType'] ?? '';
      final createdAt = notification['createdAt'] ?? '';

      // Create a unique key for this notification to check if it's already processed
      final String currentNotificationKey = '$type-${notification['eventId']?.toString() ?? notification['data']?['userId']?.toString()}-${createdAt}';

      if (processedNotificationKeys.contains(currentNotificationKey)) {
        continue; // Already processed as part of a group
      }

      if (type == 'CheckProfile') {
        try {
          final notificationDate = DateTime.parse(createdAt);
          final viewerId = notification['eventId']?.toString() ?? notification['data']?['userId']?.toString();

          if (viewerId != null) {
            final List<dynamic> similarNotifications = [];
            similarNotifications.add(notification);
            processedNotificationKeys.add(currentNotificationKey);

            // Find other notifications from the same viewer within 1 hour of the current notification
            for (int j = i + 1; j < notifications.length; j++) {
              final otherNotification = notifications[j];
              final otherType = otherNotification['notificationType'] ?? '';
              final otherCreatedAt = otherNotification['createdAt'] ?? '';
              final otherViewerId = otherNotification['eventId']?.toString() ?? otherNotification['data']?['userId']?.toString();
              final String otherNotificationKey = '$otherType-${otherNotification['eventId']?.toString() ?? otherNotification['data']?['userId']?.toString()}-${otherCreatedAt}';

              if (otherType == 'CheckProfile' && viewerId == otherViewerId && !processedNotificationKeys.contains(otherNotificationKey)) {
                try {
                  final otherDate = DateTime.parse(otherCreatedAt);
                  // Group if within 1 hour of the *first* notification in this potential group
                  if (notificationDate.difference(otherDate).abs().inHours < 1) {
                    similarNotifications.add(otherNotification);
                    processedNotificationKeys.add(otherNotificationKey);
                  }
                } catch (e) {
                  // Ignore parsing errors for other notifications
                }
              }
            }

            if (similarNotifications.length > 1) {
              final combinedNotification = Map<String, dynamic>.from(notification);
              combinedNotification['viewCount'] = similarNotifications.length;
              combinedNotification['isGrouped'] = true;
              groupedList.add(combinedNotification);
            } else {
              groupedList.add(notification);
            }
          } else {
            groupedList.add(notification); // Add if viewerId is null
          }
        } catch (e) {
          groupedList.add(notification); // Add if createdAt parsing fails
        }
      } else {
        groupedList.add(notification); // Add non-CheckProfile notifications directly
      }
    }
    return groupedList;
  }

  Widget _buildNotificationItem(dynamic notification) {
    final type = notification['notificationType'] ?? '';
    final data = notification['data'] ?? {};
    final createdAt = notification['createdAt'] ?? '';
    String title = '';
    String subtitle = '';
    String? imageUrl;
    String? followerProfileId;
    IconData icon = CupertinoIcons.chart_bar;
    Color iconColor = Colors.black;
    Color bgColor = const Color(0xffbbd953);
    Widget? trailingWidget;
    bool isTappable = false;
    Map<String, dynamic>? tapUserData;

    // Handle different notification types
    switch (type) {
      case 'NearbyEvent':
        title = 'Nearby Event';
        subtitle =
            data['eventName'] != null
                ? 'New event near you: [200b][200b]${data['eventName']}'
                : 'There is a new event near your location.';
        icon = CupertinoIcons.location;
        break;

      case 'EventAnnouncement':
        title = 'Event Announcement';
        subtitle = data['announcement'] ?? 'There is an update to your event.';
        icon = CupertinoIcons.bell;
        break;

      case 'InviteEvent':
        {
          final eventId =
              data['eventId']?.toString() ??
              notification['eventId']?.toString();
          final event = eventId != null ? _inviteEventCache[eventId] : null;
          final inviter =
              event?['userCreator'] ?? event?['ownerDocument'] ?? {};
          final inviterName = inviter['fullname'] ?? 'Someone';
          final inviterImage = inviter['image'];
          final eventName =
              event?['eventDocument']?['title'] ??
              data['eventName'] ??
              'an event';

          title = inviterName;
          // subtitle = 'Invited you to $eventName';
          subtitle = 'Invited you to an event';
          imageUrl = inviterImage;
          trailingWidget = Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 22.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View details',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 8.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                onPressed: () {
                  if (event == null) return;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      final theme = Theme.of(context);
                      final organizer = inviter;
                      final organizerName = organizer['fullname'] ?? '';
                      final organizerEmail = organizer['email'] ?? '';
                      final organizerProfilePic =
                          organizer['image']?.toString() ?? '';
                      final eventName = event['eventDocument']?['title'] ?? '';
                      final eventLocation =
                          event['eventDocument']?['location'] ?? '';
                      final guestsCount =
                          event['eventAttendCount']?.toString() ?? '0';
                      final inviteCode = event['inviteCode'] ?? '';
                      bool isAcceptLoading = false;
                      bool isRejectLoading = false;
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const HandleBar(),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "You're invited",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16.sp,
                                      fontFamily: 'Metropolis-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Join us for this amazing event!',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10.sp,
                                      color: theme.hintColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 18.h),
                                  Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color:
                                            theme
                                                .colorScheme
                                                .surfaceContainerHighest,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ProfilePicture(
                                              fileName: organizerProfilePic,
                                              userId:
                                                  organizer['id']?.toString() ??
                                                  '',
                                              size: 36.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    organizerName,
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              'Metropolis-SemiBold',
                                                        ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    organizerEmail ?? '',
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontSize: 8.sp,
                                                          color:
                                                              theme.hintColor,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 14.h),
                                        Text(
                                          eventName,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontSize: 12.sp,
                                                fontFamily: 'Metropolis-Bold',
                                              ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14.sp,
                                              color: const Color(0xffbbd953),
                                              shadows: [
                                                Shadow(
                                                  color: const Color(
                                                    0xffbbd953,
                                                  ).withOpacity(0.5),
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                eventLocation,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      fontSize: 12.sp,
                                                      fontFamily:
                                                          'Metropolis-Medium',
                                                      color: const Color(
                                                        0xffbbd953,
                                                      ),
                                                      shadows: [
                                                        Shadow(
                                                          color: const Color(
                                                            0xffbbd953,
                                                          ).withOpacity(0.5),
                                                          offset: const Offset(
                                                            0,
                                                            1,
                                                          ),
                                                          blurRadius: 2,
                                                        ),
                                                      ],
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.people_outline,
                                              size: 14.sp,
                                              color: theme.hintColor,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '$guestsCount guests attending',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: theme.hintColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: 'Rain check',
                                          backgroundColor: Colors.red,
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 10.sp,
                                            fontFamily: 'Metropolis-Medium',
                                          ),
                                          textColor: Colors.white,
                                          isLoading: isRejectLoading,
                                          onPressed: () async {
                                            setModalState(
                                              () => isRejectLoading = true,
                                            );
                                            final authProvider =
                                                Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false,
                                                );
                                            final userId =
                                                authProvider.profile?['id']
                                                    ?.toString() ??
                                                '';
                                            final eventProvider =
                                                Provider.of<EventProvider>(
                                                  context,
                                                  listen: false,
                                                );
                                            final success = await eventProvider
                                                .rejectEventInvite(
                                                  userId: userId,
                                                  inviteCode: inviteCode,
                                                );
                                            setModalState(
                                              () => isRejectLoading = false,
                                            );
                                            if (success) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invitation declined.',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Failed to decline invitation.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: CustomButton(
                                          text: 'Accept',
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 10.sp,
                                            fontFamily: 'Metropolis-Medium',
                                            color: Colors.black,
                                          ),
                                          isLoading: isAcceptLoading,
                                          onPressed: () async {
                                            setModalState(
                                              () => isAcceptLoading = true,
                                            );
                                            final authProvider =
                                                Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false,
                                                );
                                            final userId =
                                                authProvider.profile?['id']
                                                    ?.toString() ??
                                                '';
                                            final eventProvider =
                                                Provider.of<EventProvider>(
                                                  context,
                                                  listen: false,
                                                );
                                            final success = await eventProvider
                                                .acceptEventInvite(
                                                  userId: userId,
                                                  inviteCode: inviteCode,
                                                );
                                            setModalState(
                                              () => isAcceptLoading = false,
                                            );
                                            if (success) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invitation accepted!',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Failed to accept invitation.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
          break;
        }

      case 'Following':
        // Default values
        title = 'New Follower';
        subtitle =
            notification['bold'] != null &&
                    notification['bold'] is List &&
                    notification['bold'].isNotEmpty
                ? '${notification['bold'][0]} started following you.'
                : 'You have a new follower.';
        icon = CupertinoIcons.person_add;
        imageUrl = null;
        followerProfileId = null;

        final followerUserId = notification['eventId']?.toString();
        if (followerUserId != null && followerUserId.isNotEmpty) {
          // Check if we already have the profile cached
          final cachedProfile = _followerProfiles[followerUserId];
          if (cachedProfile != null) {
            title = cachedProfile['fullname'] ?? title;
            imageUrl = cachedProfile['image'];
            followerProfileId = cachedProfile['id']?.toString();
            // Add follow back/following button
            trailingWidget = Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 28.h,
                child: _FollowBackButton(followerUserId: followerUserId),
              ),
            );
            isTappable = true;
            tapUserData = cachedProfile;
          } else {
            // Fetch and cache the profile, then trigger rebuild
            isTappable = true;
            tapUserData = {
              'id': followerUserId,
            }; // Will fetch full profile on tap
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              final userProfile = await authProvider.getUserById(
                followerUserId,
              );
              if (userProfile != null && mounted) {
                setState(() {
                  _followerProfiles[followerUserId] = userProfile;
                });
              }
            });
          }
        }
        // If imageUrl and followerProfileId are set, _buildNotificationIcon will use ProfilePicture
        break;

      case 'CheckProfile':
        {
          if (notification['isGrouped'] == true) {
            final viewCount = notification['viewCount'] ?? 0;
            title = 'Profile Views';
            if (notification['bold'] != null &&
                notification['bold'] is List &&
                notification['bold'].isNotEmpty) {
              final names = (notification['bold'] as List).first;
              subtitle = '$names viewed your profile $viewCount times';
            } else {
              subtitle = 'Someone viewed your profile $viewCount times';
            }
          } else {
            title = 'Profile Views';
            if (notification['bold'] != null &&
                notification['bold'] is List &&
                notification['bold'].isNotEmpty) {
              final names = (notification['bold'] as List).join(', ');
              subtitle = '$names viewed your profile.';
            } else {
              subtitle = 'Someone viewed your profile.';
            }
          }
          icon = CupertinoIcons.smiley;
          iconColor = Colors.white;
          bgColor = Colors.grey[600]!;

          final viewerUserId = notification['eventId']?.toString() ?? data['userId']?.toString();
          if (viewerUserId != null && viewerUserId.isNotEmpty) {
            isTappable = true;
            tapUserData = {'id': viewerUserId};
          }
        }
        break;

      case 'Reward':
        title = 'Points Earned';
        subtitle =
            data['points'] != null
                ? 'You earned ${data['points']} points!'
                : 'You earned points from an event.';
        icon = CupertinoIcons.star;
        break;

      case 'Referral':
        title = 'Referral Points';
        subtitle =
            data['points'] != null
                ? 'You earned ${data['points']} points from a referral!'
                : 'You earned referral points.';
        icon = CupertinoIcons.gift;
        break;

      default:
        title = type.isNotEmpty ? type : 'Notification';
        subtitle = data.toString();
    }

    Widget content = Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNotificationIcon(
                  type: type,
                  imageUrl: imageUrl,
                  icon: icon,
                  iconColor: iconColor,
                  bgColor: bgColor,
                  followerProfileId: followerProfileId,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 12.sp,
                                    fontFamily: 'Metropolis-Bold',
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        subtitle,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontSize: 10.sp,
                                          fontFamily: 'Metropolis-Medium',
                                          letterSpacing: -0.5,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.5),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      _getRelativeTime(createdAt),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        fontSize: 10.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (trailingWidget != null) ...[
                            SizedBox(width: 10.w),
                            trailingWidget, // Non-null assertion since we check for null
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );

    if (isTappable && tapUserData != null) {
      return InkWell(
        onTap: () async {
          if (type == 'CheckProfile' && tapUserData?['id'] != null) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            final userProfile = await authProvider.getUserById(
              tapUserData!['id'],
            );
            Navigator.of(context).pop(); // Remove loading dialog
            if (userProfile != null) {
              Navigator.pushNamed(
                context,
                '/user-profile',
                arguments: userProfile,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not load user profile.')),
              );
            }
          } else if (type == 'Following' && tapUserData?['id'] != null) {
            // If not cached, fetch profile
            final followerId = tapUserData!['id'];
            Map<String, dynamic>? userProfile = _followerProfiles[followerId];
            if (userProfile == null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => Center(child: CircularProgressIndicator()),
              );
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              userProfile = await authProvider.getUserById(followerId);
              Navigator.of(context).pop(); // Remove loading dialog
            }
            if (userProfile != null) {
              Navigator.pushNamed(
                context,
                '/user-profile',
                arguments: userProfile,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not load user profile.')),
              );
            }
          } else {
            Navigator.pushNamed(
              context,
              '/user-profile',
              arguments: tapUserData,
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    } else {
      return content;
    }
  }

  Widget _buildNotificationIcon({
    required String type,
    String? imageUrl,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    String? followerProfileId,
  }) {
    if (type == 'InviteEvent' && imageUrl != null) {
      return ProfilePicture(
        fileName: imageUrl,
        size: 32.w,
        folderName: 'profile_pictures',
        userId: null,
      );
    }
    if (type == 'Following' && imageUrl != null && followerProfileId != null) {
      // For Following, show profile picture with id if available
      return ProfilePicture(
        fileName: imageUrl,
        size: 32.w,
        folderName: 'profile_pictures',
        userId: followerProfileId,
      );
    }

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(child: Icon(icon, size: 16.sp, color: iconColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 16.h),
            child: Text(
              "Activity",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Consumer<NotificationsProvider>(
                builder: (context, provider, _) {
                  final notifications = provider.notifications;
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final myId = authProvider.profile?['id']?.toString();
                  var filteredNotifications = notifications.where((notification) {
                    if (notification['notificationType'] == 'CheckProfile') {
                      final viewerId = notification['eventId']?.toString() ?? notification['data']?['userId']?.toString();
                      if (viewerId != null && myId != null && viewerId == myId) {
                        return false;
                      }
                    }
                    return true;
                  }).toList();

                  if (!provider.notificationsLoaded) {
                    return Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffbbd953)),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: Color(0xffbbd953),
                    onRefresh: () => provider.fetchMyNotifications(limit: 50, forceReload: true),
                    child: filteredNotifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "No activity",
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 20.sp,
                                    color: Colors.grey[300],
                                    fontFamily: 'Metropolis-SemiBold',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Start using the app to see activities",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 8.h),
                            itemCount: _groupNotifications(filteredNotifications).length,
                            itemBuilder: (context, index) {
                              final notification = _groupNotifications(filteredNotifications)[index];
                              return _buildNotificationItem(notification);
                            },
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowBackButton extends StatefulWidget {
  final String followerUserId;
  const _FollowBackButton({required this.followerUserId});

  @override
  State<_FollowBackButton> createState() => _FollowBackButtonState();
}

class _FollowBackButtonState extends State<_FollowBackButton> {
  bool _isLoading = false;
  late Future<bool> _isFollowingFuture;

  @override
  void initState() {
    super.initState();
    _isFollowingFuture = Provider.of<FollowProvider>(
      context,
      listen: false,
    ).isFollowingUser(context: context, targetUserId: widget.followerUserId);
  }

  Future<void> _handleFollowBack() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<FollowProvider>(context, listen: false);
    final success = await provider.followUser(widget.followerUserId);
    setState(() {
      _isLoading = false;
      if (success) {
        _isFollowingFuture = Future.value(true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: Text(
            success ? 'Followed back successfully' : 'Failed to follow back',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<bool>(
      future: _isFollowingFuture,
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;
        final double height = 28.h;
        final double borderRadius = 8;
        if (isFollowing) {
          return Container(
            height: height,
            width: 70.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              'Following',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 8.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: Colors.black,
              ),
            ),
          );
        } else {
          return InkWell(
            onTap: _isLoading ? null : _handleFollowBack,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              height: height,
              width: 70.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xffbbd953),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              alignment: Alignment.center,
              child:
                  _isLoading
                      ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                      )
                      : Text(
                        'Follow back',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 8.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Colors.black,
                        ),
                      ),
            ),
          );
        }
      },
    );
  }
}

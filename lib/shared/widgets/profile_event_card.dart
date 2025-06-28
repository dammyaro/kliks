import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/debug/printWrapped.dart';

class ProfileEventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onTap;

  const ProfileEventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bannerUrl = event['bannerImageUrl'] ?? '';
    final eventName = event['title'] ?? '';
    final startDateStr = event['startDate'] ?? event['start_date'] ?? '';
    final endDateStr = event['endDate'] ?? event['end_date'] ?? '';
    // final ownerDocument = event['ownerDocument'] as Map<String, dynamic>? ?? {};
    DateTime? startDate;
    DateTime? endDate;
    try {
      if (startDateStr.isNotEmpty) {
        startDate = DateTime.parse(startDateStr);
      }
      if (endDateStr.isNotEmpty) {
        endDate = DateTime.parse(endDateStr);
      }
    } catch (_) {}
    final now = DateTime.now();
    String status = 'Upcoming';
    if (startDate != null && endDate != null) {
      if (now.isBefore(startDate)) {
        status = 'Upcoming';
      } else if (now.isAfter(endDate)) {
        status = 'Concluded';
      } else {
        status = 'Live';
      }
    }

    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          SizedBox(
            height: 150.h, // Reduced height for the banner image
            child: GestureDetector(
              onTap: onTap ??
                  () async {
                    final eventId = event['id'];
                    print(eventId);
                    if (eventId != null) {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      final currentUserId = await authProvider.getUserId();
                      final ownerId = event['userId']?.toString();
                      

                      Navigator.pushNamed(
                        context,
                        currentUserId == ownerId
                            ? '/organizer-event-detail'
                            : '/event-detail',
                        arguments: eventId,
                      );
                    }
                  },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child:
                    bannerUrl.isNotEmpty
                        ? Image.network(
                          bannerUrl,
                          width: double.infinity,
                          height: 100.h,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: double.infinity,
                          height: 100.h,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image,
                            size: 40.sp,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
              ),
            ),
          ),
          // Event Title
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Theme.of(context).hintColor,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      '•',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.sp,
                        color: Theme.of(context).hintColor?.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-Medium',
                        color: status == 'Live'
                            ? Colors.green
                            : status == 'Concluded'
                                ? Colors.red
                                : Theme.of(context).hintColor?.withOpacity(0.3),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

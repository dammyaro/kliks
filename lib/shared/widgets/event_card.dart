import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventCard extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  static final Map<String, Map<String, dynamic>> _profileCache = {};
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final userId = widget.event['userId']?.toString();
    if (userId != null && userId.isNotEmpty) {
      if (_profileCache.containsKey(userId)) {
        setState(() {
          _profile = _profileCache[userId] ?? {};
          _loading = false;
        });
      } else {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final profile = await authProvider.getUserById(userId);
        print('Profile: $profile');
        _profileCache[userId] = profile ?? <String, dynamic>{};
        setState(() {
          _profile = profile ?? <String, dynamic>{};
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profilePic = _profile?['image'] ?? '';
    final fullName = _profile?['fullname'] ?? '';
    final username = _profile?['username'] ?? '';
    final userId = widget.event['userId']?.toString() ?? '';
    final bannerUrl = widget.event['bannerImageUrl'] ?? '';
    final eventName = widget.event['title'] ?? '';
    final eventLocation = widget.event['location'] ?? '';
    final attendees = widget.event['eventAttendCount'] ?? 0;
    final startDate = widget.event['startDate'] ?? '';
    final categories = widget.event['category'] is List
        ? widget.event['category']
        : widget.event['category'] != null && widget.event['category'] is Map && widget.event['category']['category'] != null
            ? [widget.event['category']['category']]
            : [];
    String formattedDate = '';
    try {
      if (startDate.isNotEmpty) {
        final dt = DateTime.parse(startDate);
        formattedDate = DateFormat('EEE, d MMM, yyyy, h:mm a').format(dt);
      }
    } catch (_) {}

    final skeletonColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF232323)
        : const Color(0xFFE0E0E0);

    if (_loading) {
      return Skeletonizer(
        enabled: true,
        child: EventCardSkeleton(skeletonColor: skeletonColor),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Creator info
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_profile != null && _profile!.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/user-profile',
                        arguments: _profile,
                      );
                    }
                  },
                  child: ProfilePicture(
                    fileName: profilePic,
                    size: 38.sp,
                    folderName: 'profile_pictures',
                    userId: userId,
                  ),
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontFamily: 'Metropolis-SemiBold',
                          ),
                    ),
                    SizedBox(height: 0.h),
                    Text(
                      '@$username',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: Theme.of(context).hintColor,
                            fontFamily: 'Metropolis-Medium'
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // 2. Banner with overlay
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    final eventId = widget.event['id'];
                    print('Event ID: $eventId');
                    if (eventId != null) {
                      Navigator.pushNamed(
                        context,
                        '/event-detail',
                        arguments: eventId,
                      );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: bannerUrl.isNotEmpty
                        ? Image.network(
                            bannerUrl,
                            width: double.infinity,
                            height: 300.h,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 160.h,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                          ),
                  ),
                ),
                // Bottom-only dark overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
                    child: Container(
                      height: 120.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  bottom: 16.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                              fontFamily: 'Metropolis-Bold',
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 6, color: Colors.black.withOpacity(0.5))],
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          // Icon(Icons.location_on, color: Colors.white, size: 14.sp),
                          // SizedBox(width: 4.w),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFBF00),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                eventLocation,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 11.sp,
                                      color: Colors.black,
                                      fontFamily: 'Metropolis-SemiBold',
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Icon(Icons.people, color: Colors.white, size: 14.sp),
                        // SizedBox(width: 4.w),
                        Text(
                          '$attendees attending',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // 3. Date and location
            Row(
              children: [
                // Icon(Icons.calendar_today, size: 16.sp, color: Theme.of(context).hintColor),
                // SizedBox(width: 6.w),
                Text(
                  formattedDate.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: Theme.of(context).hintColor,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                // Icon(Icons.location_on, size: 16.sp, color: Theme.of(context).hintColor),
                // SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    eventLocation,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color: Theme.of(context).hintColor,
                          fontFamily: 'Metropolis-Regular',
                          letterSpacing: -0.5
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // 4. Categories
            if (categories.isNotEmpty)
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  ...categories.map<Widget>((cat) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          cat.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11.sp,
                                fontFamily: 'Metropolis-Medium',
                                // color: Colors.black,
                              ),
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class EventCardSkeleton extends StatelessWidget {
  final Color skeletonColor;
  const EventCardSkeleton({super.key, required this.skeletonColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Creator info
            Row(
              children: [
                Container(
                  width: 38.sp,
                  height: 38.sp,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80.w,
                      height: 12.h,
                      color: skeletonColor,
                    ),
                    SizedBox(height: 0.h),
                    Container(
                      width: 50.w,
                      height: 10.h,
                      color: skeletonColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // 2. Banner with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    width: double.infinity,
                    height: 300.h,
                    color: skeletonColor,
                  ),
                ),
                // Grey overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: skeletonColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  bottom: 16.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.w,
                        height: 16.h,
                        color: skeletonColor,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            child: Container(
                              width: 60.w,
                              height: 18.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: skeletonColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Container(
                    width: 60.w,
                    height: 18.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // 3. Date and location
            Row(
              children: [
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: skeletonColor,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: skeletonColor,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // 4. Categories
            Row(
              children: List.generate(3, (i) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Container(
                  width: 40.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
} 
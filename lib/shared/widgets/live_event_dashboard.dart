
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';

class LiveEventDashboard extends StatefulWidget {
  final Map<String, dynamic> event;

  const LiveEventDashboard({super.key, required this.event});

  @override
  State<LiveEventDashboard> createState() => _LiveEventDashboardState();
}

class _LiveEventDashboardState extends State<LiveEventDashboard> {
  @override
  Widget build(BuildContext context) {
    final organizerId = widget.event['ownerDocument']?['id']?.toString();
    final attendees = widget.event['attendingUserDocuments'] as List? ?? [];
    final checkedInUserIds = widget.event['checkedInUserIds'] as List? ?? [];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HandleBar(),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.event['eventDocument']?['title'] ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18.sp,
                        fontFamily: 'Metropolis-Regular',
                      ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${attendees.length} users checked in',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Metropolis-Regular',
                      color: Theme.of(context).hintColor,
                    ),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: attendees.length,
                  itemBuilder: (context, index) {
                    final attendee = attendees[index];
                    final isCheckedIn = checkedInUserIds.contains(attendee['id']);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            ProfilePicture(
                              fileName: attendee['image'] ?? '',
                              size: 60.sp,
                            ),
                            if (attendee['id'] == organizerId)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.green, width: 3.w),
                                  ),
                                ),
                              ),
                            if (isCheckedIn)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          attendee['fullname'] ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10.sp,
                                fontFamily: 'Metropolis-Medium',
                              ),
                        ),
                        Text(
                          attendee['id'] == organizerId ? 'Organizer' : 'Guest',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 8.sp,
                                fontFamily: 'Metropolis-Bold',
                                color: attendee['id'] == organizerId
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

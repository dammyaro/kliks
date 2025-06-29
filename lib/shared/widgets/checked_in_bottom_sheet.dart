
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/providers/checked_in_events_provider.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class CheckedInBottomSheet extends StatefulWidget {
  final Map<String, dynamic> event;
  final VoidCallback onCheckOut;

  const CheckedInBottomSheet(
      {super.key, required this.event, required this.onCheckOut});

  @override
  State<CheckedInBottomSheet> createState() => _CheckedInBottomSheetState();
}

class _CheckedInBottomSheetState extends State<CheckedInBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventName = widget.event['eventDocument']?['title'] ?? '';
    final checkedInUsers = widget.event['attendingUserDocuments'] as List? ?? [];
    final organizerId =
        widget.event['ownerDocument']?['id']?.toString() ?? '';

    // Sort the list to have the organizer first
    checkedInUsers.sort((a, b) {
      final aId = a['id']?.toString() ?? '';
      if (aId == organizerId) return -1;
      return 1;
    });

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HandleBar(),
            SizedBox(height: 24.h),
            Text(
              eventName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Metropolis-Regular',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '${checkedInUsers.length} people checked in',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 24.h),
            if (checkedInUsers.isNotEmpty)
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: checkedInUsers.length,
                  itemBuilder: (context, index) {
                    final user = checkedInUsers[index];
                    final profilePic = user['image'] ?? '';
                    final fullName = user['fullname'] ?? '';
                    final userId = user['id']?.toString() ?? '';
                    final isOrganizer = userId == organizerId;

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isOrganizer
                                ? Border.all(color: Colors.green, width: 2)
                                : null,
                          ),
                          child: ProfilePicture(
                            fileName: profilePic,
                            size: 60.sp,
                            userId: userId,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          fullName,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Text(
                          isOrganizer ? 'Organizer' : 'Guest',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            // Checkout is handled on the event detail page to provide more context
            // and prevent accidental checkouts from the home screen.
          ],
        ),
      ),
    );
  }
}

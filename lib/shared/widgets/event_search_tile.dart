import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventSearchTile extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventSearchTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventName = event['title'] ?? 'No Name';
    final eventDate = event['startDate'] != null
        ? DateFormat('EEE, MMM d').format(DateTime.parse(event['startDate']))
        : 'No Date';
    final imageUrl = event['bannerImageUrl'] as String?;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      leading: SizedBox(
        width: 50.w,
        height: 50.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: imageUrl != null
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.event, color: Colors.grey),
                )
              : const Icon(Icons.event, color: Colors.grey),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/event-detail',
            arguments: event['id']?.toString());
      },
      title: Text(
        eventName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 13.sp,
          fontFamily: 'Metropolis-Medium',
        ),
      ),
      subtitle: Text(
        eventDate,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10.sp,
          fontFamily: 'Metropolis-Light',
        ),
      ),
      trailing: Icon(
        Icons.north_west,
        size: 12.sp,
        color: const Color(0xffbbd953),
      ),
    );
  }
}

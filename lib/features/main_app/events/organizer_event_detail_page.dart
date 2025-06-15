import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart';
import 'package:kliks/core/routes.dart';

class OrganizerEventDetailPage extends StatefulWidget {
  final String? eventId;
  const OrganizerEventDetailPage({super.key, this.eventId});

  @override
  State<OrganizerEventDetailPage> createState() => _OrganizerEventDetailPageState();
}

class _OrganizerEventDetailPageState extends State<OrganizerEventDetailPage> {
  Map<String, dynamic>? event;
  bool _isLoading = true;
  bool _isDeletingEvent = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final eventId = widget.eventId;
    if (eventId != null) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final detail = await eventProvider.getEventDetailById(eventId);
      setState(() {
        event = detail;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _actionCircle(BuildContext context, IconData icon, String label,
      {Color? bg, double size = 50, double iconSize = 24, BoxBorder? border, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bg ?? Colors.transparent,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: (bg == null || bg == Colors.transparent)
                  ? theme.iconTheme.color
                  : Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  fontFamily: 'Metropolis-Regular',
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent() async {
    setState(() => _isDeletingEvent = true);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final success = await eventProvider.deleteEvent(widget.eventId ?? '');
    setState(() => _isDeletingEvent = false);
    if (success) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Event',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                fontFamily: 'Metropolis-Bold',
              ),
        ),
        content: Text(
          'Are you sure you want to delete this event? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontFamily: 'Metropolis-Regular',
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent();
            },
            child: Text(
              'Delete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Colors.red,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      final skeletonColor = Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!;
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Back button - Always visible
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 18.h, right: 10.w, bottom: 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Skeletonized content
              Expanded(
                child: SingleChildScrollView(
                  child: Skeletonizer(
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Custom nav bar skeleton
                        Container(
                          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                          width: 120.w,
                          height: 28.h,
                          color: skeletonColor,
                        ),
                        SizedBox(height: 10.h),
                        // 2. Event banner skeleton
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 300.h,
                              color: skeletonColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // 3. Event name, date, location, categories skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: 180.w, height: 20.h, color: skeletonColor),
                              SizedBox(height: 8.h),
                              Container(width: 120.w, height: 13.h, color: skeletonColor),
                              SizedBox(height: 8.h),
                              Container(width: 100.w, height: 13.h, color: skeletonColor),
                              SizedBox(height: 10.h),
                              Row(
                                children: List.generate(2, (i) => Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Container(
                                    width: 60.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: skeletonColor,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // 4. Action buttons skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) => Column(
                              children: [
                                Container(
                                  width: 50.sp,
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    color: skeletonColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 40.w,
                                  height: 10.h,
                                  color: skeletonColor,
                                ),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Divider(),
                        // 5. People Attending skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Container(width: 100.w, height: 14.h, color: skeletonColor),
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(width: 28.sp, height: 28.sp, color: skeletonColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(),
                        // 6. About Event skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 120.w, height: 18.h, color: skeletonColor),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 80.w, height: 15.h, color: skeletonColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                          child: Container(width: double.infinity, height: 40.h, color: skeletonColor),
                        ),
                        Divider(),
                        // 7. Who can attend skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 100.w, height: 15.h, color: skeletonColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                          child: Container(width: double.infinity, height: 20.h, color: skeletonColor),
                        ),
                        Divider(),
                        // 8. Time frame skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 80.w, height: 15.h, color: skeletonColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: 120.w, height: 13.h, color: skeletonColor),
                              SizedBox(height: 4.h),
                              Container(width: 120.w, height: 13.h, color: skeletonColor),
                            ],
                          ),
                        ),
                        Divider(),
                        // 9. Location skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 80.w, height: 15.h, color: skeletonColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                          child: Container(width: double.infinity, height: 20.h, color: skeletonColor),
                        ),
                        SizedBox(height: 15.h),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Divider(),
                        // 10. Media upload skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(width: 100.w, height: 13.h, color: skeletonColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.5,
                            children: List.generate(2, (i) => ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: Container(
                                width: double.infinity,
                                height: 300.h,
                                color: skeletonColor,
                              ),
                            )),
                          ),
                        ),
                        Divider(),
                        // 11. Delete button skeleton
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Delete button - Always visible but disabled when loading
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 20.h + MediaQuery.of(context).viewPadding.bottom,
            top: 10.h,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 40.h,
            child: CustomButton(
              text: 'Delete Event',
              isLoading: true,
              onPressed: null,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 10.sp,
                fontFamily: 'Metropolis-Medium',
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final eventName = event?['eventDocument']?['title'] ?? '';
    final eventBanner = event?['eventDocument']?['bannerImageUrl'] ?? '';
    final eventLocation = event?['eventDocument']?['location'] ?? '';
    final startDateRaw = event?['eventDocument']?['startDate'] ?? '';
    final endDateRaw = event?['eventDocument']?['endDate'] ?? '';
    
    String formatDate(String dateStr) {
      if (dateStr.isEmpty) return '';
      try {
        final dt = DateTime.parse(dateStr);
        return DateFormat('EEE, d MMM, yyyy, h:mm a').format(dt).toUpperCase();
      } catch (_) {
        return dateStr;
      }
    }

    final eventDate = formatDate(startDateRaw);
    final startDate = formatDate(startDateRaw);
    final endDate = formatDate(endDateRaw);
    final eventCategoryValue = event?['eventDocument']?['category'];
    final eventCategories = eventCategoryValue != null && eventCategoryValue is String && eventCategoryValue.isNotEmpty
        ? [eventCategoryValue]
        : [''];
    final organizer = event?['ownerDocument'] ?? {};
    final organizerName = organizer['fullname'] ?? '';
    final organizerUsername = organizer['username'] ?? '';
    final organizerProfilePic = organizer['image'] != null ? organizer['image'].toString() : '';
    final organizerId = organizer['id'] != null ? organizer['id'].toString() : '';
    final eventDescription = event?['eventDocument']?['description'] ?? '';
    final whoCanAttend = event?['eventDocument']?['whoCanAttend'] ?? '';
    final timeFrame = (startDate.isNotEmpty && endDate.isNotEmpty)
        ? '$startDate - $endDate'
        : '';
    final otherImages = (event?['eventDocument']?['otherImageUrl'] as List?)?.cast<String>() ?? [];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 18.h, right: 10.w, bottom: 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Event banner
              if (eventBanner.isNotEmpty)
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      image: DecorationImage(
                        image: NetworkImage(eventBanner),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
              // Event details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      eventDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        color: Theme.of(context).hintColor,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      eventLocation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        color: Theme.of(context).hintColor,
                        fontFamily: 'Metropolis-Regular',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: eventCategories.map((cat) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          cat ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            fontFamily: 'Metropolis-SemiBold',
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              // Action buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionCircle(
                      context,
                      Icons.link_outlined,
                      'Copy link',
                      size: 50.sp,
                      iconSize: 20.sp,
                      bg: Colors.transparent,
                      border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3), width: 1),
                      onTap: () {
                        final eventId = widget.eventId;
                        if (eventId != null) {
                          final eventLink = 'https://kliks.app/event/$eventId';
                          Clipboard.setData(ClipboardData(text: eventLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                child: Text('Event link copied to clipboard!'),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    _actionCircle(
                      context,
                      Icons.group_add_outlined,
                      'Invite guests',
                      bg: const Color(0xffbbd953),
                      size: 50.sp,
                      iconSize: 20.sp,
                      onTap: () {
                        if (widget.eventId != null) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.organizerInviteGuests,
                            arguments: {'eventId': widget.eventId},
                          );
                        }
                      },
                    ),
                    _actionCircle(
                      context,
                      Icons.campaign_outlined,
                      'Announce',
                      bg: const Color(0xffbbd953),
                      size: 50.sp,
                      iconSize: 20.sp,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.announcement, arguments: widget.eventId);
                      },
                    ),
                    _actionCircle(
                      context,
                      Icons.delete_outline,
                      'Delete',
                      bg: Colors.red,
                      size: 50.sp,
                      iconSize: 20.sp,
                      onTap: _showDeleteConfirmation,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Divider(),
              // Rest of the event details...
              // People Attending
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'People Attending',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-Medium',
                              color: Theme.of(context).hintColor.withOpacity(0.5),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${(event?['attendingUserDocuments'] as List?)?.length ?? 0} attending',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-Medium',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.navigate_next, size: 28.sp, color: Theme.of(context).iconTheme.color),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Divider(),
              // About Event
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'About Event',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-SemiBold',
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Theme.of(context).hintColor.withOpacity(0.5),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(
                  eventDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-Regular',
                    letterSpacing: 0,
                    height: 1.7,
                  ),
                ),
              ),
              Divider(),
              // Who can attend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Who can attend',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(
                  whoCanAttend,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-Regular',
                  ),
                ),
              ),
              Divider(),
              // Time frame
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Time frame',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Starts: $startDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        fontFamily: 'Metropolis-Medium',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Ends: $endDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        fontFamily: 'Metropolis-Medium',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // Location
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(
                  eventLocation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-Regular',
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 30.h,
                      child: CustomButton(
                        text: 'Open maps',
                        onPressed: () {},
                        backgroundColor: Colors.black,
                        textColor: const Color(0xffbbd953),
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: const Color(0xffbbd953),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              // Other Images Section
              if (otherImages.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Other Images',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontFamily: 'Metropolis-Bold',
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.8,
                    children: otherImages.asMap().entries.map((entry) {
                      final img = entry.value;
                      final idx = entry.key;
                      return GestureDetector(
                        onTap: img.isNotEmpty
                            ? () {
                                final allImages = [eventBanner, ...otherImages]
                                    .where((img) => img.isNotEmpty)
                                    .map((img) => img.toString())
                                    .toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _GalleryView(images: allImages, initialIndex: idx + 1),
                                  ),
                                );
                              }
                            : null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: Image.network(
                            img,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _GalleryView({
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<_GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<_GalleryView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Metropolis-Medium',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:intl/intl.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';
import 'package:kliks/core/providers/saved_events_provider.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class EventDetailPage extends StatefulWidget {
  final String? eventId;
  const EventDetailPage({super.key, this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Map<String, dynamic>? event;
  bool _isLoading = true;
  bool _isAttendingLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profile = authProvider.profile;
    final currentUserId = profile?['id']?.toString();
    final attendingList = (event?['attendingUserDocuments'] as List?) ?? [];
    final isUserAttending =
        currentUserId != null &&
        attendingList.any((u) => u['id']?.toString() == currentUserId);
    if (_isLoading) {
      final skeletonColor =
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[300]!;
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Back button - Always visible
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  top: 18.h,
                  right: 10.w,
                  bottom: 0,
                ),
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
                          margin: EdgeInsets.only(
                            top: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
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
                              Container(
                                width: 180.w,
                                height: 20.h,
                                color: skeletonColor,
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 120.w,
                                height: 13.h,
                                color: skeletonColor,
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 100.w,
                                height: 13.h,
                                color: skeletonColor,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: List.generate(
                                  2,
                                  (i) => Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: Container(
                                      width: 60.w,
                                      height: 20.h,
                                      decoration: BoxDecoration(
                                        color: skeletonColor,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // 4. Organizer skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Container(
                                width: 40.sp,
                                height: 40.sp,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 14.h,
                                    color: skeletonColor,
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    width: 60.w,
                                    height: 12.h,
                                    color: skeletonColor,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  width: 28.sp,
                                  height: 28.sp,
                                  color: skeletonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Divider(),
                        // 5. People Attending skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Container(
                                width: 100.w,
                                height: 14.h,
                                color: skeletonColor,
                              ),
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  width: 28.sp,
                                  height: 28.sp,
                                  color: skeletonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(),
                        // 6. About Event skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: 120.w,
                            height: 18.h,
                            color: skeletonColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: 80.w,
                            height: 15.h,
                            color: skeletonColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 6.h,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 40.h,
                            color: skeletonColor,
                          ),
                        ),
                        Divider(),
                        // 7. Who can attend skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: 100.w,
                            height: 15.h,
                            color: skeletonColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 6.h,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 20.h,
                            color: skeletonColor,
                          ),
                        ),
                        Divider(),
                        // 8. Time frame skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: 80.w,
                            height: 15.h,
                            color: skeletonColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 6.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120.w,
                                height: 13.h,
                                color: skeletonColor,
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                width: 120.w,
                                height: 13.h,
                                color: skeletonColor,
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        // 9. Location skeleton
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            width: 80.w,
                            height: 15.h,
                            color: skeletonColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 6.h,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 20.h,
                            color: skeletonColor,
                          ),
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
                          child: Container(
                            width: 100.w,
                            height: 13.h,
                            color: skeletonColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.5,
                            children: List.generate(
                              2,
                              (i) => ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  width: double.infinity,
                                  height: 300.h,
                                  color: skeletonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        // 11. Attend button skeleton
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
        // Attend button - Always visible but disabled when loading
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
              text: 'Attend Event for Free',
              isLoading: true,
              onPressed: null,
              backgroundColor: const Color(0xffbbd953),
              textColor: Colors.black,
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 10.sp,
                fontFamily: 'Metropolis-Medium',
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    // Use event data or fallback to placeholders
    final eventName = event?['eventDocument']?['title'] ?? '';
    String eventBanner = '';
    if (event?['eventDocument'] != null &&
        event?['eventDocument']['bannerImageUrl'] != null) {
      eventBanner = event?['eventDocument']['bannerImageUrl'] as String;
    }
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
    final eventCategories =
        eventCategoryValue != null &&
                eventCategoryValue is String &&
                eventCategoryValue.isNotEmpty
            ? [eventCategoryValue]
            : [''];
    final organizer = event?['ownerDocument'] ?? {};
    final organizerName = organizer['fullname'] ?? '';
    final organizerUsername = organizer['username'] ?? '';
    final organizerProfilePic =
        organizer['image'] != null ? organizer['image'].toString() : '';
    final organizerId =
        organizer['id'] != null ? organizer['id'].toString() : '';
    final rewardPoints = event?['eventDocument']?['rewardEventPoint'] ?? '';
    final peopleAttending = event?['eventAttendCount'] ?? '';
    final eventDescription = event?['eventDocument']?['description'] ?? '';
    final whoCanAttend = event?['eventDocument']?['whoCanAttend'] ?? '';
    final timeFrame =
        (startDate.isNotEmpty && endDate.isNotEmpty)
            ? '$startDate - $endDate'
            : '';
    List<String> otherImages = [];
    if (event?['eventDocument'] != null &&
        event?['eventDocument']['otherImageUrl'] is List &&
        (event?['eventDocument']['otherImageUrl'] as List).isNotEmpty) {
      otherImages = List<String>.from(event?['eventDocument']['otherImageUrl']);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Custom nav bar (replace with back button)
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  top: 18.h,
                  right: 10.w,
                  bottom: 0,
                ),
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
              // 2. Event banner with overlay and reward
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap:
                          eventBanner.isNotEmpty
                              ? () {
                                final allImages = [eventBanner, ...otherImages];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => _GalleryView(
                                          images: allImages,
                                          initialIndex: 0,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child:
                            eventBanner.isNotEmpty
                                ? Image.network(
                                  eventBanner,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 300.h,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24.r),
                        ),
                        child: Container(
                          height: 90.h,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                      left: 20.w,
                      bottom: 20.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reward points',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFBF00),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '$rewardPoints points',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontFamily: 'Metropolis-Bold',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              // 3. Event name, date, location, categories
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
                      children:
                          eventCategories
                              .map(
                                (cat) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 7.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    cat ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontSize: 10.sp,
                                      fontFamily: 'Metropolis-SemiBold',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              // 4. Organizer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organizer',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-Medium',
                        color: Theme.of(context).hintColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {
                        final ownerDoc = event?['ownerDocument'];
                        if (ownerDoc != null && ownerDoc.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            '/user-profile',
                            arguments: ownerDoc,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          ProfilePicture(
                            fileName:
                                organizerProfilePic.isNotEmpty
                                    ? organizerProfilePic
                                    : null,
                            userId: organizerId.isNotEmpty ? organizerId : null,
                            size: 40.0.sp,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                organizerName,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                ),
                              ),
                              Text(
                                '@$organizerUsername',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontSize: 8.sp,
                                  color: Theme.of(context).hintColor,
                                  fontFamily: 'Metropolis-Medium',
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.navigate_next,
                            size: 20.sp,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Divider(),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _actionCircle(
                          context,
                          Provider.of<SavedEventsProvider>(
                                context,
                              ).isEventSaved(widget.eventId ?? '')
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          Provider.of<SavedEventsProvider>(
                                context,
                              ).isEventSaved(widget.eventId ?? '')
                              ? 'Saved'
                              : 'Save',
                          size: 50.sp,
                          iconSize: 20.sp,
                          bg: Colors.transparent,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.3),
                            width: 1,
                          ),
                          onTap: () {
                            final eventId = widget.eventId;
                            if (eventId != null) {
                              final savedEventsProvider =
                                  Provider.of<SavedEventsProvider>(
                                    context,
                                    listen: false,
                                  );
                              savedEventsProvider.toggleSaveEvent(
                                eventId,
                                event ?? {},
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                    child: Text(
                                      savedEventsProvider.isEventSaved(eventId)
                                          ? 'Event saved!'
                                          : 'Event removed from saved events',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _actionCircle(
                          context,
                          Icons.link_outlined,
                          'Copy link',
                          size: 50.sp,
                          iconSize: 20.sp,
                          bg: Colors.transparent,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.3),
                            width: 1,
                          ),
                          onTap: () {
                            final eventId = widget.eventId;
                            if (eventId != null) {
                              final eventLink =
                                  'https://kliks.app/event/$eventId';
                              Clipboard.setData(ClipboardData(text: eventLink));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                    child: Text(
                                      'Event link copied to clipboard!',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _actionCircle(
                          context,
                          Icons.calendar_today_outlined,
                          'To calendar',
                          size: 50.sp,
                          iconSize: 20.sp,
                          bg: const Color(0xffbbd953),
                          onTap: () {
                            if (eventName.isNotEmpty &&
                                startDateRaw.isNotEmpty &&
                                endDateRaw.isNotEmpty) {
                              try {
                                final eventToAdd = Event(
                                  title: eventName,
                                  description: eventDescription,
                                  location: eventLocation,
                                  startDate: DateTime.parse(startDateRaw),
                                  endDate: DateTime.parse(endDateRaw),
                                );
                                Add2Calendar.addEvent2Cal(eventToAdd);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 7,
                                      ),
                                      child: Text(
                                        'Could not add event to calendar.',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                    child: Text(
                                      'Event details are incomplete.',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _actionCircle(
                          context,
                          Icons.report_gmailerrorred_outlined,
                          'Report',
                          size: 50.sp,
                          iconSize: 20.sp,
                          bg: Colors.red,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              builder: (context) {
                                return _ReportEventSheet(
                                  eventId: widget.eventId!,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Divider(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              // Divider(),
              // 5. People Attending
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-Medium',
                              color: Theme.of(
                                context,
                              ).hintColor.withOpacity(0.5),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${(event?['attendingUserDocuments'] as List?)?.length ?? 0} attending',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-Medium',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      size: 28.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
              // 6. About Event
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
              // 7. Who can attend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Who can attend',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
              // 8. Time frame
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Time frame',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
              // 9. Location
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Bold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.2),
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
                        textStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: const Color(0xffbbd953),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
              // 10. Media upload
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Media uploads',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    // color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.8,
                  children:
                      otherImages.asMap().entries.map((entry) {
                        final img = entry.value;
                        final idx = entry.key;
                        return GestureDetector(
                          onTap:
                              img.isNotEmpty
                                  ? () {
                                    final allImages = [
                                      eventBanner,
                                      ...otherImages,
                                    ];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => _GalleryView(
                                              images: allImages,
                                              initialIndex: idx + 1,
                                            ),
                                      ),
                                    );
                                  }
                                  : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child:
                                (img.isNotEmpty)
                                    ? Image.network(
                                      img,
                                      width: double.infinity,
                                      height: 300.h,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: double.infinity,
                                      height: 300.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                    ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          !isUserAttending
              ? Padding(
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
                    text: 'Attend Event for Free',
                    isLoading: _isAttendingLoading,
                    onPressed:
                        _isAttendingLoading
                            ? null
                            : () async {
                              setState(() {
                                _isAttendingLoading = true;
                              });
                              final eventProvider = Provider.of<EventProvider>(
                                context,
                                listen: false,
                              );
                              final success = await eventProvider.attendEvent(
                                widget.eventId ?? '',
                              );
                              if (success) {
                                await _loadEvent();
                              }
                              setState(() {
                                _isAttendingLoading = false;
                              });
                            },
                    backgroundColor: const Color(0xffbbd953),
                    textColor: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 10.sp,
                      fontFamily: 'Metropolis-Medium',
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _actionCircle(
    BuildContext context,
    IconData icon,
    String label, {
    Color? bg,
    double size = 48,
    double iconSize = 24,
    BoxBorder? border,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color:
                  bg ??
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
              shape: BoxShape.circle,
              border: border,
            ),
            child: Icon(
              icon,
              color:
                  bg != null && bg != Colors.transparent
                      ? Colors.white
                      : theme.iconTheme.color,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
            fontFamily: 'Metropolis-Medium',
          ),
        ),
      ],
    );
  }
}

// Move _GalleryView here as a top-level widget
class _GalleryView extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  const _GalleryView({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                minScale: 0.8,
                maxScale: 2.5,
              );
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget at the bottom of the file (after _GalleryView)
class _ReportEventSheet extends StatefulWidget {
  final String eventId;
  const _ReportEventSheet({Key? key, required this.eventId}) : super(key: key);
  @override
  State<_ReportEventSheet> createState() => _ReportEventSheetState();
}

class _ReportEventSheetState extends State<_ReportEventSheet> {
  final List<String> reasons = [
    'Fake event',
    'Spam',
    'Drugs',
    'Hate speech',
    'False information',
    'Other',
  ];
  int? selectedIndex;
  bool showOther = false;
  final TextEditingController otherController = TextEditingController();
  final FocusNode otherFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void dispose() {
    otherController.dispose();
    otherFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double sheetPadding = 24.0;
    return Padding(
      padding: EdgeInsets.only(
        left: sheetPadding,
        right: sheetPadding,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child:
          showOther
              ? _buildOtherReason(context, widget.eventId)
              : _buildReasonList(context, widget.eventId),
    );
  }

  Widget _buildReasonList(BuildContext context, String eventId) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 5,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(height: 8),
        // Main text
        Text(
          'Why are you reporting this event',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        // Sub text
        Text(
          'This action is kept anonymous, help us maintain user privacy and security by reporting any false or fake events',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        // List of options
        ...List.generate(reasons.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  selectedIndex = i;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    selectedIndex == i ? 0.2 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        selectedIndex == i
                            ? const Color(0xffbbd953)
                            : theme.dividerColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        reasons[i],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          // fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'Metropolis-Medium',
                        ),
                      ),
                    ),
                    Radio<int>(
                      value: i,
                      groupValue: selectedIndex,
                      onChanged: (val) {
                        setState(() {
                          selectedIndex = val;
                        });
                      },
                      activeColor: const Color(0xffbbd953),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 24),
        CustomButton(
          text: 'Report',
          isLoading: isLoading,
          onPressed:
              selectedIndex == null || isLoading
                  ? null
                  : () async {
                    final eventProvider = Provider.of<EventProvider>(
                      context,
                      listen: false,
                    );
                    // final eventId =
                    //     (context
                    //         .findAncestorWidgetOfExactType<EventDetailPage>()
                    //         ?.eventId) ??
                    //     '';
                    final reportType = reasons[selectedIndex!];
                    String? description;
                    if (reportType == 'Other') {
                      setState(() {
                        showOther = true;
                      });
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    print('Reporting event: $eventId, type: $reportType');
                    print('Description: $description');

                    final success = await eventProvider.reportEvent(
                      eventId: eventId,
                      reportType: reportType,
                      description: '',
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 7,
                            ),
                            child: Text('Thank you for your report!'),
                          ),
                        ),
                      );
                    }
                  },
          backgroundColor:
              selectedIndex == null || isLoading
                  ? Colors.grey[300]
                  : const Color(0xffbbd953),
          textColor: Colors.black,
          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            fontFamily: 'Metropolis-Medium',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildOtherReason(BuildContext context, String eventId) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              showOther = false;
              otherController.clear();
            });
          },
        ),
        SizedBox(height: 8),
        // Main text
        Text(
          'State the other reason for reporting',
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: 'Metropolis-SemiBold',
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 16),
        // Text box
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  otherFocusNode.hasFocus
                      ? const Color(0xffbbd953)
                      : theme.dividerColor.withOpacity(0.2),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            focusNode: otherFocusNode,
            controller: otherController,
            minLines: 6, // Increased from 3
            maxLines: 10, // Increased from 5
            maxLength: 200,
            buildCounter: (
              context, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) {
              return const SizedBox.shrink(); // Hide default counter
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your reason...',
              counterText: '', // Hide default counter
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontFamily: 'Metropolis-Medium',
            ),
            onChanged: (_) => setState(() {}),
            onTap: () => setState(() {}),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            '${otherController.text.length}/200',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: theme.hintColor,
            ),
          ),
        ),

        SizedBox(height: 24),
        CustomButton(
          text: 'Report',
          isLoading: isLoading,
          onPressed:
              otherController.text.trim().isEmpty || isLoading
                  ? null
                  : () async {
                    final eventProvider = Provider.of<EventProvider>(
                      context,
                      listen: false,
                    );
                    final eventId =
                        (context
                            .findAncestorWidgetOfExactType<EventDetailPage>()
                            ?.eventId) ??
                        '';
                    final reportType = 'Other';
                    final description = otherController.text.trim();
                    setState(() {
                      isLoading = true;
                    });
                    final success = await eventProvider.reportEvent(
                      eventId: eventId,
                      reportType: reportType,
                      description: description,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 7,
                            ),
                            child: Text('Thank you for your report!'),
                          ),
                        ),
                      );
                    }
                  },
          backgroundColor:
              otherController.text.trim().isEmpty || isLoading
                  ? Colors.grey[300]
                  : const Color(0xffbbd953),
          textColor: Colors.black,
          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            fontFamily: 'Metropolis-Medium',
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

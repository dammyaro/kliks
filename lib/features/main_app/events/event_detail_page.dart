import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:intl/intl.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final isUserAttending = currentUserId != null && attendingList.any((u) => u['id']?.toString() == currentUserId);
    if (_isLoading) {
      final skeletonColor = Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!;
      return Scaffold(
        body: SafeArea(
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
                            Container(width: 80.w, height: 14.h, color: skeletonColor),
                            SizedBox(height: 4.h),
                            Container(width: 60.w, height: 12.h, color: skeletonColor),
                          ],
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: Container(width: 28.sp, height: 28.sp, color: skeletonColor),
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
      );
    }
    // Use event data or fallback to placeholders
    final eventName = event?['eventDocument']?['title'] ?? '';
    String eventBanner = '';
    if (event?['eventDocument'] != null && event?['eventDocument']['bannerImageUrl'] != null) {
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
    final eventCategories = eventCategoryValue != null && eventCategoryValue is String && eventCategoryValue.isNotEmpty
        ? [eventCategoryValue]
        : [''];
    final organizer = event?['ownerDocument'] ?? {};
    final organizerName = organizer['fullname'] ?? '';
    final organizerUsername = organizer['username'] ?? '';
    final organizerProfilePic = organizer['image'] != null ? organizer['image'].toString() : '';
    final organizerId = organizer['id'] != null ? organizer['id'].toString() : '';
    final rewardPoints = event?['eventDocument']?['rewardEventPoint'] ?? '';
    final peopleAttending = event?['eventAttendCount'] ?? '';
    final eventDescription = event?['eventDocument']?['description'] ?? '';
    final whoCanAttend = event?['eventDocument']?['whoCanAttend'] ?? '';
    final timeFrame = (startDate.isNotEmpty && endDate.isNotEmpty)
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
              // 1. Custom nav bar
              CustomNavBar(title: eventName),
              SizedBox(height: 10.h),
              // 2. Event banner with overlay and reward
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: eventBanner.isNotEmpty
                          ? Image.network(
                              eventBanner,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 300.h,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                            ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
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
                          Text('Reward points',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Metropolis-SemiBold',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFBF00),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text('$rewardPoints points',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    Text(eventName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20.sp,
                        fontFamily: 'Metropolis-Bold',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(eventDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: Theme.of(context).hintColor,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(eventLocation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
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
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(cat ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontFamily: 'Metropolis-SemiBold',
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              // 4. Organizer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Organizer',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: Theme.of(context).hintColor,
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
                            fileName: organizerProfilePic.isNotEmpty ? organizerProfilePic : null,
                            userId: organizerId.isNotEmpty ? organizerId : null,
                            size: 40.0.sp,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(organizerName,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontFamily: 'Metropolis-SemiBold',
                                ),
                              ),
                              Text('@$organizerUsername',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).hintColor,
                                  fontFamily: 'Metropolis-Regular',
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(Icons.navigate_next, size: 28.sp, color: Theme.of(context).iconTheme.color),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionCircle(context, Icons.bookmark_border, 'Save'),
                        _actionCircle(context, Icons.link_outlined, 'Copy link'),
                        _actionCircle(context, Icons.calendar_today_outlined, 'To calendar', bg: Colors.green),
                        _actionCircle(context, Icons.report_gmailerrorred_outlined, 'Report', bg: Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Divider(),
              // 5. People Attending
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('People Attending',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${(event?['attendingUserDocuments'] as List?)?.length ?? 0} attending',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontFamily: 'Metropolis-SemiBold',
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
              // 6. About Event
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('About Event',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    fontFamily: 'Metropolis-Bold',
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('Description',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(eventDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontFamily: 'Metropolis-Regular',
                  ),
                ),
              ),
              Divider(),
              // 7. Who can attend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('Who can attend',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(whoCanAttend,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontFamily: 'Metropolis-Regular',
                  ),
                ),
              ),
              Divider(),
              // 8. Time frame
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('Time frame',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Starts: $startDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-Regular',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text('Ends: $endDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-Regular',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // 9. Location
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('Location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                child: Text(eventLocation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
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
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: CustomButton(
                        text: 'Open maps',
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Divider(),
              // 10. Media upload
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('Media upload',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    color: Theme.of(context).hintColor,
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
                  childAspectRatio: 0.5,
                  children: otherImages.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: (img.isNotEmpty)
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
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ),
              Divider(),
              // 11. Attend button
              if (!isUserAttending)
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50.h,
                    child: CustomButton(
                      text: 'Attend Event for Free',
                      isLoading: _isAttendingLoading,
                      onPressed: _isAttendingLoading
                          ? null
                          : () async {
                              setState(() {
                                _isAttendingLoading = true;
                              });
                              final eventProvider = Provider.of<EventProvider>(context, listen: false);
                              final success = await eventProvider.attendEvent(widget.eventId ?? '');
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
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCircle(BuildContext context, IconData icon, String label, {Color? bg}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 48.sp,
          height: 48.sp,
          decoration: BoxDecoration(
            color: bg ?? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: bg != null ? Colors.white : theme.iconTheme.color, size: 24.sp),
        ),
        SizedBox(height: 4.h),
        Text(label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11.sp,
            fontFamily: 'Metropolis-SemiBold',
          ),
        ),
      ],
    );
  }
}
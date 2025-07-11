import 'package:kliks/shared/widgets/user_avatar_summary.dart';
import 'package:kliks/shared/widgets/checked_in_bottom_sheet.dart';
import 'package:kliks/shared/widgets/live_event_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:kliks/shared/widgets/main_app_bar.dart';
import 'package:kliks/shared/widgets/event_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:kliks/shared/widgets/onboarding_prompt.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/event_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/core/providers/checked_in_events_provider.dart';
import 'package:kliks/core/providers/organizer_live_events_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kliks/main.dart' show flutterLocalNotificationsPlugin;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final ScrollController _mainScrollController = ScrollController();
  List<dynamic> _events = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String _selectedFilter = 'none';
  final Map<String, Map<String, dynamic>> _eventDetailsCache = {};
  bool _isAttendingLoading = false;
  List<dynamic> _attendingEvents = [];
  Map<String, bool> _isFollowingMap = {};
  String? _userId;
  bool _hasLoaded = false;
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadData({bool forceReload = false}) async {
    if (_hasLoaded && !forceReload) return;
    setState(() {
      _isLoading = true;
    });
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final followProvider = Provider.of<FollowProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final events = await eventProvider.getEvents();
    final categories = await eventProvider.getAllCategory();
    final userId = await authProvider.getUserId();

    if (userId != null) {
      Provider.of<OrganizerLiveEventsProvider>(context, listen: false).updateLiveEvents(events, userId);
    }

    final List<dynamic> detailedEvents = [];
    for (var event in events) {
      final eventId = event['id']?.toString();
      if (eventId != null) {
        final detail = await eventProvider.getEventDetailById(eventId);
        if (detail != null) {
          detailedEvents.add(detail);
        }
      }
    }

    Map<String, bool> followingMap = {};
    for (var event in detailedEvents) {
      final ownerId = event['ownerDocument']?['id']?.toString();
      if (ownerId != null && ownerId.isNotEmpty) {
        final isFollowing = await followProvider.isFollowingUser(
          context: context,
          targetUserId: ownerId,
        );
        followingMap[ownerId] = isFollowing;
      }
    }
    setState(() {
      _events = detailedEvents;
      _categories = categories;
      _isFollowingMap = followingMap;
      _isLoading = false;
      _userId = userId;
      _hasLoaded = true;
    });
  }

  void _showLiveDashboardModal(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return LiveEventDashboard(event: event);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCurrentLocation();
      await _loadData();
    });
  }

  Future<void> _onRefresh() async {
    _hasLoaded = false;
    await _loadData(forceReload: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line to ensure the mixin works correctly
    final isProfileSetupComplete =
        context.watch<AuthProvider>().isProfileSetupComplete;

    List<dynamic> eventsToShow;
    if (_selectedFilter == 'attending') {
      eventsToShow = _attendingEvents;
    } else if (_selectedFilter == 'nearby') {
      if (_currentPosition != null) {
        final center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        eventsToShow = _events.where((e) {
          final eventLat = e['eventDocument']['lat'];
          final eventLng = e['eventDocument']['lng'];
          if (eventLat is num && eventLng is num) {
            final eventPosition = LatLng(eventLat.toDouble(), eventLng.toDouble());
            final distance = const Distance().as(LengthUnit.Kilometer, center, eventPosition);
            return distance <= 25;
          }
          return false;
        }).toList();
      } else {
        eventsToShow = [];
      }
    } else if (_selectedFilter == 'following') {
      eventsToShow = _events.where((e) {
        final userId = e['ownerDocument']?['id']?.toString();
        return userId != null && _isFollowingMap[userId] == true;
      }).toList();
    } else if (_selectedFilter == 'live') {
      eventsToShow = _events.where((e) => e['eventDocument']['isLive'] == true).toList();
    } else {
      eventsToShow = _events;
    }

    // Uniform skeleton color for light/dark mode
    final skeletonColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[300];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            children: [
              SizedBox(height: 10.h),
              const MainAppBar(),
              SizedBox(height: 5.h),
              EventFilter(
                onFilterChanged: (filter) async {
                  setState(() {
                    _selectedFilter = filter;
                    _isAttendingLoading = filter == 'attending';
                  });
                  if (filter == 'attending') {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    final userId = await authProvider.getUserId();
                    List<dynamic> attending = [];
                    for (var event in _events) {
                      final eventId = event['id'];
                      if (!_eventDetailsCache.containsKey(eventId)) {
                        final detail = await Provider.of<EventProvider>(
                          context,
                          listen: false,
                        ).getEventDetailById(eventId);
                        if (detail != null)
                          _eventDetailsCache[eventId] = detail;
                      }
                      final detail = _eventDetailsCache[eventId];
                      if (detail != null &&
                          (detail['attendingUserDocument'] as List?)?.any(
                                (u) => u['id'].toString() == userId,
                              ) ==
                              true) {
                        attending.add(event);
                      }
                    }
                    setState(() {
                      _attendingEvents = attending;
                      _isAttendingLoading = false;
                    });
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: DefaultTabController(
                  length: 1 + _categories.length,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: const Color(0xffbbd953),
                        labelColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        unselectedLabelColor:
                            Theme.of(context).textTheme.bodySmall?.color,
                        labelStyle: const TextStyle(
                          fontFamily: 'Metropolis-Medium',
                        ),
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          const Tab(text: 'All events'),
                          ..._categories.map<Widget>(
                            (cat) => Tab(text: cat['category'] ?? ''),
                          ),
                        ],
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            // For scrolling down: Trigger when the user scrolls down inside the list.
                            if (scrollNotification is ScrollUpdateNotification && scrollNotification.scrollDelta! > 0) {
                              _mainScrollController.animateTo(
                                _mainScrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                            // For scrolling up: Trigger when the user tries to scroll past the top of the list.
                            if (scrollNotification is OverscrollNotification && scrollNotification.overscroll < 0) {
                              _mainScrollController.animateTo(
                                0.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                            return true;
                          },
                          child: TabBarView(
                          children: [
                            // All events tab (original logic)
                            Column(
                              children: [
                                SizedBox(height: 20.h),
                                Consumer<OrganizerLiveEventsProvider>(
                                  builder: (context, organizerLiveEventsProvider, child) {
                                    final liveEventIds = organizerLiveEventsProvider.liveEventIds;
                                    if (liveEventIds.isEmpty) return SizedBox.shrink();
                                    return Column(
                                      children: liveEventIds.map((eventId) {
                                        final eventDetail = _eventDetailsCache[eventId] ?? _events.firstWhere(
                                          (e) => e['id']?.toString() == eventId || e['eventDocument']?['id']?.toString() == eventId,
                                          orElse: () => null,
                                        );
                                        if (eventDetail == null) return SizedBox.shrink();
                                        final eventName = eventDetail['eventDocument']?['title'] ?? eventDetail['title'] ?? '';
                                        final checkedInCount = (eventDetail['checkedInUserDocuments'] as List?)?.length ?? 0;
                                        return GestureDetector(
                                          onTap: () => _showLiveDashboardModal(context, eventDetail),
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffbbd953),
                                              borderRadius: BorderRadius.circular(50.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                UserAvatarSummary(
                                                  users: (eventDetail['attendingUserDocuments'] as List? ?? []),
                                                  avatarSize: 35.sp,
                                                ),
                                                SizedBox(width: 0.w),
                                                Text(
                                                  '•',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Expanded(
                                                  child: Text(
                                                    eventName,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Metropolis-Medium',
                                                      color: Colors.black,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                // Debug button for local notification
                                /*
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                    child: SizedBox(
                                      height: 32,
                                      width: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.notifications_active, color: Colors.red, size: 22),
                                        tooltip: 'Test Local Notification',
                                        onPressed: () async {
                                          await flutterLocalNotificationsPlugin.show(
                                            0,
                                            'Test Local Notification',
                                            'This is a test notification from the debug button.',
                                            NotificationDetails(
                                              android: AndroidNotificationDetails(
                                                'default_channel_id',
                                                'General',
                                                channelDescription: 'General notifications',
                                                importance: Importance.max,
                                                priority: Priority.high,
                                                icon: '@mipmap/ic_launcher',
                                              ),
                                              iOS: DarwinNotificationDetails(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                */
                                if (!isProfileSetupComplete)
                                  OnboardingPrompt(
                                    onContinue: () {
                                      print('Onboarding continued');
                                    },
                                  ),
                                Consumer2<CheckedInEventsProvider, EventProvider>(
                                  builder: (context, checkedInProvider, eventProvider, child) {
                                    final checkedInIds = checkedInProvider.getCheckedInEventIds();
                                    if (checkedInIds.isEmpty) return SizedBox.shrink();
                                    return Column(
                                      children: checkedInIds.map((eventId) {
                                        final eventDetail = _eventDetailsCache[eventId] ?? _events.firstWhere(
                                          (e) => e['id']?.toString() == eventId || e['eventDocument']?['id']?.toString() == eventId,
                                          orElse: () => null,
                                        );
                                        if (eventDetail == null) return SizedBox.shrink();
                                        final eventName = eventDetail['eventDocument']?['title'] ?? eventDetail['title'] ?? '';
                                        final checkedInUsers = eventDetail['attendingUserDocuments'] as List? ?? [];

                                        return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  CheckedInBottomSheet(
                                                event: eventDetail,
                                                onCheckOut: () {
                                                  // Optional: Add any additional logic needed after checkout
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.w, vertical: 6.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffbbd953),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                UserAvatarSummary(
                                                  users: checkedInUsers,
                                                  avatarSize: 35.sp,
                                                ),
                                                SizedBox(width: 0.w),
                                                Text(
                                                  '•',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Expanded(
                                                  child: Text(
                                                    eventName,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Metropolis-Medium',
                                                      color: Colors.black,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                Expanded(
                                  child:
                                      _isLoading
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (context, idx) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 8.h,
                                                ),
                                                child: Skeletonizer(
                                                  enabled: true,
                                                  child: EventCardSkeleton(
                                                    skeletonColor:
                                                        skeletonColor!,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          : _events.isEmpty
                                          ? Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .location_slash,
                                                    size: 35.sp,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                        ?.withOpacity(0.5),
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  Text(
                                                    'No Events to show here',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall?.copyWith(
                                                      fontSize: 15.sp,
                                                      fontFamily:
                                                          'Metropolis-SemiBold',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    'There are no events around you',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color
                                                              ?.withOpacity(
                                                                0.4,
                                                              ),
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              'Metropolis-Regular',
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : RefreshIndicator(
                                            onRefresh: _onRefresh,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount:
                                                  eventsToShow.length + 1,
                                              itemBuilder: (context, idx) {
                                                if (idx ==
                                                    eventsToShow.length) {
                                                  return SizedBox(
                                                    height: 140.h,
                                                  );
                                                }
                                                final event = eventsToShow[idx];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: 8.h,
                                                      ),
                                                      child: EventCard(
                                                        event: event,
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: 0.5,
                                                      color:
                                                          Theme.of(
                                                                    context,
                                                                  ).brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Colors
                                                                  .grey[300]!
                                                                  .withOpacity(
                                                                    0.7,
                                                                  )
                                                              : Colors
                                                                  .grey[100]!
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                ),
                              ],
                            ),
                            // Category tabs
                            ..._categories.map<Widget>((cat) {
                              final catName = cat['category'] as String?;
                              final filteredEvents = eventsToShow.where((e) {
                                // Handle potentially nested event data
                                final eventCat = e['eventDocument']?['category'] ?? e['category'];
                                if (catName == null) return false;

                                if (eventCat is Map &&
                                    eventCat['category'] != null &&
                                    eventCat['category'] is String) {
                                  return (eventCat['category'] as String).trim() ==
                                      catName.trim();
                                } else if (eventCat is String) {
                                  return eventCat.trim() == catName.trim();
                                } else if (eventCat is List) {
                                  return eventCat.any((c) =>
                                      c is String && c.trim() == catName.trim());
                                }
                                return false;
                              }).toList();

                              return Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  if (!isProfileSetupComplete)
                                    OnboardingPrompt(
                                      onContinue: () {
                                        print('Onboarding continued');
                                      },
                                    ),
                                  Consumer2<CheckedInEventsProvider, EventProvider>(
                                  builder: (context, checkedInProvider, eventProvider, child) {
                                    final checkedInIds = checkedInProvider.getCheckedInEventIds();
                                    if (checkedInIds.isEmpty) return SizedBox.shrink();
                                    return Column(
                                      children: checkedInIds.map((eventId) {
                                        final eventDetail = _eventDetailsCache[eventId] ?? _events.firstWhere(
                                          (e) => e['id']?.toString() == eventId || e['eventDocument']?['id']?.toString() == eventId,
                                          orElse: () => null,
                                        );
                                        if (eventDetail == null) return SizedBox.shrink();
                                        final eventName = eventDetail['eventDocument']?['title'] ?? eventDetail['title'] ?? '';
                                        final checkedInUsers = eventDetail['attendingUserDocuments'] as List? ?? [];

                                        return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  CheckedInBottomSheet(
                                                event: eventDetail,
                                                onCheckOut: () {
                                                  // Optional: Add any additional logic needed after checkout
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.w, vertical: 6.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffbbd953),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                UserAvatarSummary(
                                                  users: checkedInUsers,
                                                  avatarSize: 35.sp,
                                                ),
                                                SizedBox(width: 0.w),
                                                Text(
                                                  '•',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Expanded(
                                                  child: Text(
                                                    eventName,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Metropolis-Medium',
                                                      color: Colors.black,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                  Expanded(
                                    child: _isLoading
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (context, idx) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 8.h,
                                                ),
                                                child: Skeletonizer(
                                                  enabled: true,
                                                  child: EventCardSkeleton(
                                                    skeletonColor:
                                                        skeletonColor!,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : filteredEvents.isEmpty
                                            ? Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .location_slash,
                                                      size: 35.sp,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                          ?.withOpacity(0.5),
                                                    ),
                                                    SizedBox(height: 16.h),
                                                    Text(
                                                      'No Events to show here',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontSize: 15.sp,
                                                            fontFamily:
                                                                'Metropolis-SemiBold',
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 2.h),
                                                    Text(
                                                      'There are no events in this category',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: Theme.of(
                                                                  context,
                                                                )
                                                                .textTheme
                                                                .bodySmall
                                                                ?.color
                                                                ?.withOpacity(
                                                                  0.4,
                                                                ),
                                                            fontSize: 12.sp,
                                                            fontFamily:
                                                                'Metropolis-Regular',
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : RefreshIndicator(
                                                onRefresh: _onRefresh,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  itemCount:
                                                      filteredEvents.length +
                                                          1,
                                                  itemBuilder:
                                                      (context, idx) {
                                                    if (idx ==
                                                        filteredEvents
                                                            .length) {
                                                      return SizedBox(
                                                        height: 140.h,
                                                      );
                                                    }
                                                    final event =
                                                        filteredEvents[idx];
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: 8.h,
                                                          ),
                                                          child: EventCard(
                                                            event: event,
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 1,
                                                          thickness: 0.5,
                                                          color: Theme.of(
                                                                    context)
                                                                .brightness ==
                                                                Brightness.light
                                                              ? Colors.grey[300]!
                                                                  .withOpacity(
                                                                  0.4,
                                                                )
                                                              : Colors.grey[100]!
                                                                  .withOpacity(
                                                                  0.2,
                                                                ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                  )],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
   }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }
}

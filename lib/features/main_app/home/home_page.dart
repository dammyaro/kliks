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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
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
    Map<String, bool> followingMap = {};
    for (var event in events) {
      final userId = event['userId']?.toString();
      if (userId != null && userId.isNotEmpty) {
        final isFollowing = await followProvider.isFollowingUser(
          context: context,
          targetUserId: userId,
        );
        followingMap[userId] = isFollowing;
      }
    }
    setState(() {
      _events = events;
      _categories = categories;
      _isFollowingMap = followingMap;
      _isLoading = false;
      _userId = userId;
      _hasLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
      eventsToShow = _events.where((e) => e['isNearBy'] == true).toList();
    } else if (_selectedFilter == 'following') {
      eventsToShow =
          _events.where((e) {
            final userId = e['userId']?.toString();
            return userId != null && _isFollowingMap[userId] == true;
          }).toList();
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
                        child: TabBarView(
                          children: [
                            // All events tab (original logic)
                            Column(
                              children: [
                                SizedBox(height: 20.h),
                                if (!isProfileSetupComplete)
                                  OnboardingPrompt(
                                    onContinue: () {
                                      print('Onboarding continued');
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
                                          ? Expanded(
                                            child: Center(
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
                              final catName = cat['category'];
                              // Start with all events in this category
                              List<dynamic> filteredEvents =
                                  _events.where((e) {
                                    final eventCat = e['category'];
                                    if (eventCat is Map &&
                                        eventCat['category'] != null) {
                                      return eventCat['category'] == catName;
                                    } else if (eventCat is String) {
                                      return eventCat == catName;
                                    } else if (eventCat is List) {
                                      return eventCat.contains(catName);
                                    }
                                    return false;
                                  }).toList();
                              // Apply the selected filter to the category events
                              if (_selectedFilter == 'nearby') {
                                filteredEvents =
                                    filteredEvents
                                        .where((e) => e['isNearBy'] == true)
                                        .toList();
                              } else if (_selectedFilter == 'following') {
                                filteredEvents =
                                    filteredEvents.where((e) {
                                      final userId = e['userId']?.toString();
                                      return userId != null &&
                                          _isFollowingMap[userId] == true;
                                    }).toList();
                              } else if (_selectedFilter == 'attending') {
                                filteredEvents =
                                    filteredEvents.where((e) {
                                      final eventId = e['id'];
                                      final detail =
                                          _eventDetailsCache[eventId];
                                      return detail != null &&
                                          _userId != null &&
                                          (detail['attendingUserDocument']
                                                      as List?)
                                                  ?.any(
                                                    (u) =>
                                                        u['id'].toString() ==
                                                        _userId,
                                                  ) ==
                                              true;
                                    }).toList();
                              }
                              return Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  if (!isProfileSetupComplete)
                                    OnboardingPrompt(
                                      onContinue: () {
                                        print('Onboarding continued');
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
                                            : filteredEvents.isEmpty
                                            ? Expanded(
                                              child: Center(
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
                                              ),
                                            )
                                            : RefreshIndicator(
                                              onRefresh: _onRefresh,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                itemCount:
                                                    filteredEvents.length + 1,
                                                itemBuilder: (context, idx) {
                                                  if (idx ==
                                                      filteredEvents.length) {
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
                                                        color:
                                                            Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Colors
                                                                    .grey[300]!
                                                                    .withOpacity(
                                                                      0.4,
                                                                    )
                                                                : Colors
                                                                    .grey[100]!
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

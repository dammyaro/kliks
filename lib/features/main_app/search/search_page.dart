import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'dart:async';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';

import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/event_search_tile.dart';
import 'package:kliks/shared/widgets/user_search_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> _searchHistory = [];
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  bool _hasMoreUsers = true;
  bool _hasMoreEvents = true;
  int _userOffset = 0;
  int _eventOffset = 0;
  final int _limit = 10; 
  String _searchTerm = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    setState(() => _isLoadingHistory = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final history = await authProvider.getSearchHistory(searchType: 'User');
    setState(() {
      _searchHistory = history;
      _isLoadingHistory = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        (_hasMoreUsers || _hasMoreEvents)) {
      _fetchResults();
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _searchTerm = value;
        _results.clear();
        _userOffset = 0;
        _eventOffset = 0;
        _hasMoreUsers = true;
        _hasMoreEvents = true;
      });
      _fetchResults(reset: true);
    });
  }

  Future<void> _fetchResults({bool reset = false}) async {
    if (_isLoading || (!_hasMoreUsers && !_hasMoreEvents && !reset)) return;
    if (!mounted) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    final futureUsers = _hasMoreUsers
        ? authProvider.fetchUsers(
            searchName: _searchTerm,
            limit: _limit,
            offset: _userOffset,
          )
        : Future.value(<Map<String, dynamic>>[]);

    final futureEvents = _hasMoreEvents
        ? eventProvider.getEvents(
            search: _searchTerm,
            limit: _limit,
            offset: _eventOffset,
          )
        : Future.value(<Map<String, dynamic>>[]);

    final results = await Future.wait([futureUsers, futureEvents]);
    if (!mounted) return;
    final newUsers = List<Map<String, dynamic>>.from(results[0]);
    final newEvents = List<Map<String, dynamic>>.from(results[1]);

    setState(() {
      if (reset) _results = [];
      _isLoading = false;

      _userOffset += newUsers.length;
      _hasMoreUsers = newUsers.length == _limit;

      _eventOffset += newEvents.length;
      _hasMoreEvents = newEvents.length == _limit;

      final combined = [...newUsers, ...newEvents];
      combined.shuffle();
      _results.addAll(combined);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 50.h,
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: SizedBox(
                        height: 50.h,
                        child: TextField(
                          controller: _controller,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 13.sp,
                                  fontFamily: 'Metropolis-Medium',
                                  color: Colors.grey[500],
                                ),
                            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Metropolis-Medium',
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      // Cupertino filter icon
                      // CupertinoIcons.line_horizontal_3_decrease is the filter icon
                      // Import CupertinoIcons if not already imported
                      CupertinoIcons.line_horizontal_3_decrease,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/search-filter');
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              if (_controller.text.isEmpty)
                ...[
                  Text(
                    'Recently searched',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Metropolis-SemiBold',
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                  ),
                  SizedBox(height: 16.h),
                  if (_isLoadingHistory)
                    Center(child: CircularProgressIndicator())
                  else if (_searchHistory.isEmpty)
                    Center(
                      child: Text(
                        'No recent searches',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchHistory.length,
                        itemBuilder: (context, index) {
                          final historyItem = _searchHistory[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                            onTap: () {
                              _controller.text = historyItem['searchParam'] ?? '';
                              _onSearchChanged(_controller.text);
                            },
                            title: Text(
                              historyItem['searchParam'] ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-Regular',
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                              ),
                            ),
                            trailing: Icon(
                              Icons.north_west,
                              size: 12.sp,
                              color: const Color(0xffbbd953),
                            ),
                          );
                        },
                      ),
                    ),
                ]
              else
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _results.length + (_hasMoreUsers || _hasMoreEvents ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _results.length) {
                        final item = _results[index];
                        if (item.containsKey('username')) {
                          return UserSearchTile(user: item);
                        } else {
                          return EventSearchTile(event: item);
                        }
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

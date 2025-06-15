import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'dart:async';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _searchHistory = [];
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 20;
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
      _fetchUsers();
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _searchTerm = value;
        _users.clear();
        _offset = 0;
        _hasMore = true;
      });
      _fetchUsers(reset: true);
    });
  }

  Future<void> _fetchUsers({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;
    setState(() => _isLoading = true);
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final newUsers = await provider.fetchUsers(
      searchName: _searchTerm,
      limit: _limit,
      offset: _offset,
    );
    setState(() {
      if (reset) _users = [];
      _users.addAll(newUsers);
      _isLoading = false;
      _offset += newUsers.length;
      _hasMore = newUsers.length == _limit;
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
                    onPressed: () {},
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
                    itemCount: _users.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _users.length) {
                        final user = _users[index];
                        if (user['fullname'] == null || user['fullname'].toString().trim().isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          leading: ProfilePicture(
                            fileName: user['image'],
                            userId: user['id']?.toString() ?? '',
                            size: 40,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/user-profile', arguments: user);
                          },
                          title: Row(
                            children: [
                              SizedBox(width: 0.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user['fullname'] ?? 'No Name',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 13.sp,
                                        fontFamily: 'Metropolis-Medium',
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    SizedBox(height: 0.h),
                                    Text(
                                      '@${user['username']}' ?? '',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 10.sp,
                                        fontFamily: 'Metropolis-Light',
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.north_west,
                            size: 12.sp,
                            color: const Color(0xffbbd953),
                          ),
                        );
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

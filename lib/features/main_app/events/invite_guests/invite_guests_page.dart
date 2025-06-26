import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';

class InviteGuestsPage extends StatefulWidget {
  const InviteGuestsPage({super.key});

  @override
  State<InviteGuestsPage> createState() => _InviteGuestsPageState();
}

class _InviteGuestsPageState extends State<InviteGuestsPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final List<Map<String, dynamic>> _selectedUsers = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is List && args.isNotEmpty) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // Get IDs already in _selectedUsers
        final existingIds = _selectedUsers.map((u) => u['id'].toString()).toSet();
        List<Map<String, dynamic>> newUsers = [];
        for (final id in args) {
          if (!existingIds.contains(id.toString())) {
            final user = await authProvider.getUserById(id);
            if (user != null) newUsers.add(user);
          }
        }
        if (newUsers.isNotEmpty) {
          setState(() {
            _selectedUsers.addAll(newUsers);
          });
        }
      }
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _searchResults = [];
      _searchTerm = '';
      _searchController.clear();
      _offset = 0;
      _hasMore = true;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value;
      _searchResults = [];
      _offset = 0;
      _hasMore = true;
    });
    _fetchUsers(reset: true);
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
      if (reset) _searchResults = [];
      _searchResults.addAll(newUsers);
      _isLoading = false;
      _offset += newUsers.length;
      _hasMore = newUsers.length == _limit;
    });
  }

  void _selectUser(Map<String, dynamic> user) {
    if (_selectedUsers.any((u) => u['id'] == user['id'])) return;
    setState(() {
      _selectedUsers.add(user);
      _isSearching = false;
    });
  }

  void _removeUser(String userId) {
    setState(() {
      _selectedUsers.removeWhere((u) => u['id'] == userId);
    });
  }

  void _finish() {
    Navigator.pop(context, _selectedUsers.map((u) => u['id'].toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_outlined, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '', // Centered title if needed
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
                  ),
                  TextButton(
                    onPressed: _selectedUsers.isNotEmpty ? _finish : null,
                    child: Text('Done', style: theme.textTheme.bodyMedium?.copyWith(
                      color: _selectedUsers.isNotEmpty ? theme.textTheme.bodyMedium?.color : Colors.grey,
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchView(theme)
                  : _buildMainView(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Icon(CupertinoIcons.person_add, size: 30.sp, color: Colors.grey),
            // SizedBox(height: 20.h),
            Text(
              _selectedUsers.isEmpty ? 'Invite guests' : 'Invite more guests',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                fontFamily: 'Metropolis-Medium',
                letterSpacing: 0,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            Text(
              _selectedUsers.isEmpty ? 'Search for guests' : 'Search for more guests',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Regular',
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: _startSearch,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffbbd953),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
              ),
              child: Text('Search', style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: 'Metropolis-Medium',
              )),
            ),
            SizedBox(height: 32.h),
            if (_selectedUsers.isNotEmpty)
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedUsers.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final user = _selectedUsers[index];
                      return ListTile(
                        leading: ProfilePicture(
                          fileName: user['image'],
                          userId: user['id']?.toString() ?? '',
                          size: 40,
                        ),
                        title: Text(user['fullname'] ?? '', style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp, fontFamily: 'Metropolis-Medium' )),
                        subtitle: Text('@${user['username']}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.sp)),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeUser(user['id'].toString()),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchView(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: SizedBox(
                    height: 50.h,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              fontFamily: 'Metropolis-Medium',
                              color: Colors.grey[500],
                            ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Metropolis-Medium',
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 24.sp),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      if (user['fullname'] == null || user['fullname'].toString().trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: ProfilePicture(
                          fileName: user['image'],
                          userId: user['id']?.toString() ?? '',
                          size: 40,
                        ),
                        title: Text(user['fullname'] ?? '', style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp, fontFamily: 'Metropolis-Medium')),
                        subtitle: Text('@${user['username']}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.sp)),
                        onTap: () => _selectUser(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
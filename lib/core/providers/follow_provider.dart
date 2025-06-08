import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class FollowProvider with ChangeNotifier {
  final ApiService _apiService;

  FollowProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

  Future<List<Map<String, dynamic>>> fetchFollowers({
    int limit = 10,
    int offset = 0,
    bool? isAccepted,
    bool? isRejected,
    String? searchName,
  }) async {
    try {
      final response = await _apiService.getFollowers(
        limit: limit,
        offset: offset,
        isAccepted: isAccepted,
        isRejected: isRejected,
        searchName: searchName,
      );
      print('Followers response: \\${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('fetchFollowers error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchFollowings({
    int limit = 10,
    int offset = 0,
    bool? isAccepted,
    bool? isRejected,
    String? searchName,
  }) async {
    try {
      final response = await _apiService.getFollowings(
        limit: limit,
        offset: offset,
        isAccepted: isAccepted,
        isRejected: isRejected,
        searchName: searchName,
      );
      print('Followings response: \\${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('fetchFollowings error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers({
    required String searchName,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.getSearchUser(
        searchName: searchName,
        limit: limit,
        offset: offset,
      );
      print('Search user response: \\${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('fetchUsers error: $e');
      return [];
    }
  }

  Future<bool> followUser(String followedUserId) async {
    try {
      final response = await _apiService.get('/auth/follow/$followedUserId');
      print('Follow user response: \\${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Follow user error: $e');
      return false;
    }
  }

  Future<bool> acceptFollow(String followerUserId) async {
    try {
      final response = await _apiService.get('/auth/acceptFollow/$followerUserId');
      print('Accept follow response: \\${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('acceptFollow error: $e');
      return false;
    }
  }

  Future<bool> rejectFollow(String followerUserId) async {
    try {
      final response = await _apiService.get('/auth/rejectFollow/$followerUserId');
      print('Reject follow response: \\${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('rejectFollow error: $e');
      return false;
    }
  }

  Future<bool> unfollow(String followedUserId) async {
    try {
      final response = await _apiService.get('/auth/unfollow/$followedUserId');
      print('Unfollow response: \\${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('unfollow error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBlockedUsers({
    int limit = 10,
    int offset = 0,
    String? searchName,
  }) async {
    try {
      String url = '/auth/getBlockedUsers?limit=$limit&offset=$offset';
      if (searchName != null && searchName.isNotEmpty) {
        url += '&searchName=${Uri.encodeComponent(searchName)}';
      }
      final response = await _apiService.get(url);
      print('Blocked users response: \\${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('getBlockedUsers error: $e');
      return [];
    }
  }

  Future<bool> blockUser(String blockedUserId) async {
    try {
      final response = await _apiService.get('/auth/block/$blockedUserId');
      print('Block user response: \\${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('blockUser error: $e');
      return false;
    }
  }

  Future<bool> unblockUser(String blockedUserId) async {
    try {
      final response = await _apiService.get('/auth/unblock/$blockedUserId');
      print('Unblock user response: \\${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('unblockUser error: $e');
      return false;
    }
  }

  Future<bool> isFollowingUser({required BuildContext context, required String targetUserId}) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final profile = await authProvider.retrieveProfile();
      final currentUserId = profile?['id'];
      if (currentUserId == null) return false;
      final followings = await fetchFollowings();
      // print('Followings from IFU:');
      // print(followings);
      return followings.any((user) => user['followedUserId'].toString() == targetUserId);
    } catch (e) {
      print('isFollowingUser error: $e');
      return false;
    }
  }
} 
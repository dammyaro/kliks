import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class NotificationsProvider with ChangeNotifier {
  final ApiService _apiService;

  List<dynamic> _notifications = [];
  bool _notificationsLoaded = false;
  Map<String, dynamic> _lastFetchParams = {};

  List<dynamic> get notifications => _notifications;
  bool get notificationsLoaded => _notificationsLoaded;

  NotificationsProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  Map<String, bool> notificationSwitches = {};

  Future<void> getNotificationSettings() async {
    try {
      final response = await _apiService.get('/transaction/getNotificationSetting');
      printWrapped('Notification settings response: \\${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      notificationSwitches = {
        for (final item in data)
          if (item['notificationType'] != null && item['isOn'] != null)
            item['notificationType']: item['isOn'] == true
      };
      notifyListeners();
    } catch (e) {
      print('getNotificationSettings error: $e');
    }
  }

  Future<void> updateNotificationSetting({
    required String notificationType,
    required bool isOn,
  }) async {
    try {
      final response = await _apiService.post(
        '/transaction/updateNotificationSetting',
        data: {
          'notificationType': notificationType,
          'isOn': isOn,
        },
      );
      print('Update notification setting response: \\${response.data}');
    } catch (e) {
      print('updateNotificationSetting error: $e');
    }
  }

  Future<void> updateNotificationRead({
    required String notificationId,
    required bool isAllRead,
  }) async {
    // TODO: The backend for updating notification read status is not yet implemented.
    // This needs to be addressed before this feature can be considered complete.
    // See issue #6 for more details.

    // DEBUG: Print parameters received by the provider
    print("NotificationsProvider: updateNotificationRead called with ID: '$notificationId', isAllRead: $isAllRead");

    // Optimistically update the local state first for a responsive UI
    if (isAllRead) {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    } else {
      final index =
          _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    }
    notifyListeners();

    // Then, make the API call to persist the change
    try {
      final response = await _apiService.post(
        '/transaction/updateNotificationRead',
        data: {
          'notificationId': notificationId,
          'isAllRead': isAllRead,
        },
      );
      // DEBUG: Print API response
      print('NotificationsProvider: API response for updateNotificationRead: ${response.data}');
    } catch (e) {
      // DEBUG: Print API error
      print('NotificationsProvider: updateNotificationRead error: $e');
      // Optional: Revert the change on API error
      // For now, we'll leave it as is for a better user experience,
      // as this kind of error is rare.
    }
  }

  Future<void> fetchMyNotifications({
    String? notificationType,
    int limit = 10,
    int offset = 0,
    bool forceReload = false,
  }) async {
    if (_notificationsLoaded && !forceReload) return;

    _lastFetchParams = {
      'notificationType': notificationType,
      'limit': limit,
      'offset': offset,
    };

    try {
      final params = <String, dynamic>{
        if (notificationType != null) 'notificationType': notificationType,
        'limit': limit,
        'offset': offset,
      };
      final url = '/transaction/getMyNotifications/?limit=$limit&offset=$offset';
      final response = await _apiService.get(url);
      _notifications = response.data as List<dynamic>? ?? [];
      print(_notifications);
      _notificationsLoaded = true;
      notifyListeners();
    } catch (e) {
      _notifications = [];
      _notificationsLoaded = false;
    }
  }

  void clearNotificationsCache() {
    _notifications = [];
    _notificationsLoaded = false;
    notifyListeners();
  }
} 
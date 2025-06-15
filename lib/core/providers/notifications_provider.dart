import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class NotificationsProvider with ChangeNotifier {
  final ApiService _apiService;

  List<dynamic> _notifications = [];
  bool _notificationsLoaded = false;

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
    try {
      final response = await _apiService.post(
        '/transaction/updateNotificationRead',
        data: {
          'notificationId': notificationId,
          'isAllRead': isAllRead,
        },
      );
      print('Update notification read response: \\${response.data}');
    } catch (e) {
      print('updateNotificationRead error: $e');
    }
  }

  Future<void> fetchMyNotifications({
    String? notificationType,
    int limit = 10,
    int offset = 0,
    bool forceReload = false,
  }) async {
    if (_notificationsLoaded && !forceReload) return;
    try {
      final params = <String, dynamic>{
        if (notificationType != null) 'notificationType': notificationType,
        'limit': limit,
        'offset': offset,
      };
      final url = '/transaction/getMyNotifications/?limit=$limit&offset=$offset';
      final response = await _apiService.get(url);
      _notifications = response.data as List<dynamic>? ?? [];
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
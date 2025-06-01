import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class NotificationsProvider with ChangeNotifier {
  final ApiService _apiService;

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
} 
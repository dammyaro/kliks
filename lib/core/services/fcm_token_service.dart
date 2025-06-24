import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';

class FcmTokenService {
  final ApiService _apiService;

  FcmTokenService({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  /// Call this after login, registration, or app start.
  Future<void> registerTokenWithBackend() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _apiService.get('/auth/addUserToken/$token');
      }
    } catch (e) {
      print('Error registering FCM token: $e');
    }
  }

  /// Call this on logout.
  Future<void> removeTokenFromBackend() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _apiService.get('/auth/removeUserToken/$token');
      }
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }

  /// Listen for token refreshes and update backend.
  void listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        await _apiService.get('/auth/addUserToken/$newToken');
      } catch (e) {
        print('Error updating FCM token on refresh: $e');
      }
    });
  }
} 
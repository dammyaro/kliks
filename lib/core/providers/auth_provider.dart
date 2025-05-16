import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = locator<ApiService>();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    final token = await _apiService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  bool _isVerified = false;
  String? currentEmail;

  AuthProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  bool get isAuthenticated => _isAuthenticated;
  bool get isVerified => _isVerified;

  // Get device info as a string
  Future<String> getDeviceInfoString() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Android ${androidInfo.model} (SDK ${androidInfo.version.sdkInt})';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'iOS ${iosInfo.utsname.machine} (${iosInfo.systemVersion})';
    } else {
      return 'Unknown device';
    }
  }

  // Post device info to /updateDeviceInfo
  Future<void> updateDeviceInfo() async {
    try {
      final deviceInfoString = await getDeviceInfoString();
      await _apiService.post(
        '/auth/updateDeviceInfo',
        data: {'deviceInfo': deviceInfoString},
      );
    } catch (e) {
      print('Update device info error: $e');
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _apiService.getToken();
    _isAuthenticated = token != null;
    _isVerified = await _apiService.getIsVerified();
    notifyListeners();
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    await _apiService.clearIsVerified();
    _isAuthenticated = false;
    _isVerified = false;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String referralCode,
    required String gender,
    required dynamic dob,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'referral_code': referralCode,
          'gender': gender,
          'dob': dob,
        },
      );

      print('Signup response: ${response.data}');
      final user = response.data['user'];
      if (user != null && user['id'] != null) {
        await _apiService.saveToken(user['id']);
        final isVerified = user['isVerified'] == true;
        await _apiService.saveIsVerified(isVerified);
        _isAuthenticated = true;
        _isVerified = isVerified;
        setCurrentEmail(email);
        await updateDeviceInfo(); // Update device info after successful register
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final user = response.data['user'];
      if (user != null && user['id'] != null) {
        await _apiService.saveToken(user['id']);
        final isVerified = user['isVerified'] == true;
        await _apiService.saveIsVerified(isVerified);
        _isAuthenticated = true;
        _isVerified = isVerified;
        setCurrentEmail(email);
        await updateDeviceInfo(); // Update device info after successful login
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // TO DO : Check if the backend API is already updating the isVerified status on the database
  // If it is, you can remove the manual update in the verifyEmail method
  // and just call the API to verify the email

  Future<void> logoutUser() async {
    await _apiService.clearToken();
    await _apiService.clearIsVerified();
    _isAuthenticated = false;
    _isVerified = false;
    currentEmail = null;
    notifyListeners();
  }

  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/verifyEmail',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      if (response.data['success'] == true || response.data['verified'] == true) {
        await _apiService.saveIsVerified(true);
        _isVerified = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Verification error: $e');
      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      await _apiService.post(
        '/auth/resendOtp',
        data: {"email": email},
      );
      return true;
    } catch (e) {
      print('Resend OTP error: $e');
      return false;
    }
  }

  void setCurrentEmail(String email) {
    currentEmail = email;
  }
}
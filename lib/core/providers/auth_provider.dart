import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:kliks/core/services/media_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  // bool _isVerified = false;
  String? currentEmail;
  Map<String, dynamic>? _profile;
  String? profilePictureFileName;

  AuthProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  bool get isAuthenticated => _isAuthenticated;
  // bool get isVerified => _isVerified;
  Map<String, dynamic>? get profile => _profile;

  bool _isProfileSetupComplete = false;
  bool get isProfileSetupComplete => _isProfileSetupComplete;

  Future<String?> get token async => await _apiService.getToken();
  // Future<String?> get userId async => await _apiService.getUserId();
  
  Future<String?> getUserId() async {
    try {
        return await _apiService.getUserId();
    } catch (e) {
        print('getUserId error: $e');
      return null;
    }
  }

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
    // _isVerified = await _apiService.getIsVerified();
    notifyListeners();
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    // await _apiService.clearIsVerified();
    _isAuthenticated = false;
    // _isVerified = false;
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
      // No token processing here, only check if user exists
      if (user != null) {
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
      print('Login response: ${response.data}');
      final user = response.data['user'];
      final accessToken = response.data['token']?['access_token'];
      if (user != null && accessToken != null) {
        await _apiService.saveToken(accessToken);
        final isVerified = user['isVerified'] == true || response.data['isVerified'] == true;
        // await _apiService.saveIsVerified(isVerified);
        await _apiService.saveUserId(user['id'].toString());
        _isAuthenticated = true;
        // _isVerified = isVerified;
        setCurrentEmail(email);
        loadProfile(); // Load profile after successful login
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
    // await _apiService.clearIsVerified();
    await _apiService.clearUserId();
    _isAuthenticated = false;
    // _isVerified = false;
    currentEmail = null;
    notifyListeners();
  }

  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      print('Verifying email: $email, OTP: $otp');
      final response = await _apiService.post(
        '/auth/verifyEmail',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      print('Verification response: $response');
      final accessToken = response.data['token']?['access_token'];
      final userId = response.data['user']['id'];
      print('Access token: $accessToken');
      if ((response.data['status'] == "success") && accessToken != null) {
        await _apiService.saveToken(accessToken);
        await _apiService.saveUserId(userId);
        loadProfile(); // Load profile after successful verification
        // await _apiService.saveIsVerified(true);
        // _isVerified = true;
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

  Future<bool> updateProfile({
    required String field,
    required dynamic value,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/updateProfile',
        data: {
          field: value,
        },
      );
      print('Update profile response: ${response.data}');
      await loadProfile(); // Reload profile after update
      await checkProfileSetupComplete();
      notifyListeners();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> updateCategories({
    required List<String> categories,
  }) async {
    try {
      // Fetch current categories from profile if available
      List<String> existingCategories = [];
      if (_profile != null && _profile!['categories'] is List) {
        existingCategories = List<String>.from(_profile!['categories']);
      } else {
        // Optionally, fetch profile if not loaded
        if (_profile == null) {
          await loadProfile();
        }
        if (_profile != null && _profile!['categories'] is List) {
          existingCategories = List<String>.from(_profile!['categories']);
        }
      }

      print('Existing categories: $existingCategories');
      print('Updating categories to: $categories');

      final response = await _apiService.postAuth(
        '/auth/updateCategories',
        data: {
          'categories': categories,
        },
      );
      print('Update category response: ${response.data}');
      await loadProfile();
      await checkProfileSetupComplete();
      notifyListeners();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Update category error: $e');
      return false;
    }
  }

  Future<bool> fetchIsVerified() async {
    try {
      final response = await _apiService.get('/auth/getLoggedInUser');
      // Assumes the backend returns { ..., isVerified: true/false, ... }
      final isVerified = response.data['isVerified'] == true;
      return isVerified;
    } catch (e) {
      print('fetchIsVerified error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> retrieveProfile() async {
    try {
      final response = await _apiService.get('/auth/getLoggedInUser');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print('retrieveProfile error: $e');
      return null;
    }
  }

  void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

  Future<void> loadProfile() async {
    _profile = await retrieveProfile();
    printWrapped('Loaded profile: $_profile');
    await checkProfileSetupComplete();
    notifyListeners();
  }

  void setCurrentEmail(String email) {
    currentEmail = email;
  }

  /// Checks if location is allowed and profile categories are set (not null or empty).
  Future<void> checkProfileSetupComplete() async {
    bool locationAllowed = false;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        locationAllowed = true;
      }
    } catch (e) {
      print('Location permission check error: $e');
      locationAllowed = false;
    }

    final categories = _profile?['categories'];
    final hasCategories = categories is List && categories.isNotEmpty;

    _isProfileSetupComplete = locationAllowed && hasCategories;
    notifyListeners();
  }

  Future<void> updateProfilePicture(File file) async {
    final mediaService = MediaService();
    final fileName = await mediaService.uploadProfilePicture(
      file: file,
      folderName: 'profile_pictures',
    );
    if (fileName != null) {
      // Save fileName to your backend user profile (call your updateProfile API)
      await updateProfile(field: 'image', value: fileName);
      await loadProfile();
      // Optionally update local state
      profilePictureFileName = fileName;
      notifyListeners();
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

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await _apiService.get('/auth/getUserProfile/$userId');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print('getUserById error: $e');
      return null;
    }
  }

}
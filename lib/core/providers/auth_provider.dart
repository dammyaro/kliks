import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:kliks/core/services/media_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kliks/core/services/fcm_token_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final FcmTokenService _fcmTokenService = FcmTokenService();
  bool _isAuthenticated = false;
  // bool _isVerified = false;
  String? currentEmail;
  Map<String, dynamic>? _profile;
  String? profilePictureFileName;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        // await _fcmTokenService.registerTokenWithBackend(); // Moved to after verifyEmail
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
        await _fcmTokenService.registerTokenWithBackend();
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
    await _fcmTokenService.removeTokenFromBackend();
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
      printWrapped('Verification response: $response');
      final accessToken = response.data['token']?['access_token'];
      // final userId = response.data['user']['id'];
      print('Access token: $accessToken');
      if ((response.data['status'] == "success") && accessToken != null) {
        await _apiService.saveToken(accessToken);
        final profile = await retrieveProfile();
        final userId = profile?['id'];
        await _apiService.saveUserId(userId);
        loadProfile(); // Load profile after successful verification
        // await _apiService.saveIsVerified(true);
        // _isVerified = true;
        await _fcmTokenService.registerTokenWithBackend();
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

  Future<bool> changePassword({
    required String oldPassword,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/changePassword',
        data: {
          'oldPassword': oldPassword,
          'password': password,
        },
      );
      print('Change password response: ${response.data}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  Future<bool> updateLocation({
    required double lat,
    required double lng,
    required String location,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/updateLocation',
        data: {
          'lat': lat,
          'lng': lng,
          'location': location,
        },
      );
      print('Update location response: ${response.data}');
      await loadProfile();
      await checkProfileSetupComplete();
      notifyListeners();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Update location error: $e');
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

  /// Sign in with Apple using Firebase Auth
  Future<UserCredential?> signInWithApple() async {
    try {
      if (!Platform.isIOS) {
        throw Exception('Apple Sign-In is only available on iOS');
      }
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      _isAuthenticated = true;
      await _fcmTokenService.registerTokenWithBackend();
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Apple sign-in error: $e');
      return null;
    }
  }

  Future<bool> oAuthLoginWithGoogle({
    required String idToken,
    String? email,
    String? fullname,
    String? username,
    String? phone,
    String? image,
    String? gender,
  }) async {
    try {
      // If only idToken is provided, treat as login. If any profile field is provided, treat as register.
      final Map<String, dynamic> data = {"accessToken": idToken};
      if ((email?.isNotEmpty ?? false) || (fullname?.isNotEmpty ?? false) || (username?.isNotEmpty ?? false) || (phone?.isNotEmpty ?? false) || (image?.isNotEmpty ?? false) || (gender?.isNotEmpty ?? false)) {
        if (email != null) data["email"] = email;
        if (fullname != null) data["fullname"] = fullname;
        if (username != null) data["username"] = username;
        if (phone != null) data["phone"] = phone;
        if (image != null) data["image"] = image;
        if (gender != null) data["gender"] = gender;
      }
      final response = await _apiService.post(
        '/auth/oauthLogin',
        data: data,
      );
      print('OAuth login response: ${response.data}');
      final accessToken = response.data['token']?['access_token'];
      if (accessToken != null) {
        await _apiService.saveToken(accessToken);
        final profile = await retrieveProfile();
        final userId = profile?['id'];
        await _apiService.saveUserId(userId);
        loadProfile();
        notifyListeners();
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('OAuth login error: $e');
      return false;
    }
  }

  Future<bool> oAuthLoginWithApple({
    required String idToken,
    String? email,
    String? fullname,
    String? username,
    String? phone,
    String? image,
    String? gender,
  }) async {
    try {
      final Map<String, dynamic> data = {"accessToken": idToken};
      if ((email?.isNotEmpty ?? false) || (fullname?.isNotEmpty ?? false) || (username?.isNotEmpty ?? false) || (phone?.isNotEmpty ?? false) || (image?.isNotEmpty ?? false) || (gender?.isNotEmpty ?? false)) {
        if (email != null) data["email"] = email;
        if (fullname != null) data["fullname"] = fullname;
        if (username != null) data["username"] = username;
        if (phone != null) data["phone"] = phone;
        if (image != null) data["image"] = image;
        if (gender != null) data["gender"] = gender;
      }
      final response = await _apiService.post(
        '/auth/oauthLogin',
        data: data,
      );
      print('OAuth Apple login response: ${response.data}');
      final accessToken = response.data['token']?['access_token'];
      if (accessToken != null) {
        await _apiService.saveToken(accessToken);
        final profile = await retrieveProfile();
        final userId = profile?['id'];
        await _apiService.saveUserId(userId);
        loadProfile();
        notifyListeners();
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('OAuth Apple login error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getSearchHistory({String? searchType}) async {
    try {
      String url = '/auth/getSearchHistory';
      if (searchType != null) {
        url += '?searchType=$searchType';
      }
      final response = await _apiService.get(url);
      print('Search history response: ${response.data}');
      final data = response.data as List<dynamic>? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('getSearchHistory error: $e');
      return [];
    }
  }

  /// Manual Google OAuth sign-in using flutter_web_auth_2
  Future<UserCredential?> signInWithGoogleManual() async {
    print("manual oauth logging in");
    try {
      // Get client ID and redirect URI from Firebase config
      final clientId = '768960251163-li2pr1fq362kot2cl3i2f337daiio7us.apps.googleusercontent.com';
      final redirectUri = 'com.app.kliks:/';
      final url =
          'https://accounts.google.com/o/oauth2/v2/auth'
          '?client_id=$clientId'
          '&redirect_uri=$redirectUri'
          '&response_type=code'
          '&scope=openid%20email%20profile';

      // Start the authentication flow
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'com.app.kliks',
      );

      // Extract the code from the resulting url
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception('No code returned from Google OAuth');

      // Exchange the code for tokens
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
          'code': code,
        },
      );
      final body = json.decode(response.body);
      final idToken = body['id_token'];
      final accessToken = body['access_token'];
      if (idToken == null || accessToken == null) throw Exception('Failed to get tokens from Google');

      // Sign in to Firebase with the Google credentials
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      _isAuthenticated = true;
      await _fcmTokenService.registerTokenWithBackend();
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Manual Google sign-in error: $e');
      return null;
    }
  }
}
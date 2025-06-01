import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/models/privacy_settings.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class PrivacyService {
  final ApiService _apiService;
  final AuthProvider _authProvider;
  PrivacyService(this._apiService, this._authProvider);

  Future<PrivacySettings> fetchSettings() async {
    await _authProvider.loadProfile();
    final profile = _authProvider.profile;
    printWrapped('Profile: $profile');
    return PrivacySettings.fromJson({
      'isPrivateAccount': profile?['isPrivateAccount'] ?? false,
      'showFollowers': profile?['showFollowers'] ?? true,
      'allowFollowing': profile?['allowFollowing'] ?? true,
      'isActive': profile?['isActive'] ?? true,
    });
  }

  Future<bool> updateSettings(PrivacySettings settings) async {
    try {
      final response = await _apiService.post('/auth/updatePrivacySettings', data: settings.toJson());
      printWrapped('Update settings response: ${response.data}');
      return true;
    } catch (e, stack) {
      printWrapped('Error updating privacy settings:\nError: $e\nStack: $stack');
      return false;
    }
  }
} 
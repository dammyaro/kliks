import 'package:flutter/material.dart';
import 'package:kliks/core/models/privacy_settings.dart';
import 'package:kliks/core/services/privacy_service.dart';
import 'package:kliks/core/debug/printWrapped.dart';

class PrivacyProvider with ChangeNotifier {
  final PrivacyService _privacyService;
  PrivacySettings? _settings;

  PrivacyProvider(this._privacyService);

  PrivacySettings? get settings => _settings;

  Future<void> loadSettings() async {
    _settings = await _privacyService.fetchSettings();
    printWrapped('Settings: ${_settings}');
    notifyListeners();
  }

  Future<void> updateSettings(PrivacySettings newSettings) async {
    final response = await _privacyService.updateSettings(newSettings);
     print('Update profile response: ${response}');
    
    if (response) {
      _settings = newSettings;
      notifyListeners();
    }
  }
} 
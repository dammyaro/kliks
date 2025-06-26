import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckedInEventsProvider with ChangeNotifier {
  static const String _prefsKey = 'checked_in_events';
  final Set<String> _checkedInEventIds = {};
  late SharedPreferences _prefs;

  CheckedInEventsProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final checkedIn = _prefs.getStringList(_prefsKey);
    if (checkedIn != null) {
      _checkedInEventIds.addAll(checkedIn);
    }
    notifyListeners();
  }

  bool isCheckedIn(String eventId) => _checkedInEventIds.contains(eventId);

  Future<void> addCheckedInEvent(String eventId) async {
    _checkedInEventIds.add(eventId);
    await _prefs.setStringList(_prefsKey, _checkedInEventIds.toList());
    notifyListeners();
  }

  Future<void> removeCheckedInEvent(String eventId) async {
    _checkedInEventIds.remove(eventId);
    await _prefs.setStringList(_prefsKey, _checkedInEventIds.toList());
    notifyListeners();
  }

  List<String> getCheckedInEventIds() => _checkedInEventIds.toList();
} 
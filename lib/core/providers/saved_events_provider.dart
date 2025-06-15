import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedEventsProvider with ChangeNotifier {
  final Set<String> _savedEventIds = {};
  static const String _prefsKey = 'saved_events';
  late SharedPreferences _prefs;

  SavedEventsProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedEvents = _prefs.getStringList(_prefsKey);
    if (savedEvents != null) {
      _savedEventIds.addAll(savedEvents);
    }
    notifyListeners();
  }

  bool isEventSaved(String eventId) {
    return _savedEventIds.contains(eventId);
  }

  Future<void> toggleSaveEvent(String eventId, Map<String, dynamic> eventData) async {
    if (_savedEventIds.contains(eventId)) {
      _savedEventIds.remove(eventId);
    } else {
      _savedEventIds.add(eventId);
    }
    await _prefs.setStringList(_prefsKey, _savedEventIds.toList());
    notifyListeners();
  }

  List<String> getSavedEventIds() {
    return _savedEventIds.toList();
  }

  Future<void> clearSavedEvents() async {
    _savedEventIds.clear();
    await _prefs.setStringList(_prefsKey, []);
    notifyListeners();
  }
} 
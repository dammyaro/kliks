import 'package:shared_preferences/shared_preferences.dart';

class TimeLockService {
  static const _prefix = 'time_lock_';

  Future<void> recordTimestamp(String feature) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$feature';
    await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }

  Future<int?> _getTimestamp(String feature) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$feature';
    return prefs.getInt(key);
  }

  Future<bool> canPerformAction(String feature, Duration duration) async {
    final timestamp = await _getTimestamp(feature);
    if (timestamp == null) {
      return true;
    }
    final lastChangeDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(lastChangeDate) > duration;
  }

  Future<Duration> getRemainingTime(String feature, Duration duration) async {
    final timestamp = await _getTimestamp(feature);
    if (timestamp == null) {
      return Duration.zero;
    }
    final lastChangeDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final nextChangeDate = lastChangeDate.add(duration);
    final now = DateTime.now();
    final remaining = nextChangeDate.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

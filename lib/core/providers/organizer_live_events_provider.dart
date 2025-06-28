import 'package:flutter/foundation.dart';

class OrganizerLiveEventsProvider with ChangeNotifier {
  List<String> _liveEventIds = [];

  List<String> get liveEventIds => _liveEventIds;

  void updateLiveEvents(List<dynamic> allEvents, String currentUserId) {
    final now = DateTime.now();
    _liveEventIds = allEvents.where((event) {
      // print('live events $allEvents');
      // final ownerId = event?['ownerDocument']?['id']?.toString();
      final ownerId = event?['userId']?.toString();
      // print('live events $ownerId $currentUserId');
      if (ownerId != currentUserId) {
        return false;
      }

      final startDateRaw = event?['startDate'] ?? '';
      final endDateRaw = event?['endDate'] ?? '';

      if (startDateRaw.isEmpty || endDateRaw.isEmpty) {
        return false;
      }

      try {
        final startDateTime = DateTime.parse(startDateRaw);
        final endDateTime = DateTime.parse(endDateRaw);
        return now.isAfter(startDateTime) && now.isBefore(endDateTime);
      } catch (_) {
        return false;
      }
    }).map((event) => event['id'].toString()).toList();
    // print('live events $liveEventIds');

    notifyListeners();
  }
}

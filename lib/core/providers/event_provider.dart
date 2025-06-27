import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class EventProvider with ChangeNotifier {
  final ApiService _apiService;

  EventProvider({ApiService? apiService})
    : _apiService = apiService ?? locator<ApiService>();

  Future<List<dynamic>> getEvents({
    String? userId,
    bool? isDeleted,
    bool? isLive,
    bool? isRecentlyViewed,
    bool? isReported,
    String? search,
    String? location,
    String? category,
    String? dateMin,
    String? dateMax,
    num? numberAttendesLimit,
    num? ageLimitMin,
    num? ageLimitMax,
    num? age,
    bool? isRequirePoints,
    bool? isUpcoming,
    bool? isPastEvent,
    num? radiusMin,
    num? radiusMax,
    bool? isNearBy,
    String? sortBy,
    String? sortOrder,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> params = {
        if (userId != null) 'userId': userId,
        if (isDeleted != null) 'isDeleted': isDeleted,
        if (isLive != null) 'isLive': isLive,
        if (isRecentlyViewed != null) 'isRecentlyViewed': isRecentlyViewed,
        if (isReported != null) 'isReported': isReported,
        if (search != null) 'search': search,
        if (location != null) 'location': location,
        if (category != null) 'category': category,
        if (dateMin != null) 'dateMin': dateMin,
        if (dateMax != null) 'dateMax': dateMax,
        if (numberAttendesLimit != null)
          'numberAttendesLimit': numberAttendesLimit,
        if (ageLimitMin != null) 'ageLimitMin': ageLimitMin,
        if (ageLimitMax != null) 'ageLimitMax': ageLimitMax,
        if (age != null) 'age': age,
        if (isRequirePoints != null) 'isRequirePoints': isRequirePoints,
        if (isUpcoming != null) 'isUpcoming': isUpcoming,
        if (isPastEvent != null) 'isPastEvent': isPastEvent,
        if (radiusMin != null) 'radiusMin': radiusMin,
        if (radiusMax != null) 'radiusMax': radiusMax,
        if (isNearBy != null) 'isNearBy': isNearBy,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        'limit': limit,
        'offset': offset,
      };
      final uri = Uri(
        queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
      );
      final url =
          '/event/getEvents${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getAllCategory() async {
    try {
      final response = await _apiService.get('/event/getAllCategory');
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getEventDetailById(String eventId) async {
    try {
      final response = await _apiService.get(
        '/event/getEventDetail?eventId=$eventId',
      );
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required String category,
    required int numberAttendesLimit,
    int? ageLimitMin,
    int? ageLimitMax,
    required String whoCanAttend,
    required String startDate,
    required String endDate,
    required String bannerImageUrl,
    required List<String> otherImageUrl,
    double? lat,
    double? lng,
    required String location,
    required bool isRequirePoints,
    required int attendEventPoint,
  }) async {
    try {
      final response = await _apiService.post(
        '/event/createEvent',
        data: {
          'title': title,
          'description': description,
          'category': category,
          'numberAttendesLimit': numberAttendesLimit,
          'ageLimitMin': ageLimitMin,
          'ageLimitMax': ageLimitMax,
          'whoCanAttend': whoCanAttend,
          'startDate': startDate,
          'endDate': endDate,
          'bannerImageUrl': bannerImageUrl,
          'otherImageUrl': otherImageUrl,
          'lat': lat,
          'lng': lng,
          'location': location,
          'isRequirePoints': isRequirePoints,
          'attendEventPoint': attendEventPoint,
        },
      );
      notifyListeners();
      // print('Create event response: \${response.data}');
    } catch (e) {
      // print('createEvent error: $e');
    }
  }

  Future<bool> attendEvent(String eventId) async {
    try {
      final response = await _apiService.post(
        '/event/attendEvent',
        data: {'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('attendEvent error: $e');
      return false;
    }
  }

  Future<bool> cancelAttend(String eventId) async {
    try {
      final response = await _apiService.post(
        '/event/attendEventCancel',
        data: {'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('cancelAttend error: $e');
      return false;
    }
  }

  Future<bool> inviteGuestsToEvent({
    required String userId,
    required String eventId,
  }) async {
    try {
      final response = await _apiService.post(
        '/event/eventInvite',
        data: {'userId': userId, 'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('inviteGuestsToEvent error: $e');
      return false;
    }
  }

  Future<List<dynamic>> getMyEvents({
    bool? isDeleted,
    bool? isLive,
    String? category,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> params = {
        if (isDeleted != null) 'isDeleted': isDeleted.toString(),
        if (isLive != null) 'isLive': isLive.toString(),
        if (category != null) 'category': category,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      final uri = Uri(queryParameters: params);
      final url =
          '/event/getMyEvents${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      // print('getMyEvents error: $e');
      return [];
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    try {
      final response = await _apiService.post(
        '/event/deleteEvent',
        data: {'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('deleteEvent error: $e');
      return false;
    }
  }

  Future<List<dynamic>> getInvitedEvents({
    int limit = 10,
    int offset = 0,
    String? category,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (category != null) 'category': category,
      };
      final uri = Uri(queryParameters: params);
      final url =
          '/event/getInvitedEvents${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      // print('getInvitedEvents error: $e');
      return [];
    }
  }

  Future<bool> inviteToEvent({
    required String userId,
    required String eventId,
  }) async {
    try {
      final response = await _apiService.post(
        '/event/eventInvite',
        data: {'userId': userId, 'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      printWrapped('Invite to event response: \${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('inviteToEvent error: $e');
      return false;
    }
  }

  Future<bool> acceptEventInvite({
    required String userId,
    required String inviteCode,
  }) async {
    try {
      final params = {'userId': userId, 'inviteCode': inviteCode};
      final uri = Uri(queryParameters: params);
      final url =
          '/event/acceptEventInvite${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('acceptEventInvite error: $e');
      return false;
    }
  }

  Future<bool> rejectEventInvite({
    required String userId,
    required String inviteCode,
  }) async {
    try {
      final params = {'userId': userId, 'inviteCode': inviteCode};
      final uri = Uri(queryParameters: params);
      final url =
          '/event/rejectEventInvite${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('rejectEventInvite error: $e');
      return false;
    }
  }

  Future<bool> createAnnouncement({
    required String eventId,
    required String announcement,
    String description = '',
    String? startDate,
    String? endDate,
    double? lat,
    double? lng,
    String location = '',
  }) async {
    try {
      final response = await _apiService.post(
        '/announcement/createAnnouncemnet',
        data: {
          'eventId': eventId,
          'announcement': announcement,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
          'lat': null,
          'lng': null,
          'location': location,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201)
        notifyListeners();
      printWrapped('Create announcement response: \${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      printWrapped('Create announcement error: $e');
      return false;
    }
  }

  Future<bool> reportEvent({
    required String eventId,
    required String reportType,
    String description = '',
  }) async {
    try {
      final response = await _apiService.post(
        '/event/reportEvent',
        data: {
          'eventId': eventId,
          'reportType': reportType,
          'description': description,
        },
      );
      printWrapped('Report event response: \${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('reportEvent error: $e');
      return false;
    }
  }

  Future<bool> checkIn({
    required String eventId,
  }) async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String location = 'Unknown';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          location = '${p.locality}, ${p.administrativeArea}, ${p.country}';
        }
      } catch (e) {
        // Handle geocoding error
      }

      final data = {
        'eventId': eventId,
        // 'checkInLat': position.latitude,
        // 'checkInLng': position.longitude,
        'checkInLat': 6.57305069013410, // sample lat for testing
        'checkInLng': 3.255696922615639, // sample lng for testing
        'checkInLocation': location,
      };

      print('Checking in with data: $data');

      final response = await _apiService.post(
        '/event/checkInEvent',
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('checkIn error: $e');
      return false;
    }
  }

  Future<bool> checkOut({
    required String eventId,
  }) async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String location = 'Unknown';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          location = '${p.locality}, ${p.administrativeArea}, ${p.country}';
        }
      } catch (e) {
        // Handle geocoding error
      }

      final data = {
        'eventId': eventId,
        // 'checkOutLat': position.latitude,
        // 'checkOutLng': position.longitude,
        'checkOutLat': 6.57305069013410, // sample lat for testing
        'checkOutLng': 3.255696922615639, // sample lng for testing
        'checkOutLocation': location,
      };
      print('Checking out with data: $data');

      final response = await _apiService.post(
        '/event/checkOutEvent',
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('checkOut error: $e');
      return false;
    }
  }

  Future<List<dynamic>> getAttendingEvents({
    String? otherUserId,
    String? category,
    int limit = 10,
    int offset = 0,
    bool? isUpcoming,
    bool? isPastEvent,
    bool? isOngoing,
    String? dateMin,
    String? dateMax,
  }) async {
    try {
      final Map<String, dynamic> params = {
        if (otherUserId != null) 'otherUserId': otherUserId,
        if (category != null) 'category': category,
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (isUpcoming != null) 'isUpcoming': isUpcoming.toString(),
        if (isPastEvent != null) 'isPastEvent': isPastEvent.toString(),
        if (isOngoing != null) 'isOngoing': isOngoing.toString(),
        if (dateMin != null) 'dateMin': dateMin,
        if (dateMax != null) 'dateMax': dateMax,
      };
      final uri = Uri(queryParameters: params);
      final url =
          '/event/getAttendingEvents${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }
}
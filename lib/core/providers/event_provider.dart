import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class EventProvider with ChangeNotifier {
  final ApiService _apiService;

  EventProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

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
      // print('Create event response: \\${response.data}');
    } catch (e) {
      // print('createEvent error: $e');
    }
  }

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
        if (numberAttendesLimit != null) 'numberAttendesLimit': numberAttendesLimit,
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
      final uri = Uri(queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
      final url = '/event/getEvents${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      final response = await _apiService.get(url);
      // printWrapped('Get events response: \\${response.data}');
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      // print('getEvents error: $e');
      return [];
    }
  }

  Future<List<dynamic>> getAllCategory() async {
    try {
      final response = await _apiService.get('/event/getAllCategory');
      // printWrapped('Get all category response: \\${response.data}');
      return response.data as List<dynamic>? ?? [];
    } catch (e) {
      // print('getAllCategory error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getEventDetailById(String eventId) async {
    try {
      final response = await _apiService.get('/event/getEventDetail?eventId=$eventId');
      printWrapped('Get event detail response: \\${response.data}');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      // print('getEventDetailById error: $e');
      return null;
    }
  }

  Future<bool> attendEvent(String eventId) async {
    try {
      final response = await _apiService.post(
        '/event/attendEvent',
        data: {'eventId': eventId},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('attendEvent error: $e');
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
        data: {
          'userId': userId,
          'eventId': eventId,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('inviteGuestsToEvent error: $e');
      return false;
    }
  }
} 
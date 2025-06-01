import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';

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
      print('Create event response: \\${response.data}');
    } catch (e) {
      print('createEvent error: $e');
    }
  }
} 
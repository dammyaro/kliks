import 'package:flutter/material.dart';
import 'package:kliks/core/services/api_service.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:kliks/core/utils/print_wrapped.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService _apiService;

  TransactionProvider({ApiService? apiService})
      : _apiService = apiService ?? locator<ApiService>();

  Future<List<dynamic>> getMyTransactions({
    String? typeFilter,
    String? dateMin,
    String? dateMax,
    num? pointsMin,
    num? pointsMax,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> params = {
        if (typeFilter != null) 'typeFilter': typeFilter,
        if (dateMin != null) 'dateMin': dateMin,
        if (dateMax != null) 'dateMax': dateMax,
        if (pointsMin != null) 'pointsMin': pointsMin.toString(),
        if (pointsMax != null) 'pointsMax': pointsMax.toString(),
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      final uri = Uri(queryParameters: params);
      final url = '/transaction/getMyTransactions${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
      
      final response = await _apiService.get(url);
      printWrapped('Transactions: ${response.data}');
      if (response.data is List) {
        return response.data as List;
      } else if (response.data is Map && response.data['data'] is List) {
        return response.data['data'] as List;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
  }
} 
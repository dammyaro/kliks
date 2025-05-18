import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';
import 'package:dio/dio.dart';

void main() {
  group('ApiService', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('should return data on successful get', () async {
      when(mockApiService.get('/test')).thenAnswer(
        (_) async => Response(
          data: {'result': 'ok'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final response = await mockApiService.get('/test');
      expect(response.data['result'], 'ok');
    });

    test('should return data on successful post', () async {
      when(mockApiService.post('/test', data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final response = await mockApiService.post('/test', data: {'foo': 'bar'});
      expect(response.data['success'], true);
    });
  });
}
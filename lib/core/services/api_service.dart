// filepath: /Users/mac/Documents/kliks/lib/core/services/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/io.dart';
// import 'dart:developer';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://167.71.142.132',
      connectTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 10000),
    ),
  );

  final _secureStorage = const FlutterSecureStorage();

  ApiService() {
    // Allow self-signed certificates (development only)
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = token;
          // print('Interceptor added header: Bearer $token');
        } else {
          print('Interceptor: No token found');
        }
        // print('Request headers: ${options.headers}');
        return handler.next(options);
      },
    ));
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(endpoint, queryParameters: params);
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

  Future<Response> postAuth(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      print(data);
      print(endpoint);
      final token = await _secureStorage.read(key: 'auth_token');
      options = Options(
        headers: token != null ? {'Authorization': token} : null,
      );
      if (token != null){
        printWrapped(token);
      }
      printWrapped(options.headers.toString());
      return await _dio.post(endpoint, data: data, options: options);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: 'userId', value: userId);
  }

  Future<void> clearUserId() async {
    await _secureStorage.delete(key: 'userId');
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'userId');
  }

  // Future<void> saveIsVerified(bool isVerified) async {
  //   await _secureStorage.write(key: 'is_verified', value: isVerified ? 'true' : 'false');
  // }

  //  Future<bool> getIsVerified() async {
  //   final value = await _secureStorage.read(key: 'is_verified');
  //   return value == 'true';
  // }

  // Future<void> clearIsVerified() async {
  //   await _secureStorage.delete(key: 'is_verified');
  // }

  }


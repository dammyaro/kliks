import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MediaService {
  late final Dio _dio;

  MediaService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      ),
    );

    // Allow self-signed certificates (for development)
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // Add token interceptor
    final secureStorage = const FlutterSecureStorage();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
    ));
  }

  // Uploads a file and returns the file name or URL
  Future<String?> uploadProfilePicture({
    required File file,
    required String folderName,
  }) async {
    final String url = 'https://167.71.142.132/media-upload/mediaFiles/$folderName';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });

    try {
      final response = await _dio.post(url, data: formData);
      // Adjust this based on your API's response
      return response.data['fileName'] ?? response.data['url'];
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Returns the full URL to retrieve the profile picture
  String getProfilePictureUrl({
    required String folderName,
    required String fileName,
  }) {
    return 'https://167.71.142.132/media-upload/mediaFiles/$folderName/$fileName';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'mocks.mocks.dart';
import 'package:dio/dio.dart';

void main() {
  group('AuthProvider', () {
    late MockApiService mockApiService;
    late AuthProvider authProvider;

    setUp(() {
      mockApiService = MockApiService();
      authProvider = AuthProvider(apiService: mockApiService);
    });

    test('register returns true on success', () async {
      when(mockApiService.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {
            'user': {'id': '123'}
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/signup'),
        ),
      );
      when(mockApiService.saveToken(any)).thenAnswer((_) async => {});

      final result = await authProvider.register(
        email: 'test@test.com',
        password: 'password',
        referralCode: '',
        gender: '',
        dob: null,
      );
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
    });

    test('login returns true on success', () async {
      when(mockApiService.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {
            'user': {'id': '123'}
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );
      when(mockApiService.saveToken(any)).thenAnswer((_) async => {});

      final result = await authProvider.login(
        email: 'test@test.com',
        password: 'password',
      );
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
    });

    test('verifyEmail returns true on success', () async {
      when(mockApiService.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/verify'),
        ),
      );

      final result = await authProvider.verifyEmail(
        email: 'test@test.com',
        otp: '123456',
      );
      expect(result, true);
    });

    test('resendOtp returns true on success', () async {
      when(mockApiService.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/resendOtp'),
              ));

      final result = await authProvider.resendOtp(email: 'test@test.com');
      expect(result, true);
    });

    test('logout resets auth state', () async {
      when(mockApiService.clearToken()).thenAnswer((_) async => {});

      authProvider.setCurrentEmail('test@test.com');
      // Set authentication state using a public method or by calling checkAuthStatus if available
      // For testing, you may need to mock getToken/getIsVerified or add a test-only setter in AuthProvider
      when(mockApiService.getToken()).thenAnswer((_) async => 'token');
      await authProvider.checkAuthStatus();

      await authProvider.logout();

      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentEmail, 'test@test.com'); // currentEmail is not cleared in logout
    });

    test('checkAuthStatus sets auth state', () async {
      when(mockApiService.getToken()).thenAnswer((_) async => 'token');

      await authProvider.checkAuthStatus();

      expect(authProvider.isAuthenticated, true);
    });

    test('setCurrentEmail sets the email', () {
      authProvider.setCurrentEmail('test@test.com');
      expect(authProvider.currentEmail, 'test@test.com');
    });

    test('getDeviceInfoString returns a string', () async {
      // This test is just to check the method runs, not the actual device info
      final info = await authProvider.getDeviceInfoString();
      expect(info, isA<String>());
    });
  });
}
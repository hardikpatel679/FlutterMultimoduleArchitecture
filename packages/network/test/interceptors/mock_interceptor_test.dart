import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:network/interceptors/mock_interceptor.dart';
import 'package:flutter/services.dart';

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class FakeResponse extends Fake implements Response {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeResponse());
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('MockInterceptor', () {
    late MockInterceptor interceptor;
    late MockRequestInterceptorHandler handler;
    final mockMappings = {'/login': 'assets/mock/login.json'};

    setUp(() {
      interceptor = MockInterceptor(mockMappings: mockMappings);
      handler = MockRequestInterceptorHandler();
    });

    test('onRequest should resolve with mock data when path matches', () async {
      // Arrange
      const tJson = '{"id": 1, "username": "mock"}';
      
      // Asset loading uses raw messages on the 'flutter/assets' channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.view(Uint8List.fromList(utf8.encode(tJson)).buffer);
      });

      final options = RequestOptions(path: '/login');

      // Act
      interceptor.onRequest(options, handler);
      
      // Wait for internal async operations
      await Future.delayed(const Duration(milliseconds: 1200));

      // Assert
      verify(() => handler.resolve(any(that: isA<Response>()))).called(1);
    });

    test('onRequest should call next when path does not match', () async {
      // Arrange
      final options = RequestOptions(path: '/real-api');

      // Act
      interceptor.onRequest(options, handler);

      // Assert
      verify(() => handler.next(options)).called(1);
    });

    test('onRequest should reject when asset loading fails', () async {
      // Arrange
      // Simulate failure by throwing in the mock handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        throw Exception('Asset Load Failure');
      });

      final options = RequestOptions(path: '/login');

      // Act
      interceptor.onRequest(options, handler);
      
      // Wait for async operations and catch block
      await Future.delayed(const Duration(milliseconds: 1200));

      // Assert
      verify(() => handler.reject(any(that: isA<DioException>()))).called(1);
    });
  });
}

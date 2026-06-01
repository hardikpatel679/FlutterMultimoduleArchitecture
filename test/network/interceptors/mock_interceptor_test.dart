import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:network/interceptors/mock_interceptor.dart';
import 'package:flutter/services.dart';

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (message) async {
        return ByteData.view(Uint8List.fromList(utf8.encode(tJson)).buffer);
      });

      final options = RequestOptions(path: '/login');

      // Act
      interceptor.onRequest(options, handler);
      // Since it has an async delay internally but returns void, we might need a small delay here 
      // or use a Completer in the mock handler to wait for the resolve call.
      await Future.delayed(const Duration(milliseconds: 1000));

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
  });
}

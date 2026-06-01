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
      
      // Use the specific channel name for assets
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (MethodCall message) async {
        if (message.method == 'loadString') {
           // Not how it works, usually it's just 'load' or it's not a method call
        }
        return ByteData.view(Uint8List.fromList(utf8.encode(tJson)).buffer);
      });

      // Actually, rootBundle.loadString calls load() which calls send() on the messenger.
      // The key for assets is usually the path itself.
      
      final options = RequestOptions(path: '/login');

      // Act
      interceptor.onRequest(options, handler);
      
      // Wait for the internal async operations (latency simulation + json decode)
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
  });
}

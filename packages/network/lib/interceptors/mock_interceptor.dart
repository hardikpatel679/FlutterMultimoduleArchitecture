import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class MockInterceptor extends Interceptor {
  final Map<String, String> mockMappings;

  MockInterceptor({required this.mockMappings});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // We check for the path in our mapping
    final assetPath = mockMappings[options.path];

    if (assetPath != null) {
      developer.log('Stubbing Request: [${options.method}] ${options.path}', name: 'MockInterceptor');
      developer.log('Using Mock File: $assetPath', name: 'MockInterceptor');

      try {
        // Simulate network latency
        await Future.delayed(const Duration(milliseconds: 800));

        // Load and decode JSON
        final jsonString = await rootBundle.loadString(assetPath);
        final data = jsonDecode(jsonString);

        return handler.resolve(
          Response(
            requestOptions: options,
            data: data,
            statusCode: 200,
            statusMessage: 'OK (Mocked)',
          ),
        );
      } catch (e) {
        developer.log('Mock Error: $e', name: 'MockInterceptor', error: e);
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Failed to load mock asset: $assetPath',
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    // No mock found, proceed to real network
    super.onRequest(options, handler);
  }
}

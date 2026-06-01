import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:network/data/datasources/base_remote_data_source.dart';
import 'package:core/errors/app_exceptions.dart';

class MockDio extends Mock implements Dio {}
class TestDataSource extends BaseRemoteDataSource {
  TestDataSource({required super.dio});
}

void main() {
  group('BaseRemoteDataSource', () {
    late TestDataSource dataSource;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      dataSource = TestDataSource(dio: mockDio);
    });

    test('getRequest should return data on success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'key': 'value'},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataSource.getRequest('test');
      expect(result['key'], 'value');
    });

    test('postRequest should return data on success', () async {
      when(() => mockDio.post(any(), options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: 'success',
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataSource.postRequest('test', body: {});
      expect(result, 'success');
    });

    test('should throw UnauthorizedException on 401', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(statusCode: 401, requestOptions: RequestOptions(path: '')),
        type: DioExceptionType.badResponse,
      ));

      expect(() => dataSource.getRequest('test'), throwsA(isA<UnauthorizedException>()));
    });

    test('should throw NetworkException on timeout', () async {
      final types = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ];

      for (var type in types) {
        when(() => mockDio.get(any(), options: any(named: 'options')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: type,
        ));

        expect(() => dataSource.getRequest('test'), throwsA(isA<NetworkException>()));
      }
    });
    
    test('should throw UnknownException on cancel or other', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      ));

      expect(() => dataSource.getRequest('test'), throwsA(isA<UnknownException>()));
    });

    test('should throw NotFoundException on 404', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(statusCode: 404, requestOptions: RequestOptions(path: '')),
        type: DioExceptionType.badResponse,
      ));

      expect(() => dataSource.getRequest('test'), throwsA(isA<NotFoundException>()));
    });

    test('should handle generic exception in _performRequest', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(Exception('Generic Error'));

      expect(() => dataSource.getRequest('test'), throwsA(isA<UnknownException>()));
    });
  });
}

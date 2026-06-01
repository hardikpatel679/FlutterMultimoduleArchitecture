import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:network/data/datasources/impl/auth_remote_data_source_impl.dart';
import 'package:network/constants/api_endpoints.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  group('AuthRemoteDataSourceImpl', () {
    final tUserResponse = {
      'id': 1,
      'username': 'test',
      'email': 'test@test.com',
      'accessToken': 'token',
    };

    test('login should return UserDto on success', () async {
      // Arrange
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: tUserResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.login),
          ));

      // Act
      final result = await dataSource.login('user', 'pass');

      // Assert
      expect(result.id, 1);
      expect(result.username, 'test');
    });
  });
}

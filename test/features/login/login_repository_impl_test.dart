import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/data/datasources/auth_remote_data_source.dart';
import 'package:network/data/repositories/login_repository_impl.dart';
import 'package:network/data/dtos/user_dto.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late LoginRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = LoginRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final tUserDto = UserDto(
    id: 1,
    username: 'test',
    email: 'test@test.com',
    firstName: 'First',
    lastName: 'Last',
    gender: 'male',
    image: 'url',
    token: 'token',
  );

  test('login should return user entity when data source is successful', () async {
    // Arrange
    when(() => mockDataSource.login(any(), any())).thenAnswer((_) async => tUserDto);

    // Act
    final result = await repository.login('user', 'pass');

    // Assert
    expect(result.username, 'test');
    verify(() => mockDataSource.login('user', 'pass'));
  });
}

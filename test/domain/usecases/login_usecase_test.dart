import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:domain/repositories/login_repository.dart';
import 'package:domain/usecases/login_usecase.dart';
import 'package:domain/entities/user.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginUseCase useCase;
  late MockLoginRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  final tUser = User(
    id: 1,
    username: 'test',
    email: 'test@test.com',
    firstName: 'First',
    lastName: 'Last',
    gender: 'male',
    image: 'url',
    token: 'token',
  );

  test('execute should call repository and return user', () async {
    // Arrange
    when(() => mockRepository.login(any(), any())).thenAnswer((_) async => tUser);

    // Act
    final result = await useCase.execute('user', 'pass');

    // Assert
    expect(result, tUser);
    verify(() => mockRepository.login('user', 'pass'));
  });
}

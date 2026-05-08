import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth/login/login_viewmodel.dart';
import 'package:domain/usecases/login_usecase.dart';
import 'package:core/entities/user.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(loginUseCase: mockLoginUseCase);
  });

  final tUser = User(
    id: 1,
    username: 'emilys',
    email: 'emily@test.com',
    firstName: 'Emily',
    lastName: 'Smith',
    gender: 'female',
    image: 'https://dummyjson.com/image.png',
    token: 'token_123',
  );

  group('LoginViewModel', () {
    test('initial state should be correct', () {
      expect(viewModel.user, null);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('should set error message when username or password is empty', () async {
      // Act
      await viewModel.login();

      // Assert
      expect(viewModel.errorMessage, 'Please enter both username and password');
      expect(viewModel.isLoading, false);
      verifyNever(() => mockLoginUseCase.execute(any(), any()));
    });

    test('should call LoginUseCase and update user on success', () async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';
      
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenAnswer((_) async => tUser);

      // Act
      await viewModel.login();

      // Assert
      expect(viewModel.user, tUser);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      verify(() => mockLoginUseCase.execute('emilys', 'emilyspass')).called(1);
    });

    test('should handle exception and set user-friendly error message on failure', () async {
      // Arrange
      viewModel.usernameController.text = 'wrong';
      viewModel.passwordController.text = 'wrong';
      
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenThrow(Exception('Unauthorized'));

      // Act
      await viewModel.login();

      // Assert
      expect(viewModel.user, null);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isA<String>());
    });

    test('should notify listeners when state changes', () async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';
      when(() => mockLoginUseCase.execute(any(), any())).thenAnswer((_) async => tUser);

      int callCount = 0;
      viewModel.addListener(() => callCount++);

      // Act
      await viewModel.login();

      // Assert
      expect(callCount, greaterThan(0));
    });

    test('should reset errorMessage when starting a new login attempt', () async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';
      
      // First attempt fails
      when(() => mockLoginUseCase.execute(any(), any())).thenThrow(Exception('Fail'));
      await viewModel.login();
      expect(viewModel.errorMessage, isNotNull);

      // Second attempt starts
      when(() => mockLoginUseCase.execute(any(), any())).thenAnswer((_) async => tUser);
      
      // We don't await here to check the intermediate state if possible, 
      // but login() resets it immediately.
      final future = viewModel.login();
      expect(viewModel.errorMessage, null);
      expect(viewModel.isLoading, true);

      await future;
    });
  });
}

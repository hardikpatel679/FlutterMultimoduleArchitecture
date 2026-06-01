import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:domain/usecases/login_usecase.dart';
import '../../helpers/test_helper.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(loginUseCase: mockLoginUseCase);
  });

  final tUser = TestHelper.getUserFromMockJson();

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

    test('should handle exception and set error message on failure', () async {
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

    test('should toggle loading state during login_module process', () async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';
      
      when(() => mockLoginUseCase.execute(any(), any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 10));
        return tUser;
      });

      // Act
      final future = viewModel.login();

      // Assert
      expect(viewModel.isLoading, true);
      
      await future;
      
      expect(viewModel.isLoading, false);
    });

    test('should toggle password visibility', () {
      // Initial state
      expect(viewModel.isPasswordVisible, false);

      // Act
      viewModel.togglePasswordVisibility();

      // Assert
      expect(viewModel.isPasswordVisible, true);

      // Act again
      viewModel.togglePasswordVisibility();

      // Assert
      expect(viewModel.isPasswordVisible, false);
    });
  });
}

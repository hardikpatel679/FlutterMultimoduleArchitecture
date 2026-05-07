import 'package:auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/entities/user.dart';
import 'package:domain/usecases/login_usecase.dart';
import 'package:mockito/annotations.dart';
import 'login_view_model_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(loginUseCase: mockLoginUseCase);
  });

  // ✅ Helper method for User
  User createTestUser() {
    return User(
      id: 1,
      username: 'emilys',
      email: 'emily@test.com',
      firstName: 'Emily',
      lastName: 'Smith',
      gender: 'female',
      image: 'https://dummy.com/image.png',
      token: 'token_123',
    );
  }

  group('LoginViewModel Tests', () {

    // ✅ 1. Initial state
    test('Initial values should be correct', () {
      expect(viewModel.user, null);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    // ✅ 2. Successful login
    test('Successful login should update user and stop loading', () async {
      final mockUser = createTestUser();

      when(mockLoginUseCase.execute(any, any))
          .thenAnswer((_) async => mockUser);

      await viewModel.login('emilys', 'emilyspass');

      expect(viewModel.user, mockUser);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);

      // 🔥 Verify interaction
      verify(mockLoginUseCase.execute('emilys', 'emilyspass')).called(1);
    });

    // ✅ 3. Failed login
    test('Failed login should set error message and stop loading', () async {
      final exception = Exception('Invalid credentials');

      when(mockLoginUseCase.execute(any, any))
          .thenThrow(exception);

      await viewModel.login('emilys', 'wrongpass');

      expect(viewModel.user, null);
      expect(viewModel.isLoading, false);

      // ⚠️ Avoid strict match due to static ErrorHandler
      expect(viewModel.errorMessage, isNotNull);
    });

    // ✅ 4. Loading state
    test('Loading state should be true during login', () async {
      final mockUser = createTestUser();

      when(mockLoginUseCase.execute(any, any))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return mockUser;
      });

      final future = viewModel.login('emilys', 'emilyspass');

      expect(viewModel.isLoading, true);

      await future;

      expect(viewModel.isLoading, false);
    });

    // ✅ 5. notifyListeners verification
    test('notifyListeners should be called', () async {
      final mockUser = createTestUser();
      int callCount = 0;

      viewModel.addListener(() {
        callCount++;
      });

      when(mockLoginUseCase.execute(any, any))
          .thenAnswer((_) async => mockUser);

      await viewModel.login('emilys', 'emilyspass');

      expect(callCount >= 2, true); // start + end
    });

  });
}
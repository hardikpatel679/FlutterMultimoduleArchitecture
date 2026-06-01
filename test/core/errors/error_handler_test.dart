import 'package:flutter_test/flutter_test.dart';
import 'package:core/errors/error_handler.dart';
import 'package:core/errors/app_exceptions.dart';
import 'package:core/constants/app_strings.dart';

void main() {
  group('ErrorHandler', () {
    test('should return unauthorized error message', () {
      final result = ErrorHandler.getErrorMessage(UnauthorizedException());
      expect(result, AppStrings.errUnauthorized);
    });

    test('should return network error message', () {
      final result = ErrorHandler.getErrorMessage(NetworkException());
      expect(result, AppStrings.errNetwork);
    });

    test('should return server error message', () {
      final result = ErrorHandler.getErrorMessage(ServerException());
      expect(result, AppStrings.errServer);
    });

    test('should return not found error message', () {
      final result = ErrorHandler.getErrorMessage(NotFoundException());
      expect(result, AppStrings.errNotFound);
    });

    test('should return custom app exception message', () {
      const message = 'Custom error';
      final result = ErrorHandler.getErrorMessage(AppException(message));
      expect(result, message);
    });

    test('should return unexpected error message for unknown errors', () {
      final result = ErrorHandler.getErrorMessage('Some random error');
      expect(result, AppStrings.errUnexpected);
    });
    
    test('should handle TypeError', () {
      final typeError = TypeError();
      final result = ErrorHandler.getErrorMessage(typeError);
      expect(result.contains('Mapping error'), true);
    });
  });
}

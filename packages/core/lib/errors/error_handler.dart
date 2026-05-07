import 'app_exceptions.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is UnauthorizedException) {
      return 'Invalid username or password. Please try again.';
    } else if (error is NetworkException) {
      return 'No internet connection. Please check your settings.';
    } else if (error is ServerException) {
      return 'The server is currently unavailable. Please try later.';
    } else if (error is NotFoundException) {
      return 'The requested resource was not found.';
    } else if (error is AppException) {
      return error.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

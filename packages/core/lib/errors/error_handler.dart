import 'package:flutter/foundation.dart';
import 'app_exceptions.dart';
import 'dart:developer' as developer;

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (kDebugMode) {
      developer.log('Error caught by ErrorHandler: $error', name: 'ErrorHandler');
    }

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
    } else if (error is TypeError) {
      return 'Data mapping error: ${error.toString()}';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

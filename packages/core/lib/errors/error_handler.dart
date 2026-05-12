import 'package:flutter/foundation.dart';
import '../constants/app_strings.dart';
import '../utils/string_extensions.dart';
import 'app_exceptions.dart';
import 'dart:developer' as developer;

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (kDebugMode) {
      developer.log('Error caught by ErrorHandler: $error', name: 'ErrorHandler');
    }

    if (error is UnauthorizedException) {
      return AppStrings.errUnauthorized;
    } else if (error is NetworkException) {
      return AppStrings.errNetwork;
    } else if (error is ServerException) {
      return AppStrings.errServer;
    } else if (error is NotFoundException) {
      return AppStrings.errNotFound;
    } else if (error is AppException) {
      return error.message;
    } else if (error is TypeError) {
      return AppStrings.errMapping.format({'error': error.toString()});
    } else {
      return AppStrings.errUnexpected;
    }
  }
}

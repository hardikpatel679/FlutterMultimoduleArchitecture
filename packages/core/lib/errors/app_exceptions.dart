abstract class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = 'Something went wrong', this.prefix]);

  @override
  String toString() => '$prefix$message';
}

class ServerException extends AppException {
  ServerException([String message = 'Server Error']) : super(message, 'Error: ');
}

class NetworkException extends AppException {
  NetworkException([String message = 'No Internet Connection']) : super(message, 'Network: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized Access']) : super(message, 'Auth: ');
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Request Not Found']) : super(message, '404: ');
}

class UnknownException extends AppException {
  UnknownException([String message = 'An unexpected error occurred']) : super(message, 'Unexpected: ');
}

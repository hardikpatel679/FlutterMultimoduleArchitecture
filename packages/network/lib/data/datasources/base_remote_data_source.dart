import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:core/errors/app_exceptions.dart';

abstract class BaseRemoteDataSource {
  final Dio dio;

  BaseRemoteDataSource({required this.dio});

  Future<dynamic> getRequest(String url, {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    return _performRequest(
      () => dio.get(url, options: Options(headers: headers), queryParameters: queryParameters),
    );
  }

  Future<dynamic> postRequest(String url, {Map<String, String>? headers, dynamic body}) async {
    return _performRequest(
      () => dio.post(url, options: Options(headers: headers), data: body),
    );
  }

  Future<dynamic> putRequest(String url, {Map<String, String>? headers, dynamic body}) async {
    return _performRequest(
      () => dio.put(url, options: Options(headers: headers), data: body),
    );
  }

  Future<dynamic> patchRequest(String url, {Map<String, String>? headers, dynamic body}) async {
    return _performRequest(
      () => dio.patch(url, options: Options(headers: headers), data: body),
    );
  }

  Future<dynamic> deleteRequest(String url, {Map<String, String>? headers}) async {
    return _performRequest(
      () => dio.delete(url, options: Options(headers: headers)),
    );
  }

  Future<dynamic> _performRequest(Future<Response> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException();
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException();
        }
        return UnknownException(error.message ?? 'Unknown error');
      default:
        return UnknownException();
    }
  }

  AppException _handleResponseError(Response? response) {
    if (response == null) return UnknownException();
    
    switch (response.statusCode) {
      case 400:
      case 401:
      case 403:
        return UnauthorizedException();
      case 404:
        return NotFoundException();
      case 500:
        return ServerException();
      default:
        return UnknownException('Status Code: ${response.statusCode}');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class AuthException extends AppException {
  AuthException(super.message);
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('잘못된 이메일 형식입니다');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('사용자를 찾을 수 없습니다');
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('잘못된 비밀번호입니다');
}

class UnknownException extends AppException {
  const UnknownException() : super('알 수 없는 오류가 발생했습니다');
}

class ApiException extends AppException {
  final int code;
  ApiException({required this.code, required String message}) : super(message);
}

class BadRequestException extends ApiException {
  BadRequestException([String? message])
      : super(code: 400, message: message ?? '잘못된 요청입니다');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super(code: 401, message: '인증되지 않은 사용자입니다');
}

class NotFoundException extends ApiException {
  NotFoundException() : super(code: 404, message: '리소스를 찾을 수 없습니다');
}

class ConflictException extends ApiException {
  ConflictException() : super(code: 409, message: '중복된 요청입니다');
}

class ServerException extends ApiException {
  ServerException() : super(code: 500, message: '서버 오류가 발생했습니다');
}

class AppErrorHandler {
  static AppException handle(dynamic e) {
    if (e is FirebaseAuthException) {
      return _handleFirebaseError(e);
    }
    if (e is DioException) {
      return _handleDioError(e);
    }
    return const UnknownException();
  }

  static AuthException _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return WrongPasswordException();
      case 'invalid-email':
        return InvalidEmailException();
      default:
        return AuthException('인증 오류가 발생했습니다');
    }
  }

  static ApiException _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return BadRequestException();
      case 401:
        return UnauthorizedException();
      case 404:
        return NotFoundException();
      case 409:
        return ConflictException();
      case 500:
        return ServerException();
      default:
        return ApiException(code: 0, message: '알 수 없는 오류가 발생했습니다');
    }
  }
}

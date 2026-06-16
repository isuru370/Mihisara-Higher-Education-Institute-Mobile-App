import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ServerException extends AppException {
  final int statusCode;

  const ServerException(super.message, this.statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

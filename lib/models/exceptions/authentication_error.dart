import 'dart:io';

class AuthenticationError extends HttpException {
  AuthenticationError(String message) : super(message);
}
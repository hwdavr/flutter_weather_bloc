import 'package:dio/dio.dart';

class ResourceError {
  ErrorType type;
  String message;
  Response response;
}

enum ErrorType {
  ///It occurs when receiving timeout.
  TIMEOUT,

  /// When the server response, but with a incorrect status, such as 404, 503...
  RESPONSE,

  /// When the request is cancelled, dio will throw a error with this type.
  CANCEL,

  /// Default error type, Some other Error. In this case, you can
  /// read the DioError.error if it is not null.
  DEFAULT,
}

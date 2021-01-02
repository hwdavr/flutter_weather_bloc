import 'package:dio/dio.dart';
import 'package:weather_bloc/api/resource_error.dart';

class ErrorConverter {
  static ResourceError convertDioError(DioError error) {
    final result = ResourceError();
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        result.type = ErrorType.TIMEOUT;
        result.message = error.message;
        break;
      case DioErrorType.RESPONSE:
        result.type = ErrorType.RESPONSE;
        result.message = error.response.statusMessage;
        break;
      case DioErrorType.CANCEL:
        result.type = ErrorType.CANCEL;
        result.message = error.message;
        break;
      case DioErrorType.DEFAULT:
        result.type = ErrorType.DEFAULT;
        result.message = error.message;
        break;
    }
    result.response = error.response;
    return result;
  }

  static ResourceError convertError(Error error) {
    final result = ResourceError();
    result.type = ErrorType.DEFAULT;
    result.message = error.toString();
    return result;
  }
}

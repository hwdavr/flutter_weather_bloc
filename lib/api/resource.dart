import 'package:dio/dio.dart';
import 'package:weather_bloc/api/resource_error.dart';

class Resource<T> {
  ResourceError error;
  T data;

  Resource.success(this.data);

  Resource.error(this.error);
}

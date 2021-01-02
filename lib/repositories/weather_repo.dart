import 'package:dio/dio.dart';
import 'package:weather_bloc/api/error_converter.dart';
import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/models/local_weather.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/utils/contants.dart';
import 'package:weather_bloc/api/dio_provider.dart';

class WeatherRepository {
  final _dio = DioProvider.provide();

  Future<Resource<LocalWeather>> getWeather(query) async {
    try {
      Response response =
          await _dio.get("/v1/current.json?key=$WEATHER_API_KEY&q=$query");
      print("Reponse: ${response.data}");
      return Resource.success(LocalWeather.fromJson(response.data));
    } on DioError catch (error) {
      print("Exception occured: $error");
      return Resource.error(ErrorConverter.convertDioError(error));
    }
  }

  Future<Resource<List<SearchLocaltions>>> searchLocations(query) async {
    try {
      Response response =
          await _dio.get("/v1/search.json?key=$WEATHER_API_KEY&q=$query");
      print("Reponse: ${response.data}");
      return Resource.success(locationsFromJson(response.data));
    } on DioError catch (error) {
      print("Exception occured: $error");
      return Resource.error(ErrorConverter.convertDioError(error));
    }
  }
}

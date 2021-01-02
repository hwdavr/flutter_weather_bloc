import 'dart:async';

import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/bloc/bloc.dart';
import 'package:weather_bloc/models/local_weather.dart';
import 'package:weather_bloc/repositories/weather_repo.dart';

class WeatherBloc implements Bloc {
  final _repo = WeatherRepository();

  final _controller = StreamController<Resource<LocalWeather>>.broadcast();
  Stream<Resource<LocalWeather>> get weatherStream => _controller.stream;

  void getWeather(query) async {
    final response = await _repo.getWeather(query);
    _controller.sink.add(response);
  }

  @override
  void dispose() {
    _controller.close();
  }
}

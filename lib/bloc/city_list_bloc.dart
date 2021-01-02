import 'dart:async';

import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/bloc/bloc.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/repositories/weather_repo.dart';

class CityListBloc implements Bloc {
  final _weatherRepo = WeatherRepository();

  final _cityController = StreamController<List<SearchLocaltions>>.broadcast();
  // exposes a public getter to the StreamController’s stream.
  Stream<List<SearchLocaltions>> get cityStream => _cityController.stream;

  void queryCities(query) async {
    final response = await _weatherRepo.searchLocations(query);
    if (response is Resource<List<SearchLocaltions>>) {
      _cityController.sink.add(response.data);
    }
  }

  @override
  void dispose() {
    _cityController.close();
  }
}

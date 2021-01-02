import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/bloc/bloc.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/repositories/weather_repo.dart';

class CityListBloc implements Bloc {
  final _weatherRepo = WeatherRepository();

  final _citiesSuject = BehaviorSubject<String>();
  Stream<Resource<List<SearchLocaltions>>> get cityStream => _citiesSuject
          .debounceTime(Duration(milliseconds: 500))
          .switchMap((query) async* {
        print('searching: $query');
        yield await _weatherRepo.searchLocations(query);
      });

  void queryCities(String query) {
    if (query.length >= 3) {
      _citiesSuject.onAdd(query);
    }
  }

  @override
  void dispose() {
    _citiesSuject.close();
  }
}

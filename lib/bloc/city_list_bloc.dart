import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/bloc/bloc.dart';
import 'package:weather_bloc/models/city_model.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/repositories/weather_repo.dart';
import 'package:weather_bloc/utils/contants.dart';

class CityListBloc implements Bloc {
  final _weatherRepo = WeatherRepository();
  var listStyle = 0;

  final _searchSuject = BehaviorSubject<String>();
  Stream<Resource<List<SearchLocaltions>>> get searchStream => _searchSuject
          .debounceTime(Duration(milliseconds: 500))
          .switchMap((query) async* {
        print('searching: $query');
        yield await _weatherRepo.searchLocations(query);
      });

  final _storedSuject = BehaviorSubject<List<City>>();
  Stream<List<City>> get storedStream => _storedSuject.stream;

  void queryCities(String query) {
    if (query.length >= 3) {
      _searchSuject.add(query);
    }
  }

  upsetCity(City city) async {
    final box = await Hive.openBox<City>(HIVE_CITY_BOX);
    var index = 0;
    for (var element in box.values.toList()) {
      if (element.name == city.name) {
        break;
      }
      index++;
    }
    if (index < box.values.length) {
      await box.deleteAt(index);
    }
    await box.add(city);
    _storedSuject.sink.add(box.values.toList().reversed.toList());
  }

  getCities() async {
    final box = await Hive.openBox<City>(HIVE_CITY_BOX);
    _storedSuject.sink.add(box.values.toList().reversed.toList());
  }

  @override
  void dispose() {
    _searchSuject.close();
    _storedSuject.close();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/models/local_weather.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/repositories/weather_repo.dart';

void main() {
  test("test weather", () async {
    final repo = WeatherRepository();
    final response = await repo.getWeather("Singapore");
    expect(response is Resource<LocalWeather>, true);
    print(response.data.current.tempC);
    expect(response.data.current.tempC > 0, true);
    print(response.data.current.feelslikeC);
  });

  test("test search locations", () async {
    final repo = WeatherRepository();
    final response = await repo.searchLocations("Sin");
    expect(response is Resource<List<SearchLocaltions>>, true);
    print(response.data.length);
    expect(response.data.length > 0, true);
  });
}

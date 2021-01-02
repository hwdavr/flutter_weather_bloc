import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/models/local_weather.dart';
import 'package:weather_bloc/utils/error_handler.dart';

class WeatherScreen extends StatefulWidget {
  final String city;

  WeatherScreen({Key key, @required this.city}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherBloc = WeatherBloc();

  _buildWeatherUI(LocalWeather weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https:${weather.current.condition.icon}',
              width: 100, height: 100, fit: BoxFit.fitWidth),
          Text(weather.current.condition.text),
          SizedBox(height: 30),
          Text(
            '${weather.current.tempC.toString()} °C',
            style: TextStyle(fontSize: 42),
          ),
          Text('Humidity: ${weather.current.humidity.toString()}'),
          SizedBox(height: 10),
          Text(widget.city, style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  StreamBuilder _buildBody(context) {
    return StreamBuilder(
        stream: _weatherBloc.weatherStream,
        builder: (context, snapshot) {
          final errorHandler = ErrorHandler(context);
          final result = errorHandler.handle<LocalWeather>(
              snapshot.data, (weather) => _buildWeatherUI(weather));
          if (result != null) {
            return result;
          } else {
            // Show a loading indicator while waiting for the data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    _weatherBloc.getWeather(widget.city);
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather"),
        ),
        body: _buildBody(context));
  }

  @override
  dispose() {
    super.dispose();
    _weatherBloc.dispose();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'package:weather_bloc/bloc/city_list_bloc.dart';
import 'package:weather_bloc/models/city_model.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/screens/weather_screen.dart';
import 'package:weather_bloc/utils/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(CityAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SearchBar _searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _cityListBloc = CityListBloc();

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(widget.title),
        actions: [_searchBar.getSearchAction(context)]);
  }

  _MyHomePageState() {
    _searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: _onSearch,
        onChanged: _onSearch,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  _onSearch(String value) {
    _cityListBloc.queryCities(value);
  }

  _onItemClicked(city) {
    print('Item was clicked: $city');
    setState(() {
      _searchBar.isSearching.value = false;
    });
    _cityListBloc.upsetCity(
        City(name: city, updatedAt: DateTime.now().millisecondsSinceEpoch));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WeatherScreen(city: city)));
  }

  _buildCityList(list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index].name),
          onTap: () => _onItemClicked(list[index].name),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _searchBar.build(context),
        key: _scaffoldKey,
        body: ValueListenableBuilder(
            valueListenable: _searchBar.isSearching,
            builder: _cityListBuilder));
  }

  Widget _cityListBuilder(context, isSearching, child) {
    if (isSearching) {
      return StreamBuilder(
          stream: _cityListBloc.searchStream,
          builder: (context, snapshot) {
            final result = ErrorHandler(context).handle<List<SearchLocaltions>>(
                snapshot.data, (list) => _buildCityList(list));
            if (result == null) {
              return Center(child: Text("No data"));
            } else {
              return result;
            }
          });
    } else {
      _cityListBloc.getCities();
      return StreamBuilder(
          stream: _cityListBloc.storedStream,
          builder: (context, snapshot) {
            final cities = snapshot.data as List<City>;
            if (cities != null) {
              return _buildCityList(cities);
            } else {
              return Center(child: Text("No data"));
            }
          });
    }
  }

  @override
  dispose() {
    super.dispose();
    _cityListBloc.dispose();
  }
}

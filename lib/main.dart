import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:weather_bloc/bloc/bloc.dart';
import 'package:weather_bloc/bloc/city_list_bloc.dart';
import 'package:weather_bloc/models/search_locations.dart';
import 'package:weather_bloc/screens/weather_screen.dart';
import 'package:weather_bloc/utils/error_handler.dart';

void main() {
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
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final cityListBloc = CityListBloc();

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(widget.title),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    // setState(() => _scaffoldKey.currentState
    //     .showSnackBar(SnackBar(content: Text('You wrote $value!'))));
    cityListBloc.queryCities(value);
  }

  _MyHomePageState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  _buildCityList(list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index].name),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WeatherScreen(city: list[index].name)))
          },
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
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: StreamBuilder(
          stream: cityListBloc.cityStream,
          builder: (context, snapshot) {
            final result = ErrorHandler(context).handle<List<SearchLocaltions>>(
                snapshot.data, (list) => _buildCityList(list));
            if (result == null) {
              return Center(child: Text("No data"));
            } else {
              return result;
            }
          }),
    );
  }

  @override
  dispose() {
    super.dispose();
    cityListBloc.dispose();
  }
}

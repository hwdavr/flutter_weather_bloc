import 'package:flutter/material.dart';
import 'package:weather_bloc/api/resource.dart';
import 'package:weather_bloc/api/resource_error.dart';

class ErrorHandler {
  final BuildContext _context;

  ErrorHandler(this._context);

  Widget handle<T>(Resource resource, Function(T) builder) {
    if (resource == null) {
      return null;
    } else if (resource.error == null) {
      return builder(resource.data);
    } else {
      switch (resource.error.type) {
        case ErrorType.RESPONSE:
          return _showError(resource.error.message);
          break;
        default:
          return _showError("Something wrong, please try again later!");
      }
    }
  }

  Widget handleWithDialog<T>(Resource resource, Function(T) builder) {
    if (resource == null) {
      return null;
    } else if (resource.error == null) {
      return builder(resource.data);
    } else {
      switch (resource.error.type) {
        case ErrorType.RESPONSE:
          Future.delayed(Duration.zero, () {
            _showErrorDialog(_context, resource.error.message);
          });
          break;
        default:
          Future.delayed(Duration.zero, () {
            _showErrorDialog(
                _context, "Something wrong, please try again later!");
          });
      }
      return Container();
    }
  }

  Widget _showError(message) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/network-broken.png',
          width: 100,
          height: 100,
        ),
        Text(message),
      ],
    ));
  }

  Future<void> _showErrorDialog(context, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) Text(_currentAddress ?? ""),
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      // List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality},${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      });
      print(",,,,,,,,,,,,--_-> ${_currentAddress.characters}");
      print(",,,,,,,,,,,,--_-> ${place.position}");
      print(",,,,,,,,,,,,--_-> ${place.isoCountryCode}");
    } catch (e) {
      print(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class BusRide {
  BusRide({
    required this.rideStatus,
    this.routeName,
    this.locations,
    this.driverName,
    this.driverPhone,
  });

  final String? routeName;
  final String rideStatus;
  final Map<String, dynamic>? locations;
  final String? driverName;
  final String? driverPhone;
}

class MapLocationService {
  final String _databaseUrl =
      'https://flutter-test-project-58f59-default-rtdb.firebaseio.com/';

  final Map<String, dynamic> initBus = {
    'rideTitle': 'route 1',
    'rideStatus': 'stopped',
    'locations': {},
  };

  // create new bus
  Future<bool> endBusRide(String busId) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');
    final busData = {
      'rideStatus': 'ended',
    };
    final response = await http.put(url, body: json.encode(busData));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // fetch details about a bus
  Future<BusRide?> fetchBus(String busId) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rideStatus = data['rideStatus'];
      if (rideStatus != 'started') {
        return BusRide(rideStatus: 'not started');
      }
      final Map<String, dynamic> locations = data['locations'];
      log('____________________________________________________________________________');
      log(data['driver']['phone']);

      return BusRide(
        routeName: busId,
        rideStatus: rideStatus,
        locations: locations,
        driverName: data['driver']['name'],
        driverPhone: data['driver']['phone'],
      );
    } else {}

    return null;
  } // end fetch bus

  // send the latest read locaiton to the db
  Future<bool> updateLocation(
      String busId, Map<String, dynamic> locationData) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId/locations.json');
    final response = await http.post(
      url,
      body: json.encode(locationData),
    );

    if (response.statusCode == 200) {
      log('location send succes');
      return true;
    } else {
      log('location send failed');
    }

    return false;
  } // end updateLocation

  Future<void> startRide(
      {required String busId,
      required String direction,
      required Map<String, dynamic> driver}) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');

    Map<String, dynamic> body = {
      'rideStatus': 'started',
      'busInfo': 'null',
      'direction': direction,
      'startTime': DateTime.now().toString(),
      'driver': driver,
    };

    // final response =
    await http.put(
      url,
      body: json.encode(body),
    );

    // log(response.body.toString() + '************************************8');
  }

  // get the latest location for a bus id
  Future<Map<String, dynamic>?> fetchLocation(String busId,
      {Function? onRideEnd}) async {
    // final url = Uri.parse('$_databaseUrl/Buses/$busId/locations.json'); real one
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');
    final response = await http.get(url);
    log(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> locations = data['locations'];
      final Map<String, dynamic> latestLocation = locations.entries.last
          .value; // last value is the latest, of type {'latitude': 343, 'longitude': 42}
      log('latest location ======================== $latestLocation');
      if (data['rideStatus'] == 'ended') {
        if (onRideEnd != null) onRideEnd();
      }
      return latestLocation;
    } else {
      log(response.statusCode.toString());
    }

    return null;
  } // end fetchLocation

  Future<List<LatLng>> getPolyline(String route) async {
    Uri url = Uri.parse('$_databaseUrl/Routes/$route.json');
    final response = await http.get(url);

    Map<String, dynamic> data = json.decode(response.body);
    List<LatLng> polylineCoordinates = [];

    if (data['status'] == 'OK') {
      var points = data['routes'][0]['overview_polyline']['points'];

      List<PointLatLng> result = PolylinePoints().decodePolyline(points);
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    return polylineCoordinates;
  }
}

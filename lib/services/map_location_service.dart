import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class BusRide {
  BusRide({
    required this.routeName,
    required this.rideStatus,
    required this.locations,
  });

  final String routeName;
  final String rideStatus;
  final Map<String, dynamic> locations;
}

class MapLocationService {
  Timer? _timer;

  final String _databaseUrl =
      'https://flutter-test-project-58f59-default-rtdb.firebaseio.com/';

  final Map<String, dynamic> initBus = {
    'rideTitle': 'route 1',
    'rideStatus': 'stopped',
    'locations': {},
  };

  // create new bus
  Future<bool> initializeBus(String busId, Map<String, dynamic> busData) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');
    final response = await http.put(url, body: json.encode(busData));

    if (response.statusCode == 200) {
      print('bus init success');
      return true;
    } else {
      print('bus init failed');
    }

    return false;
  }

  // fetch details about a bus
  Future<BusRide?> fetchBus(String busId) async {
    final url = Uri.parse('$_databaseUrl/Buses/$busId.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('data fetch success $busId');

      final data = json.decode(response.body);
      final rideStatus = data['rideStatus'];
      final routeName = data['routeName'];
      final Map<String, dynamic> locations = data['locations'];
      print(data);
      return BusRide(
        routeName: routeName,
        rideStatus: rideStatus,
        locations: locations,
      );
    } else {
      print(response.statusCode);
    }

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
      print('location send succes');
      return true;
    } else {
      print('location send failed');
    }

    return false;
  } // end updateLocation

  // get the latest location for a bus id
  Future<Map<String, dynamic>?> fetchLocation(String busId) async {
    // final url = Uri.parse('$_databaseUrl/Buses/$busId/locations.json'); real one
    final url = Uri.parse('$_databaseUrl/locations.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('data fetch success $busId');

      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> latestLocation =
          data.entries.last.value; // last value is the latest
      print(latestLocation);
      return latestLocation;
    } else {
      print(response.statusCode);
    }

    return null;
  } // end fetchLocation

  Future<dynamic> getPolyline(String route) async {
    Uri url = Uri.parse('$_databaseUrl/Routes/$route.json');
    final response = await http.get(url);

    final data = json.decode(response.body);
    return data;
  }

  // start sending data after an interval
  startSendingData(int n) {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        fakeFetchLocation(n);
      },
    );
  }

  Future<Map<String, dynamic>?> fakeFetchLocation(int num) async {
    final url = Uri.parse('$_databaseUrl/fakeLocations/bus1.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('data fetch success $num');

      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> latestLocation =
          data.entries.elementAt(num).value; // last value is the latest
      print("latest location ****************** " + latestLocation.toString());
      return latestLocation;
    } else {
      print(response.statusCode);
    }

    return null;
  }
}

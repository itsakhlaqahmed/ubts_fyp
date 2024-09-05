import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/map_location_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/home/home_map_card.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({
    super.key,
    required this.userData,
    required this.busId,
    required this.direction,
    required this.busName,
  });

  final Map<UserData, dynamic> userData;
  final String busName;
  final String busId;
  final String direction;

  @override
  State<DriverMapScreen> createState() => _StartRidePagetate();
}

class _StartRidePagetate extends State<DriverMapScreen> {
  final AuthService _authService = AuthService();

  // map widget data
  final MapLocationService _mapLocationService = MapLocationService();
  LatLng? _currentLocation;
  String? _address;
  Timer? _timer;
  bool _fullMapEnabled = false;
  final Set<Polyline> _polylines = {};

  Future<void> _getPolyline(String route) async {
    Map<String, dynamic> data = await _mapLocationService.getPolyline(route);
    List<LatLng> polylineCoordinates = [];

    if (data['status'] == 'OK') {
      var points = data['routes'][0]['overview_polyline']['points'];
      // var legs = data['routes'][0]['legs'][0];
      // setState(() {
      //   distance = legs['distance']['text'];
      //   duration = legs['duration']['text'];
      // });

      List<PointLatLng> result = PolylinePoints().decodePolyline(points);
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      // await _addMarker();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('polyline'),
            visible: true,
            points: polylineCoordinates,
            color: const Color.fromARGB(255, 253, 129, 59),
            width: 6,
          ),
        );
      });
    }
  }

  Future<void> _startLiveLocation() async {
    final Map<String, dynamic> driver = {
      'name': widget.userData[UserData.fullName],
      'phone': widget.userData[UserData.studentId],
    };
    // setState(() {
    //   _locationServiceRunning = true;
    // });

    try {
      // get device location for the first time
      await _getLocation();
      await _mapLocationService.startRide(
        busId: widget.busId,
        direction: widget.direction,
        driver: driver,
      );

      // then after every x seconds
      _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
        await _getLocation();
        await _mapLocationService.updateLocation(
          widget.busId,
          {
            'latitude': _currentLocation!.latitude,
            'longitude': _currentLocation!.longitude,
          },
        );
      });
    } catch (err) {
      // print(err.toString() + '**************************');
    }
  }

  Future<void> _endLiveShare() async {
    _timer?.cancel();
    // setState(() {
    //   _locationServiceRunning = false;
    // });
  }

  @override
  void initState() {
    _startLiveLocation();
    _getPolyline(widget.busId);
    super.initState();
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    LocationPermission hasPermission = await Geolocator.checkPermission();

    if (hasPermission != LocationPermission.whileInUse ||
        hasPermission != LocationPermission.always) {
      hasPermission = await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      await _getAddress(_currentLocation!);
    } catch (err) {
      // handle error
    }
  } // end _getLocation

  Future<void> _getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _address = '${place.thoroughfare} ${place.subLocality}';
      });
    } catch (e) {
      print(e);
    }
  } // end _getAddress

  void _signOut() async {
    await _authService.signOut();
    await PersistantStorage().deleteLocalUser();
    await _endLiveShare();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LoginPage(),
      ),
    );
  } // end signout

  void _exitFullScreen() {
    setState(() {
      _fullMapEnabled = false;
    });
  }

  void _enableFullScreen() {
    setState(() {
      _fullMapEnabled = true;
    });
  }

  Widget placeHolder({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.amber,
      ),
    );
  }

  Widget _getMapSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolder(height: 350),
            const SizedBox(height: 16),
            placeHolder(height: 24, width: 200),
            const SizedBox(height: 8),
            placeHolder(height: 24, width: 160),
          ],
        ),
      ),
    );
  } // end _getMapSkeleton

  Widget _getTitleBarSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                placeHolder(height: 24, width: 140),
                const Spacer(),
                IconButton(
                  onPressed: _signOut,
                  icon: const Icon(Icons.exit_to_app_outlined),
                ),
              ],
            ),
            placeHolder(height: 16, width: 80),
          ],
        ),
      ),
    );
  }

  Widget _getTitleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.userData[UserData.fullName] ?? 'null',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _signOut,
                icon: const Icon(Icons.exit_to_app_outlined),
              ),
            ],
          ),
          Text(
            widget.userData[UserData.studentId] ?? 'null',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFullScreenMap() {
    return HomeMapCard(
      routeName: widget.busName,
      currentLocation: _currentLocation!,
      address: _address,
      fullMapEnabled: _fullMapEnabled,
      onExitFullScreen: _exitFullScreen,
      polylines: _polylines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _fullMapEnabled
            ? _getFullScreenMap() // no need to null check _currentLocation cos fullmap btn will be visible only once location is fetched.
            : LiquidPullToRefresh(
                animSpeedFactor: 2,
                height: 200,
                backgroundColor: const Color.fromARGB(255, 253, 129, 59),
                color: const Color.fromARGB(100, 249, 181,
                    142), // const Color.fromARGB(141, 244, 174, 134),
                showChildOpacityTransition: false,
                onRefresh: () async {
                  Future.delayed(const Duration(seconds: 1), () async {
                    await _getLocation();
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      widget.userData[UserData.userId] != null
                          ? _getTitleBar()
                          : _getTitleBarSkeleton(),
                      const SizedBox(
                        height: 8,
                      ),
                      _currentLocation != null
                          ? HomeMapCard(
                              routeName: widget.busName,
                              currentLocation: _currentLocation!,
                              address: _address,
                              onClickFullScreen: _enableFullScreen,
                              polylines: _polylines,
                            )
                          : _getMapSkeleton(),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

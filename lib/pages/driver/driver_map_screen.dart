import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:ubts_fyp/widgets/home_map_card.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({
    super.key,
    required this.userData,
    required this.busId,
  });

  final Map<UserData, dynamic> userData;
  final String busId;

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
  bool _locationServiceRunning = false;
  bool _fullMapEnabled = false;

  Future<void> _startLocation() async {
    setState(() {
      _locationServiceRunning = true;
    });
    // get location for the first time
    await _getLocation();

    // then after every x seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _getLocation();
    });
  }

  Future<void> _endLiveShare() async {
    _timer?.cancel();
    setState(() {
      _locationServiceRunning = false;
    });
  }

  @override
  void initState() {
    _getLocation();
    _startLocation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _fullMapEnabled
            ? HomeMapCard(
                routeName: 'Gulshan e Hadeed',
                currentLocation: _currentLocation!,
                address: _address,
                fullMapEnabled: _fullMapEnabled,
                onExitFullScreen: _exitFullScreen,
              )
            : LiquidPullToRefresh(
                animSpeedFactor: 2,
                height: 200,
                backgroundColor: const Color.fromARGB(255, 253, 129, 59),
                color: const Color.fromARGB(100, 249, 181,
                    142), // const Color.fromARGB(141, 244, 174, 134),
                showChildOpacityTransition: false,
                onRefresh: () async {
                  Future.delayed(const Duration(seconds: 1), () {
                    _getLocation();
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
                              routeName: 'Gulshan e Hadeed',
                              currentLocation: _currentLocation!,
                              address: _address,
                              onClickFullScreen: _enableFullScreen,
                            )
                          : _getMapSkeleton(),
                      const SizedBox(
                        height: 16,
                      ),
                      // WideButton(
                      //   // onSubmitForm: _startLocation,
                      //   onSubmitForm: () {
                      //     setState(() {
                      //       _fullMapEnabled = true;
                      //     });
                      //   },
                      //   buttonText: 'fetch location',
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

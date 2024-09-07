import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/map_location_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/home/home_map_card.dart';
import 'package:ubts_fyp/widgets/home/not_approved.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.user});

  final Map<UserData, dynamic>? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  Map<UserData, dynamic> _userData = {
    UserData.fullName: 'null',
    UserData.email: 'null',
    UserData.busRoute: 'null',
    UserData.isApproved: 'null',
    UserData.studentId: 'null',
    UserData.userId: 'null',
    UserData.userType: 'null',
  };
  // String _busId = 'smiu-hadeed';
  String _driverName = 'null';
  String? _driverPhone;
  bool _hasRideStarted = false;
  bool _hasRideEnded = false;

  // map widget data
  final MapLocationService _mapLocationService = MapLocationService();
  LatLng? _currentLocation;
  String? _address;
  final Set<Polyline> _polylines = {};
  bool _fullMapEnabled = false;
  Timer? _timer;
  LatLng? initialPosition;
  Set<Marker>? _markers;

  @override
  initState() {
    authenticateUser();
    _fetchLocalUser();
    // _getBusStatus(_userData[UserData.busRoute]);
    super.initState();
    // _getMapData(_busId);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void authenticateUser() {
    if (AuthService().getAuth == null) {
      _signOut();
    }
  }

  Future<void> _getBusStatus(String busId) async {
    // get route/bus data whether it has started and so on
    try {
      // log(busId);
      final busData = await _mapLocationService.fetchBus(busId);
      // log(
      //     'busData?.rideStatus *********************************************88');
      // log(busData?.rideStatus);
      if (busData != null && busData.rideStatus == 'started') {
        setState(() {
          _hasRideStarted = true;
          _driverName = busData.driverName!;
          _driverPhone = busData.driverPhone ?? 'null';
        });
      }
      await _startFetchingLocation();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> _startFetchingLocation() async {
    _endFetchingLocation();
    try {
      // then after every x seconds
      final latestLocation = await _fetchLatestLocation();
      setState(() {
        _currentLocation = latestLocation;
        initialPosition = latestLocation;
      });

      await _getPolyline(
        _userData[UserData.busRoute],
      );
      await _getAddress(_currentLocation!);
      _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        if (_hasRideStarted) {
          final newPosition = await _fetchLatestLocation();
          setState(() {
            _currentLocation = newPosition;
          });
          await _getAddress(newPosition);
        } else {
          _endFetchingLocation();
        }
      });
    } catch (err) {
      // log(err.toString() + '**************************');
    }
  }

  Future<void> _endFetchingLocation() async {
    _timer?.cancel();
  }

  Future<void> handleBusRideEnded() async {
    setState(() {
      _hasRideEnded = true;
    });
  }

  Future<LatLng> _fetchLatestLocation() async {
    final response = await _mapLocationService.fetchLocation(
      _userData[UserData.busRoute],
    );

    return LatLng(response!['latitude'], response['longitude']);
  }

  Future<void> _getAddress(LatLng position) async {
    if (_hasRideStarted) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          // position.latitude,
          // position.longitude,
          24.830272953082, 67.05506649966024,
        );

        Placemark place = placemarks[0];

        setState(() {
          _address = '${place.thoroughfare}, ${place.subLocality}';
        });
      } catch (e) {
        // log(e);
      }
    }
  }

  Future<void> _fetchLocalUser() async {
    // dont fetch local data if user is given as the widget props
    if (widget.user != null) {
      setState(() {
        _userData = widget.user!;
      });
      return;
    }

    // else fetch user's local data on device

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    Map<UserData, dynamic> userData =
        await PersistantStorage().fetchLocalUser();

    if (userData[UserData.userId] == null) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      userData = await PersistantStorage().fetchLocalUser();
    }

    setState(() {
      _userData = userData;
    });
  }

  Future<void> _getPolyline(String busId) async {
    final polylineCoordinates = await _mapLocationService.getPolyline(busId);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('polyline'),
          visible: true,
          points: polylineCoordinates,
          color: const Color.fromARGB(255, 253, 129, 59),
          endCap: Cap.roundCap,
          width: 6,
        ),
      );
      _markers = {
        Marker(
          markerId: const MarkerId('start'),
          position: polylineCoordinates.first,
        ),
        Marker(
          markerId: const MarkerId('end'),
          position: polylineCoordinates.last,
        ),
      };
    });
  }

  void _signOut() async {
    await _authService.signOut();
    await PersistantStorage().deleteLocalUser();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LoginPage(),
      ),
    );
  }

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

  Widget _getFullScreenMap() {
    return HomeMapCard(
      // routeName: widget.busName,
      routeName: 'widget.busName',
      currentLocation: _currentLocation!,
      address: _address,
      fullMapEnabled: _fullMapEnabled,
      onExitFullScreen: _exitFullScreen,
      polylines: _polylines,
      markers: _markers,
      initialPosition: initialPosition,
    );
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
  }

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
                _userData[UserData.fullName] ?? 'null',
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
            _userData[UserData.studentId] ?? 'null',
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
    late Widget content;

    if (_userData[UserData.isApproved] != 'true') {
      // implement not approved ui here
      content = Column(
        children: [
          const SizedBox(height: 8),
          _userData[UserData.userId] != null
              ? _getTitleBar()
              : _getTitleBarSkeleton(),
          const SizedBox(height: 12),
          const NotApproved(),
        ],
      );
    } else {
      content = _fullMapEnabled
          ? _getFullScreenMap()
          : LiquidPullToRefresh(
              animSpeedFactor: 2,
              height: 200,
              backgroundColor: const Color.fromARGB(255, 253, 129, 59),
              color: const Color.fromARGB(100, 249, 181,
                  142), // const Color.fromARGB(141, 244, 174, 134),
              showChildOpacityTransition: false,
              onRefresh: () async {
                Future.delayed(const Duration(seconds: 1), () {
                  _getBusStatus(_userData[UserData.busRoute]);
                });
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _userData[UserData.userId] != null
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
                              polylines: _polylines,
                              initialPosition: initialPosition,
                            )
                          : _getMapSkeleton(),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          // height: 100,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 10, 25, 37),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Driver',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(
                                          162, 139, 176, 205),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _driverName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        _driverPhone ?? '03XX-XXXXXXX',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
    }

    return Scaffold(
      body: SafeArea(
        child: content,
      ),
    );
  }
}

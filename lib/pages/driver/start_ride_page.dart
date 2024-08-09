import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/map_location_service.dart';
import 'package:ubts_fyp/widgets/home_map_card.dart';

class StartRidePage extends StatefulWidget {
  const StartRidePage({super.key, required this.userData});

  final Map<UserData, dynamic> userData;

  @override
  State<StartRidePage> createState() => _StartRidePageState();
}

class _StartRidePageState extends State<StartRidePage> {
  final AuthService _authService = AuthService();
  String _busId = 'smiu-hadeed';
  String _driverName = 'Mr. Amjad A';
  String _driverPhone = '0331-3284912';

  // map widget data
  final MapLocationService _mapLocationService = MapLocationService();
  LatLng? _currentLocation;
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          animSpeedFactor: 2,
          height: 200,
          backgroundColor: const Color.fromARGB(255, 253, 129, 59),
          color: const Color.fromARGB(
              100, 249, 181, 142), // const Color.fromARGB(141, 244, 174, 134),
          showChildOpacityTransition: false,
          onRefresh: () async {
            Future.delayed(const Duration(seconds: 1), () {
              // _getMapData(_busId);
              setState(() {
                _currentLocation = LatLng(24.828960282034558, 67.0474697314889);
              });
            });
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // widget.userData[UserData.userId] != null
                  //     ? _getTitleBar()
                  //     : _getTitleBarSkeleton(),
                  const SizedBox(
                    height: 8,
                  ),
                  _currentLocation != null
                      ? HomeMapCard(
                          routeName: 'Gulshan e Hadeed',
                          currentLocation: _currentLocation!,
                          address: _address,
                        )
                      : SizedBox.shrink(), //_getMapSkeleton(),
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
                                  color:
                                      const Color.fromARGB(162, 139, 176, 205),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _driverName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    _driverPhone,
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
        ),
      ),
    );
    ;
  }
}

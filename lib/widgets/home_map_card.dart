import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubts_fyp/services/map_location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

class HomeMapCard extends StatefulWidget {
  const HomeMapCard({super.key, required this.busId});

  final String busId;

  @override
  State<HomeMapCard> createState() => _HomeMapCardState();
}

class _HomeMapCardState extends State<HomeMapCard> {
  final MapLocationService _mapLocationService = MapLocationService();
  bool rideStarted = false;
  String _routeName = 'Gulshan e Hadeed';
  LatLng? _currentLocation;
  String? _address;

  Future<void> getCurrentLocation(String id) async {
    var result = await _mapLocationService.fetchLocation(id);

    setState(() {
      _currentLocation = LatLng(result!['latitude']!, result['longitude']);
    });
    await _getAddress(_currentLocation!);
  }

  Future<void> _getAddress(LatLng position) async {
    print('position________________________--' + position.toString());
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
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation(widget.busId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.orange[200],
      // ),
      child: _currentLocation != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 350,
                    child: GoogleMap(
                      mapToolbarEnabled: false,
                      liteModeEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: 17,
                      ),
                      // markers: {
                      //   Marker(
                      //     markerId: const MarkerId('currentLocation'),
                      //     position: _currentLocation!,
                      //   ),
                      // },
                      circles: {
                        Circle(
                          circleId: const CircleId('currentLocation'),
                          center: _currentLocation!,
                        ),
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange[50],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.route_outlined),
                            const SizedBox(width: 4),
                            Text(
                              _routeName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.directions_bus_outlined),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              rideStarted ? 'on Route' : 'Not started',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              child: Text(
                                'Near $_address',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        WideButton(
                          onSubmitForm: () {},
                          buttonText: 'Full Map',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

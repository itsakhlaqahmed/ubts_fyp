import 'package:flutter/cupertino.dart';
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
        position.latitude,
        position.longitude,
        // 24.829387636816918, 67.0585346141240,
      );

      Placemark place = placemarks[0];

      setState(() {
        _address = '${place.street}, ${place.locality}, ${place.country}';
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
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    liteModeEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 17,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: _currentLocation!,
                      ),
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange[50],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _routeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Buss Status: ',
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
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
                          const Text(
                            'Current Location: ',
                            maxLines: 3,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Near $_address' ?? 'null',
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
                      WideButton(onSubmitForm: () {}, buttonText: 'Full Map')
                    ],
                  ),
                ),

                // Text(_currentLocation.toString()),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

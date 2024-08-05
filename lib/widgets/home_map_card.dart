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
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: _currentLocation != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
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
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                            rideStarted ? 'on Route' : 'Not yet started',
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
                        children: [
                          const Text(
                            'Address: ',
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _address ?? 'null',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      WideButton(onSubmitForm: () {}, buttonText: 'Start')
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

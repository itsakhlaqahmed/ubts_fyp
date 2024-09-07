import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

class HomeMapCard extends StatefulWidget {
  const HomeMapCard({
    super.key,
    // required this.busId,
    // required this.onLoading,
    required this.routeName,
    required this.currentLocation,
    this.address,
    this.fullMapEnabled,
    this.onExitFullScreen,
    this.onClickFullScreen,
    this.initialPosition,
    this.markers,
    this.polylines,
  });

  final String routeName;
  final LatLng currentLocation;
  final Set<Polyline>? polylines;
  final Set<Marker>? markers;
  final LatLng? initialPosition;
  final String? address;
  final bool? fullMapEnabled;
  final Function? onExitFullScreen;
  final Function? onClickFullScreen;

  @override
  State<HomeMapCard> createState() => _HomeMapCardState();
}

class _HomeMapCardState extends State<HomeMapCard> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  bool rideStarted = true;
  // late Circle _circle;
  late LatLng newPosition;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    newPosition = widget.currentLocation;
    // _setCricle();
  }

  _moveCam() async {
    GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(widget.currentLocation));
  }

  // _setCricle() {
  //   setState(() {
  //     _circle = Circle(
  //       circleId: const CircleId('currentLocation'),
  //       center: widget.currentLocation,
  //       radius: 20,
  //       fillColor: Colors.orange,
  //       strokeColor: const Color.fromARGB(133, 255, 204, 128),
  //       strokeWidth: 30,
  //     );
  //   });
  // }

  @override
  void didUpdateWidget(covariant HomeMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocation != oldWidget.currentLocation) {
      _animateCircleToNewLocation(widget.currentLocation);
    } else if (true) {}
  }

  Widget _getGoogleMap() {
    return GoogleMap(
      onMapCreated: (controller) async {
        _googleMapController.complete(controller);
      },
      mapToolbarEnabled: false,
      minMaxZoomPreference: widget.fullMapEnabled != null
          ? const MinMaxZoomPreference(11, 20)
          : const MinMaxZoomPreference(17, 17),
      scrollGesturesEnabled: widget.fullMapEnabled ?? false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation,
        zoom: 17,
      ),
      polylines: widget.polylines ?? {},
      circles: {
        // _circle,
        Circle(
          circleId: const CircleId('currentLocation'),
          center: newPosition,
          radius: 20,
          fillColor: Colors.orange,
          strokeColor: const Color.fromARGB(133, 255, 204, 128),
          strokeWidth: 30,
        )
      },
      markers: widget.markers ?? {},
    );
  }

  void _animateCircleToNewLocation(LatLng newLocation) {
    // Stop any existing animation
    _timer?.cancel();

    const int steps = 100;
    const duration = Duration(milliseconds: 10);
    final double latStep =
        (newLocation.latitude - newPosition.latitude) / steps;
    final double lngStep =
        (newLocation.longitude - newPosition.longitude) / steps;

    int currentStep = 0;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        newPosition = LatLng(
          newPosition.latitude + latStep,
          newPosition.longitude + lngStep,
        );
      });

      currentStep++;
      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _moveCam();

    return widget.fullMapEnabled ?? false
        ? Animate(
            effects: const [
              ScaleEffect(
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  curve: Curves.easeOutCubic,
                  begin: Offset(0, 0)),
            ],
            child: Stack(
              children: [
                _getGoogleMap(),
                Positioned(
                  bottom: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: MediaQuery.of(context).size.width,
                    child: WideButton(
                        onSubmitForm: widget.onExitFullScreen!,
                        buttonText: 'Exit Full Map'),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 350,
                  child: _getGoogleMap(),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(99, 253, 187, 148),
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
                            widget.routeName,
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
                              'Near ${widget.address}',
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
                        onSubmitForm: widget.onClickFullScreen!,
                        buttonText: 'Full Map',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

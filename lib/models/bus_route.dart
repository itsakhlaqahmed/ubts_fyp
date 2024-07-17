// class BusRoute {
//   const BusRoute({
//     required this.id,
//     required this.route,
//     required this.busStops,
//   });

//   final String id;
//   final String route;
//   final List<String> busStops;
// }


import 'package:ubts_fyp/models/bus_stop.dart';

class BusRoute {
  const BusRoute({
    required this.title,
    required this.stops,
  });

  final String title;
  final List<BusStop> stops;
}

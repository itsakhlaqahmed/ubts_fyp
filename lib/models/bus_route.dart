class BusRoute {
  const BusRoute({
    required this.id,
    required this.route,
    required this.busStops,
  });

  final String id;
  final String route;
  final List<String> busStops;
}

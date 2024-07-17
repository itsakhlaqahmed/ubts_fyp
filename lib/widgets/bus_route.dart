import 'package:flutter/material.dart';

class BusRoutePanel extends StatefulWidget {
  const BusRoutePanel({
    super.key,
    required this.onSelectRoute,
  });

  final Function(String route) onSelectRoute;

  @override
  State<BusRoutePanel> createState() => _BusRoutePanelState();
}

class _BusRoutePanelState extends State<BusRoutePanel> {
  final List<String> routes = [
    'Gulshan e Hadeed',
    'Baldia Town',
    'North Nazimabad',
    'Steel Town'
  ];

  String? _selectedRoute;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 36,
        ),
        const Text('Select Your Bus Route'),
        const SizedBox(
          height: 24,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: routes.length,
          itemBuilder: (context, index) {
            bool isSelected =
                routes.indexOf(_selectedRoute.toString()) == index;
            return Container(
              margin: const EdgeInsets.only(
                bottom: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? const Color.fromARGB(255, 84, 50, 187)
                      : Colors.black,
                ),
                borderRadius: BorderRadius.circular(6),
                color: isSelected
                    ? const Color.fromARGB(30, 117, 75, 243)
                    : Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedRoute = routes[index];
                    _error = false;
                  });
                },
                child: ListTile(
                  title: Text(
                    routes[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: const Icon(
                    Icons.pin_drop_outlined,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            if (_selectedRoute != null) {
              widget.onSelectRoute(_selectedRoute!);
            } else {
              setState(() {
                _error = true;
              });
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 117, 75, 243),
            ),
            child: Center(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        _error
            ? const Center(
              child: Text(
                  'Kindly select a route',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}

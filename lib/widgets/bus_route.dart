import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

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

  final Map<String, String> allRoutes = {
    'Gulshan e Hadeed': 'hadeed',
    'Baldia Town': 'korangi',
    'North Nazimabad': 'nazimabad',
    'Steel Town': 'gulshan'
  };

  String? _selectedRoute;
  bool _error = false;

  void _nextPage() {
    if (_selectedRoute != null) {
      widget.onSelectRoute(allRoutes[_selectedRoute!]!);
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> routes = allRoutes.keys.toList();

    return Animate(
      effects: const [
        SlideEffect(
          duration: Duration(milliseconds: 200),
          begin: Offset(3, 0),
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Column(
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
                        ?  const Color.fromARGB(255, 253, 129, 59)
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: isSelected
                      ?  const Color.fromARGB(70, 255, 144, 80)
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
          WideButton(
            onSubmitForm: _nextPage,
            buttonText: 'Next',
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

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

  Widget _getRouteList() {
    final List<String> routes = allRoutes.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: routes.length,
      itemBuilder: (context, index) {
        bool isSelected = routes.indexOf(_selectedRoute.toString()) == index;
        return _getRouteTile(isSelected, routes[index]);
      },
    );
  }

  Widget _getRouteTile(bool isSelected, String route) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? ColorTheme.primaryTint1 : Colors.black,
        ),
        borderRadius: BorderRadius.circular(6),
        color: isSelected
            ? ColorTheme.colorWithOpacity(ColorTheme.primaryTint1, .2)
            : Colors.white,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRoute = route;
            _error = false;
          });
        },
        child: ListTile(
          title: Text(
            route,
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
  } // end getRouteTile

  Widget _getErrorMessage() {
    return const Center(
      child: Text(
        'Kindly select a route',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _getRouteList(),
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
          _error ? _getErrorMessage() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

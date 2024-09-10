import 'package:flutter/material.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';

class RideStatus extends StatelessWidget {
  const RideStatus({super.key, this.isEndRideWidget});

  final bool? isEndRideWidget;

  @override
  Widget build(BuildContext context) {
    var heading = 'Bus hasn\'t started yet';
    var messsage =
        'Your ride hasn\'t started yet. Once it begins, you\'ll see the map here.';
    if (isEndRideWidget == true) {
      heading = 'Bus has Arrived ...';
      messsage =
          'The bus has arrived it\'s destination. Kindly report any inconveince during the ride to the transportation department';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          height: 24,
        ),
        SizedBox(
          height: 400,
          child: Image.asset(
            'assets/${isEndRideWidget == true ? 'arrived' : 'welcome'}.png',
            fit: BoxFit.cover,
          ),
        ),
        // _userData[UserData.userId] != null
        //     ? _getTitleBar()
        //     : _getTitleBarSkeleton(),
        const SizedBox(
          height: 48,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus,
              color: isEndRideWidget == true
                  ? Colors.red[600]
                  : ColorTheme.primaryTint1,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              heading,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isEndRideWidget == true
                        ? Colors.red[600]
                        : ColorTheme.primaryTint1,
                    fontSize: 28,
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            messsage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }
}

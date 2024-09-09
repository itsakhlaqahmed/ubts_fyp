import 'package:flutter/material.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';

class RideStatus extends StatelessWidget {
  const RideStatus({super.key});

  final heading = 'Bus hasn\'t started yet';
  final messsage =
      'Your ride hasn\'t started yet. Once it begins, you\'ll see the details here.';

  @override
  Widget build(BuildContext context) {
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
            'assets/welcome.png',
            fit: BoxFit.cover,
          ),
        ),
        // _userData[UserData.userId] != null
        //     ? _getTitleBar()
        //     : _getTitleBarSkeleton(),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus,
              color: ColorTheme.primaryTint1,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              heading,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.primaryTint1,
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

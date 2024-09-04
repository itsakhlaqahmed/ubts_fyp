import 'package:flutter/material.dart';

class NotApproved extends StatelessWidget {
  const NotApproved({super.key});

  final double a = 0.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: a,
          ),
          SizedBox(
            height: 400,
            child: Image.asset(
              'assets/clock.gif',
              fit: BoxFit.cover,
              color: Color.fromARGB(54, 248, 235, 228),
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          // _userData[UserData.userId] != null
          //     ? _getTitleBar()
          //     : _getTitleBarSkeleton(),
          const SizedBox(
            height: 36,
          ),
          Text(
            'Not Approved Yet',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFD813B),
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Your account is pending approval form the admin. If your account isn\'t approved within 2,3 working days then kindly contact the transport department.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: const Color.fromARGB(255, 255, 149, 88),
                  fontWeight: FontWeight.bold
                ),
          ),
        ],
      ),
    );
  }
}

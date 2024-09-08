import 'package:flutter/material.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

class NotApproved extends StatelessWidget {
  const NotApproved({super.key, required this.onSignout});
  final Function onSignout;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 400,
            child: Image.asset(
              'assets/wait_image.png',
              fit: BoxFit.cover,
              // color: ColorTheme.primaryWithOpacity(.05 ),
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
            'Wait for Approval ⌛',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.primaryShade1,
                  fontSize: 28,
                ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Your account application is pending approval form the admin. If your account isn\'t approved within 2-3 working days, contact the transportation department.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorTheme.primaryShade1,
                    fontWeight: FontWeight.bold,
                    
                  ),
            ),
          ),
          const SizedBox(
            height: 48,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            child: WideButton(
              onSubmitForm: onSignout,
              buttonText: 'Logout',
            ),
          ),
        ],
      ),
    );
  }
}

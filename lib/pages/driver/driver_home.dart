import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/driver/driver_map_screen.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';
import 'package:ubts_fyp/widgets/home/welcome_banner.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key, this.user});
  final Map<UserData, dynamic>? user;

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final Map<String, String> allRoutes = {
    'Gulshan e Hadeed': 'hadeed',
    'Korangi': 'korangi',
    'North Nazimabad': 'nazimabad',
    'Gulshan e Iqbal': 'gulshan'
  };

  String? _selectedRoute;
  String? _direction;
  bool _showError = false;
  Map<UserData, dynamic> _userData = {};
  final AuthService _authService = AuthService();

  @override
  void initState() {
    authenticateUser();
    _fetchLocalUser();
    super.initState();
  }

  void authenticateUser() {
    if (AuthService().getAuth == null) {
      _signOut();
    }
  }

  void _nextPage() {
    if (_selectedRoute != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DriverMapScreen(
            userData: _userData,
            busId: allRoutes[_selectedRoute]!,
            direction: _direction!,
            busName: _selectedRoute!,
          ),
        ),
      );
      return;
    }
    setState(() {
      _showError = false;
    });
  }

  Future<void> _fetchLocalUser() async {
    // dont fetch local data if user is given as the widget props
    if (widget.user != null) {
      setState(() {
        _userData = widget.user!;
      });
      return;
    }

    // else fetch user's local data on device

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    Map<UserData, dynamic> userData =
        await PersistantStorage().fetchLocalUser();

    if (userData[UserData.userId] == null) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      userData = await PersistantStorage().fetchLocalUser();
    }

    setState(() {
      _userData = userData;
    });
  } // fetch local user

  void _signOut() async {
    await _authService.signOut();
    await PersistantStorage().deleteLocalUser();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LoginPage(),
      ),
    );
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
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            margin: const EdgeInsets.only(
              top: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _direction = null;
                  _selectedRoute = route;
                  _showError = false;
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
          ),
          isSelected ? _getDirectionOptions(route) : const SizedBox(),
        ],
      ),
    );
  } // end getRouteTile

  Widget _getTitleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _userData[UserData.fullName] ?? 'null',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          // Text(
          //   _userData[UserData.studentId] ?? 'null',
          //   style: const TextStyle(
          //     fontSize: 16,
          //   ),
          // ),
        ],
      ),
    );
  } // end _getTitleBar

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

  Widget _getDirectionOptions(String route) {
    return Animate(
      effects: const [
        SlideEffect(
          duration: Duration(milliseconds: 300),
          begin: Offset(1, 0),
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(
          top: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: null,
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: 60,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorTheme.primaryTint1,
            ),
            borderRadius: BorderRadius.circular(6),
            // color: const Color.fromARGB(70, 255, 144, 80),
          ),
          child: Row(
            children: [
              _getDirectionOptionButton(route, 'Up'),
              const VerticalDivider(),
              _getDirectionOptionButton(route, 'Down'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDirectionOptionButton(String route, String direction) {
    return InkWell(
      onTap: () {
        setState(() {
          _direction = direction.toLowerCase();
        });
      },
      child: Container(
        color: _direction == direction.toLowerCase()
            ? ColorTheme.colorWithOpacity(ColorTheme.primaryTint1, .2)
            : Colors.white,
        height: 60,
        width: (MediaQuery.of(context).size.width - 66) / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _direction == direction.toLowerCase()
                ? Icon(
                    Icons.check_circle_outline,
                    color: ColorTheme.primaryTint1,
                    size: 32,
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  direction,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    // height: 4,
                    ),
                Text(
                  'From SMIU \nTo $route',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTitleBarSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolder(height: 24, width: 140),
            const SizedBox(
              height: 8,
            ),
            placeHolder(height: 16, width: 80),
          ],
        ),
      ),
    );
  } // end _getTitleBarSkeleton

  Widget placeHolder({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Driver Home',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: ColorTheme.primaryShade1,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.exit_to_app_outlined),
          ),
        ],
      ),
      drawer: const Column(),
      body: Animate(
        effects: const [
          SlideEffect(
            duration: Duration(milliseconds: 200),
            begin: Offset(3, 0),
            curve: Curves.easeOutCubic,
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _userData[UserData.userId] != null
                      ? _getTitleBar()
                      : _getTitleBarSkeleton(),
                  const SizedBox(
                    height: 48,
                  ),
                  const WelcomeBanner(),
                  const SizedBox(
                    height: 32,
                  ),
                  // Center(
                  //   child: Text(
                  //     'Ready to Start',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: ColorTheme.primary,
                  //       fontSize: 28,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  Center(
                    child: Text(
                      _selectedRoute == null
                          ? 'Please select bus route'
                          : 'Select the route direction of the bus',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _getRouteList(),
                  const SizedBox(
                    height: 24,
                  ),
                  WideButton(
                    onSubmitForm: _nextPage,
                    buttonText: 'Start Ride',
                    isDisabled: _selectedRoute == null || _direction == null,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _showError ? _getErrorMessage() : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

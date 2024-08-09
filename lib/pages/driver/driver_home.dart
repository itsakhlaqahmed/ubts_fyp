import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final Map<String, String> allRoutes = {
    'Gulshan e Hadeed': 'hadeed',
    'Baldia Town': 'korangi',
    'North Nazimabad': 'nazimabad',
    'Steel Town': 'gulshan'
  };

  String? _selectedRoute;
  String? _direction;
  bool _showError = false;
  Map<UserData, dynamic> _userData = {};
  final AuthService _authService = AuthService();

  void _nextPage() {
    if (_selectedRoute != null) {
      // widget.onSelectRoute(allRoutes[_selectedRoute!]!);
      print('click');
      return;
    }
    setState(() {
      _showError = false;
    });
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
      decoration: BoxDecoration(),
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
                color:
                    //  isSelected
                    //     ? const Color.fromARGB(255, 253, 129, 59)
                    //     : Colors.black,
                    Colors.black,
              ),
              borderRadius: BorderRadius.circular(6),
              color:
                  // isSelected
                  //     ? const Color.fromARGB(70, 255, 144, 80)
                  //     : Colors.white,
                  Colors.white,
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
          Row(
            children: [
              Text(
                _userData[UserData.fullName] ?? 'null',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _signOut,
                icon: const Icon(Icons.exit_to_app_outlined),
              ),
            ],
          ),
          Text(
            _userData[UserData.studentId] ?? 'null',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  } // end _getTitleBar

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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 60,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 253, 129, 59)),
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
            ? const Color.fromARGB(70, 255, 144, 80)
            : Colors.white,
        height: 60,
        width: (MediaQuery.of(context).size.width - 66) / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _direction == direction.toLowerCase()
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.orange,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      : _getTitleBar(), //_getTitleBarSkeleton(),
                  const SizedBox(
                    height: 48,
                  ),
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
                    buttonText: 'Next',
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

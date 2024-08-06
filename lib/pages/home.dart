import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/home_map_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<UserData, dynamic> _userData = {};
  String _busId = 'smiu-hadeed';
  String _driverName = 'Mr. Amjad A';
  String _driverPhone = '0331-3284912';

  @override
  initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    Map<UserData, dynamic> userData =
        await PersistantStorage().fetchLocalUser();
    setState(() {
      _userData = userData;

      _isLoading = false;
    });
  }

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

  Widget _getSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[50],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 20,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.orange[50],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.orange[50],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Future.delayed(Duration(seconds: 2), () {
              print('refresh');
            });
            print('refresh');
          },
          // child: SingleChildScrollView(
          child: !_isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _userData[UserData.fullName] ?? 'null',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
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
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // HomeMapCard(
                    //   busId: _busId,
                    // ),
                    _getSkeletonLoader(),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        // height: 100,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 10, 25, 37),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Driver',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                        162, 139, 176, 205),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _driverName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      _driverPhone,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Text('data'),
          // ),
        ),
      ),
    );
  }
}

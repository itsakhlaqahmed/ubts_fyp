import 'package:flutter/material.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<User, String> userData = {};

  @override
  initState() {
    super.initState();
  }

  Future<Map<User, String>?> _fetchData() async {
    Map<User, String>? userData = await PersistantStorage().fetchLocalData();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    String fullName = 'Nigha';
    String studentId = 'BSE-21S-059';

    Widget content = Column(
      children: [
        Text(
          fullName,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: _fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading');
              }

              if (snapshot.hasError) {
                return const Text('error');
              }

              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              }

              return const Text('No Data');
            }),
      ),
    );
  }
}

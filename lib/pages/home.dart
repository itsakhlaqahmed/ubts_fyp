import 'package:flutter/material.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

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

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const SizedBox(
            height: 24,
          ),
          Text(
            fullName,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            studentId,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            height: 500,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          WideButton(onSubmitForm: () {}, buttonText: 'Full Map')
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
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

              return content;
            }),
      ),
    );
  }
}

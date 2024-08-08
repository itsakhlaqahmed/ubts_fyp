import 'package:flutter/material.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key, required this.busId});

  final String busId;

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Live Location Bus xx'),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BackButtonHandler extends StatefulWidget {
  const BackButtonHandler({super.key, required this.child});

  final Widget child;

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastBackPressTime;
  bool _canPop = false;

  bool? _onPopInvoked(_) {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      setState(() {
        _lastBackPressTime = now;
        _canPop = false;
      });
      print('1');
    }

    setState(() {
      _canPop = true;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvoked: _onPopInvoked,
      child: widget.child,
    );
  }
}

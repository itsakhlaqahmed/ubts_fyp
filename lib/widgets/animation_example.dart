import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimationExample extends StatefulWidget {
  const AnimationExample({super.key});
  @override
  State<StatefulWidget> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              effects: const [
                SlideEffect(
                  duration: Duration(milliseconds: 500),
                  begin: Offset(3, 0),
                  curve: Curves.easeOutExpo,
                )
              ],
              child: const Text('easeOutBack 1'),
            ),
            const SizedBox(
              height: 30,
            ),
            Animate(
              effects: const [
                SlideEffect(
                  duration: Duration(milliseconds: 500),
                  begin: Offset(3, 0),
                  curve: Curves.easeOutCubic,
                )
              ],
              child: const Text('easeOutCubic 3'),
            ),
            const SizedBox(
              height: 30,
            ),
            // Animate(
            //   effects: const [
            //     SlideEffect(
            //       duration: Duration(milliseconds: 250),
            //       begin: Offset(3, 0),
            //       curve: Curves.easeOutBack,
            //     )
            //   ],
            //   child: const Text('easeOutCubic 2'),
            // ),
          ],
        ),
      ),
    );
  }
}

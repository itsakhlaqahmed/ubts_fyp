import 'package:flutter/material.dart';

class SnackBarBuilder extends StatelessWidget {
  const SnackBarBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(240, 128, 19, 54),
              offset: Offset(1, 1),
              blurRadius: 8,
            ),
          ],
          color: Color.fromARGB(240, 128, 19, 54),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Oh Snap!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 4,),
            Spacer(),
            Text('There was some error while proccessing your request...'),
          ],
        ),
      ),
    );
  }
}

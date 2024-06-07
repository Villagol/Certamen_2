import 'package:flutter/material.dart';

class Fondo extends StatelessWidget {
  final Widget child;

  const Fondo({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoapp.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

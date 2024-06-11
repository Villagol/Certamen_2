import 'package:flutter/material.dart';

class Fondo extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  final Widget? drawer;

  const Fondo({
    required this.child,
    this.appBar,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoapp.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

// reglas_page.dart
import 'package:flutter/material.dart';

class ReglasPage extends StatelessWidget {
  final String nombreRegion;

  ReglasPage({required this.nombreRegion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reglas de $nombreRegion'),
      ),
      body: Center(
        child: Text('Aquí se muestran las reglas de $nombreRegion'),
      ),
    );
  }
}

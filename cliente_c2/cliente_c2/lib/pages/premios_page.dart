// premios_page.dart
import 'package:flutter/material.dart';

class PremiosPage extends StatelessWidget {
  final String nombreRegion;

  PremiosPage({required this.nombreRegion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premios de $nombreRegion'),
      ),
      body: Center(
        child: Text('Aquí se muestran los premios de $nombreRegion'),
      ),
    );
  }
}

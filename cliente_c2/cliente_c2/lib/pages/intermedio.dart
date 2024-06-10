import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/equipos_por_regiones_page.dart';

import 'package:cliente_c2/pages/reglas_page.dart';

class IntermedioPage extends StatelessWidget {
  final String nombreRegion;
  final int regionId;

  IntermedioPage({required this.nombreRegion, required this.regionId});

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú Principal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomElevatedButton(
              onPressed: () async {
                try {
                  List<dynamic> equipos =
                      await httpService.equiposPorRegion(regionId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EquiposPorRegionesPage(
                        equipos: equipos,
                        nombreRegion: nombreRegion,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error al cargar los equipos: $e');
                }
              },
              text: 'Ver Equipos de $nombreRegion',
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReglasPage(
                      regionId: regionId,
                    ),
                  ),
                );
              },
              text: 'Ver detalles de $nombreRegion',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomElevatedButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

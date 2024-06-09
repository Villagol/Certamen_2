import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/equipos_por_regiones_page.dart';
import 'package:cliente_c2/pages/premios_page.dart';
import 'package:cliente_c2/pages/reglas_page.dart';

class IntermedioPage extends StatelessWidget {
  final String nombreRegion;
  final int regionId; // Añade el ID de la región

  IntermedioPage({required this.nombreRegion, required this.regionId});

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intermedio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  // Obtener los equipos de la región seleccionada
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
              child: Text('Ver Equipos de $nombreRegion'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReglasPage(nombreRegion: nombreRegion),
                  ),
                );
              },
              child: Text('Ver Reglas de $nombreRegion'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PremiosPage(nombreRegion: nombreRegion),
                  ),
                );
              },
              child: Text('Ver Premios de $nombreRegion'),
            ),
          ],
        ),
      ),
    );
  }
}

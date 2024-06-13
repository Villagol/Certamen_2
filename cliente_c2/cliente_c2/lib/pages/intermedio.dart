import 'package:cliente_c2/widget/boton_intermedio.dart';
import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/pages/equipos_por_regiones_page.dart';
import 'package:cliente_c2/pages/reglas_page.dart';
import 'package:cliente_c2/widget/fondo.dart';
import 'package:cliente_c2/services/http_service.dart';

class IntermedioPage extends StatelessWidget {
  final String nombreRegion;
  final int regionId;

  IntermedioPage({required this.nombreRegion, required this.regionId});

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Fondo(
      appBar: AppBar(
        title: Text(
          'Menú Principal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BotonIntermedio(
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
            BotonIntermedio(
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

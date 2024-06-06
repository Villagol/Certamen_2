import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/detalles_jugadores_equipo_page.dart';

class EquiposPorRegionesPage extends StatelessWidget {
  final List<dynamic> equipos;
  final String nombreRegion;
  final HttpService httpService = HttpService();

  EquiposPorRegionesPage({
    required this.equipos,
    required this.nombreRegion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipos de la región $nombreRegion'),
      ),
      body: ListView.builder(
        itemCount: equipos.length,
        itemBuilder: (context, index) {
          var equipo = equipos[index];
          return ListTile(
            title: Text(equipo['nombre']),
            onTap: () async {
              var jugadores =
                  await httpService.obtenerJugadoresPorEquipo(equipo['id']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallesJugadoresEquipoPage(
                    jugadores: jugadores,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

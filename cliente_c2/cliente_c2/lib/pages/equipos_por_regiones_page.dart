import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/detalles_jugadores_equipo_page.dart';
import 'package:cliente_c2/widget/app_drawer.dart';

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
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: equipos.length,
        itemBuilder: (context, index) {
          var equipo = equipos[index];
          return ListTile(
            title: Text(equipo['nombre']),
            onTap: () async {
              // Obtener los jugadores del equipo seleccionado
              var jugadores =
                  await httpService.obtenerJugadoresPorEquipo(equipo['id']);
              // Navegar a la página DetallesJugadoresEquipoPage y pasar la lista de jugadores
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetallesJugadoresEquipoPage(jugadores: jugadores),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

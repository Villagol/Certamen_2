import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/detalles_jugadores_equipo_page.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';
import 'package:cliente_c2/pages/agregar_equipos.dart';
import 'package:cliente_c2/widget/borrar_equipo_page.dart';
import 'package:cliente_c2/widget/editar_equipo_page.dart';

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
    return Fondo(
      appBar: AppBar(
        title: Text(
          'Equipos de la región $nombreRegion',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: equipos.length,
              itemBuilder: (context, index) {
                var equipo = equipos[index];
                return ListTile(
                  title: Text(
                    equipo['nombre'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    'Entrenador: ' + equipo['entrenador'],
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    var jugadores = await httpService
                        .obtenerJugadoresPorEquipo(equipo['id']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetallesJugadoresEquipoPage(jugadores: jugadores),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarEquipoPage(equipoId: equipo['id']),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BorrarEquipoPage(
                                equipoId: equipo['id'],
                                nombreEquipo: equipo['nombre'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgregarEquipoPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

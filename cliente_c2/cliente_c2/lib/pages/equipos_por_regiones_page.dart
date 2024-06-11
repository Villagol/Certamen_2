import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/detalles_jugadores_equipo_page.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';
import 'package:cliente_c2/pages/agregar_equipos.dart';
import 'package:cliente_c2/pages/editar_equipo_page.dart';

class EquiposPorRegionesPage extends StatefulWidget {
  final List<dynamic> equipos;
  final String nombreRegion;

  EquiposPorRegionesPage({
    required this.equipos,
    required this.nombreRegion,
  });

  @override
  _EquiposPorRegionesPageState createState() => _EquiposPorRegionesPageState();
}

class _EquiposPorRegionesPageState extends State<EquiposPorRegionesPage> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Fondo(
      appBar: AppBar(
        title: Text(
          'Equipos de la región ${widget.nombreRegion}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.equipos.length,
              itemBuilder: (context, index) {
                var equipo = widget.equipos[index];
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
                          confirmarBorrado(
                              context, equipo['id'], equipo['nombre']);
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
              MaterialPageRoute ruta = MaterialPageRoute(
                builder: (context) => AgregarEquipoPage(),
              );
              Navigator.push(context, ruta).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  void confirmarBorrado(
      BuildContext context, int equipoId, String nombreEquipo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar borrado'),
          content: Text(
              '¿Estás seguro de que quieres borrar el equipo "$nombreEquipo"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Borrar'),
              onPressed: () async {
                try {
                  await httpService.borrarEquipo(equipoId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Equipo borrado con éxito')),
                  );
                  setState(() {
                    widget.equipos
                        .removeWhere((equipo) => equipo['id'] == equipoId);
                  });
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al borrar el equipo: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

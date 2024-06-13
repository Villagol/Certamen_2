import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';
import 'package:cliente_c2/pages/agregar_jugadores.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/pages/editar_jugador_page.dart';

class DetallesJugadoresEquipoPage extends StatefulWidget {
  final List<dynamic> jugadores;

  DetallesJugadoresEquipoPage({required this.jugadores});

  @override
  _DetallesJugadoresEquipoPageState createState() =>
      _DetallesJugadoresEquipoPageState();
}

class _DetallesJugadoresEquipoPageState
    extends State<DetallesJugadoresEquipoPage> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Jugadores del equipo', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF4355),
        actions: [],
      ),
      drawer: AppDrawer(),
      body: Fondo(
        child: ListView.builder(
          itemCount: widget.jugadores.length,
          itemBuilder: (context, index) {
            var jugador = widget.jugadores[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: ListTile(
                title: Text(
                  '${jugador['nombre']} ${jugador['apellido']}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nickname:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${jugador['nickname']}',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Agentes más jugados:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Agente 1:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${jugador['agente_1']}',
                        style: TextStyle(color: Colors.white)),
                    Text('Agente 2:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${jugador['agente_2']}',
                        style: TextStyle(color: Colors.white)),
                    Text('Agente 3:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${jugador['agente_3']}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarJugadorPage(
                              jugadorId: jugador['id'],
                              nombreActual: jugador['nombre'],
                              apellidoActual: jugador['apellido'],
                              nicknameActual: jugador['nickname'],
                              agente1Actual: jugador['agente_1'],
                              agente2Actual: jugador['agente_2'],
                              agente3Actual: jugador['agente_3'],
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {});
                            ();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        String? mensajeDeError =
                            await httpService.borrarJugador(jugador['id']);
                        if (mensajeDeError == null) {
                          setState(() {
                            widget.jugadores.removeWhere(
                                (element) => element['id'] == jugador['id']);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Jugador borrado con éxito')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Error al borrar el jugador: $mensajeDeError')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarJugadores(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        backgroundColor: Color(0xFFFF4355),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked, // Posición del botón flotante
    );
  }
}

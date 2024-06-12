import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';
import 'package:cliente_c2/pages/agregar_jugadores.dart';
import 'package:cliente_c2/services/http_service.dart'; // Importar el servicio HTTP

class DetallesJugadoresEquipoPage extends StatefulWidget {
  final List<dynamic> jugadores;

  DetallesJugadoresEquipoPage({required this.jugadores});

  @override
  _DetallesJugadoresEquipoPageState createState() =>
      _DetallesJugadoresEquipoPageState();
}

class _DetallesJugadoresEquipoPageState
    extends State<DetallesJugadoresEquipoPage> {
  final HttpService httpService = HttpService(); // Instancia del servicio HTTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Jugadores del equipo', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF4355),
        actions: [
          IconButton(
            icon: Icon(Icons.add), // Icono de añadir
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AgregarJugadores(), // Navegar a la página para agregar jugadores
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Fondo(
        // Utilizar el widget de fondo
        child: ListView.builder(
          itemCount: widget.jugadores.length,
          itemBuilder: (context, index) {
            var jugador = widget.jugadores[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Color de fondo con transparencia
                borderRadius:
                    BorderRadius.circular(10), // Bordes redondeados de la caja
                border:
                    Border.all(color: Colors.white, width: 1), // Borde blanco
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
                    SizedBox(height: 4), // Espacio entre los elementos
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
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    String? mensajeDeError =
                        await HttpService().borrarJugador(jugador['id']);
                    if (mensajeDeError == null) {
                      setState(() {
                        widget.jugadores.removeWhere(
                            (element) => element['id'] == jugador['id']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jugador borrado con éxito')),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

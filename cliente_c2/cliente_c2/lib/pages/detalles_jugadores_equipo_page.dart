import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';

class DetallesJugadoresEquipoPage extends StatelessWidget {
  final List<dynamic> jugadores;

  DetallesJugadoresEquipoPage({required this.jugadores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores del equipo'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: jugadores.length,
        itemBuilder: (context, index) {
          var jugador = jugadores[index];
          return ListTile(
            title: Text('${jugador['nombre']} ${jugador['apellido']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nickname: ${jugador['nickname']}'),
                Text('Agentes más jugados:'),
                Text('Agente 1: ${jugador['agente_1']}'),
                Text('Agente 2: ${jugador['agente_2']}'),
                Text('Agente 3: ${jugador['agente_3']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

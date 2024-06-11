import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart'; // Importar el widget de fondo

class DetallesJugadoresEquipoPage extends StatelessWidget {
  final List<dynamic> jugadores;

  DetallesJugadoresEquipoPage({required this.jugadores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Jugadores del equipo', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: Fondo(
        // Utilizar el widget de fondo
        child: ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            var jugador = jugadores[index];
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16), // Margen alrededor de cada jugador
              padding:
                  EdgeInsets.all(8), // Espacio interno dentro de cada jugador
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Color de fondo con transparencia
                borderRadius:
                    BorderRadius.circular(10), // Bordes redondeados de la caja
                border:
                    Border.all(color: Colors.white, width: 1), // Borde blanco
              ),
              child: ListTile(
                title: Text('${jugador['nombre']} ${jugador['apellido']}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nickname:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)), // Texto en negrita
                    Text('${jugador['nickname']}',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 4), // Espacio entre los elementos
                    Text('Agentes más jugados:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)), // Texto en negrita
                    Text('Agente 1:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)), // Texto en negrita
                    Text('${jugador['agente_1']}',
                        style: TextStyle(color: Colors.white)),
                    Text('Agente 2:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)), // Texto en negrita
                    Text('${jugador['agente_2']}',
                        style: TextStyle(color: Colors.white)),
                    Text('Agente 3:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${jugador['agente_3']}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

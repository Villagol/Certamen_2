import 'package:cliente_c2/widget/jugadores_tile.dart';
import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores'),
      ),
      body: FutureBuilder(
        future: httpService.jugadores(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            List<dynamic> jugadoresList = snapshot.data!;

            return ListView.builder(
              itemCount: jugadoresList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> jugador = jugadoresList[index];

                return JugadoresTile(
                  nombre: jugador['nombre'],
                  apellido: jugador['apellido'],
                  nickname: jugador['nickname'],
                  agente1: jugador['agente_1'],
                  agente2: jugador['agente_2'],
                  agente3: jugador['agente_3'],
                  nombreEquipo: jugador['equipo']['nombre'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

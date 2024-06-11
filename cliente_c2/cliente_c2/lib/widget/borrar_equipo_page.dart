import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class BorrarEquipoPage extends StatelessWidget {
  final int equipoId;
  final String nombreEquipo; // Nuevo campo para el nombre del equipo
  final HttpService httpService = HttpService();

  BorrarEquipoPage({
    required this.equipoId,
    required this.nombreEquipo, // Añadido el nombre del equipo
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrar Equipo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿Estás seguro de que quieres borrar el equipo "$nombreEquipo"?',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Lógica para borrar el equipo con ID equipoId
                // Utiliza el método borrarEquipo del servicio HTTP
                try {
                  await httpService.borrarEquipo(equipoId);
                  Navigator.pop(context, true); // Equipo borrado con éxito
                } catch (e) {
                  print('Error al borrar el equipo: $e');
                  Navigator.pop(context, false); // Error al borrar el equipo
                }
              },
              child: Text('Borrar'),
            ),
          ],
        ),
      ),
    );
  }
}

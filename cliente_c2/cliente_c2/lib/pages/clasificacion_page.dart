import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/fondo.dart';

class ClasificacionPage extends StatefulWidget {
  @override
  _ClasificacionPageState createState() => _ClasificacionPageState();
}

class _ClasificacionPageState extends State<ClasificacionPage> {
  final HttpService httpService = HttpService();
  List<dynamic> equipos =
      []; // Lista para almacenar todos los equipos con puntos

  @override
  void initState() {
    super.initState();
    _cargarEquiposConPuntos();
  }

  Future<void> _cargarEquiposConPuntos() async {
    try {
      equipos = await httpService.obtenerTodosLosEquiposConPuntos();
      setState(() {}); // Actualizar la UI después de obtener los equipos
    } catch (e) {
      print('Error al obtener equipos: $e');
      // Manejo de errores si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Fondo(
      appBar: AppBar(
        title: Text(
          'Clasificación de Equipos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      child: _buildEquiposList(),
    );
  }

  Widget _buildEquiposList() {
    return ListView.builder(
      itemCount: equipos.length,
      itemBuilder: (context, index) {
        var equipo = equipos[index];
        return ListTile(
          title: Text(
            equipo['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            'Entrenador: ${equipo['entrenador']}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            'Puntos: ${equipo['puntos'] ?? ''}', // Asegúrate de manejar el caso donde puntos pueden ser null
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

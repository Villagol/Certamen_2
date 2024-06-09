import 'package:flutter/material.dart';

import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/app_drawer.dart';

class CalendarioPage extends StatefulWidget {
  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late List<dynamic> _encuentros = [];
  final HttpService _httpService = HttpService();

  @override
  void initState() {
    super.initState();
    _cargarEncuentros();
  }

  Future<void> _cargarEncuentros() async {
    try {
      final encuentros = await _httpService.obtenerEncuentrosEquipos();
      setState(() {
        _encuentros = encuentros;
      });
    } catch (e) {
      print('Error al cargar los encuentros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Encuentros'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _encuentros.length,
        itemBuilder: (context, index) {
          final encuentro = _encuentros[index];
          return ListTile(
            title: Text(
              '${encuentro["nombre_equipo_local"]} vs ${encuentro["nombre_equipo_visitante"]}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resultado: ${encuentro["resultado"]}'),
                Text('Mapa: ${encuentro["mapa"]}'),
                Text('Hora: ${encuentro["hora"]}'),
                Text('Fecha: ${encuentro["fecha"]}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

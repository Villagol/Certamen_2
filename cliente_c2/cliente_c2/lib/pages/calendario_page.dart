import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';

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
    return Fondo(
      appBar: AppBar(
          title: Text(
            'Calendario de Encuentros',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFFF4355)),
      drawer: AppDrawer(),
      child: ListView.builder(
        itemCount: _encuentros.length,
        itemBuilder: (context, index) {
          final encuentro = _encuentros[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  '${encuentro["nombre_equipo_local"]} vs ${encuentro["nombre_equipo_visitante"]}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado: ${encuentro["resultado"]}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text('Mapa: ${encuentro["mapa"]}',
                        style: TextStyle(color: Colors.white)),
                    Text('Hora: ${encuentro["hora"]}',
                        style: TextStyle(color: Colors.white)),
                    Text('Fecha: ${encuentro["fecha"]}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

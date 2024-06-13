import 'package:flutter/material.dart';
import 'package:cliente_c2/pages/crear_encuentro_page.dart';
import 'package:cliente_c2/pages/editar_encuentro_page.dart'; 
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

  Future<void> _eliminarEncuentro(int idEncuentro) async {
    try {
      await _httpService.eliminarEncuentro(idEncuentro);
      _cargarEncuentros(); 
    } catch (e) {
      print('Error al eliminar el encuentro: $e');
    }
  }

  Future<void> _editarEncuentro(dynamic encuentro) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEncuentroPage(
          encuentro: encuentro,
        ),
      ),
    );
  }

  Future<void> _editarResultadoEncuentro(
      int encuentroId, String nuevoResultado) async {
    try {
      await _httpService.editarResultadoEncuentro(encuentroId, nuevoResultado);
      _cargarEncuentros();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Resultado del encuentro actualizado correctamente'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al actualizar resultado del encuentro'),
        duration: Duration(seconds: 2),
      ));
      print('Error al actualizar resultado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendario de Encuentros',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: Fondo(
        child: ListView.builder(
          itemCount: _encuentros.length,
          itemBuilder: (context, index) {
            final encuentro = _encuentros[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    'Encuentro ${encuentro["id"]}: ${encuentro["nombre_equipo_local"]} vs ${encuentro["nombre_equipo_visitante"]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resultado: ${encuentro["resultado"]}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Mapa: ${encuentro["mapa"]}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Hora: ${encuentro["hora"]}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Fecha: ${encuentro["fecha"]}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _editarEncuentro(encuentro);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _eliminarEncuentro(encuentro['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_attributes, color: Colors.black),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildEditarResultadoDialog(
                                context, encuentro['id']),
                          );
                        },
                      ),
                    ],
                  ),
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
            MaterialPageRoute(builder: (context) => CrearEncuentroPage()),
          ).then((value) {
            _cargarEncuentros();
          });
        },
        backgroundColor: Color(0xFFFF4355),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEditarResultadoDialog(BuildContext context, int encuentroId) {
    TextEditingController resultadoController = TextEditingController();

    return AlertDialog(
      title: Text('Editar Resultado'),
      content: TextField(
        controller: resultadoController,
        decoration: InputDecoration(
          hintText: 'Nuevo resultado',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _editarResultadoEncuentro(encuentroId, resultadoController.text);
            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}

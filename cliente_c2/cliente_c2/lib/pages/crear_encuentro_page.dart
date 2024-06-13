import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';

class CrearEncuentroPage extends StatefulWidget {
  @override
  _CrearEncuentroPageState createState() => _CrearEncuentroPageState();
}

class _CrearEncuentroPageState extends State<CrearEncuentroPage> {
  final TextEditingController _resultadoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  String? _equipoLocal;
  String? _equipoVisitante;
  String? _mapa;

  final HttpService _httpService = HttpService();

  List<String> _equiposLocales = [];
  List<String> _equiposVisitantes = [];
  List<String> _mapas = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      _equiposLocales = await _httpService.obtenerEquipos();
      _equiposVisitantes = await _httpService.obtenerEquipos();
      _mapas = await _httpService.obtenerMapas();

      setState(() {});
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> items) {
    return items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Encuentro de Equipo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: Fondo(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: _equipoLocal,
              onChanged: (String? newValue) {
                setState(() {
                  _equipoLocal = newValue;
                });
              },
              items: _buildDropdownItems(_equiposLocales),
              decoration: InputDecoration(
                labelText: 'Equipo Local',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              value: _equipoVisitante,
              onChanged: (String? newValue) {
                setState(() {
                  _equipoVisitante = newValue;
                });
              },
              items: _buildDropdownItems(_equiposVisitantes),
              decoration: InputDecoration(
                labelText: 'Equipo Visitante',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              value: _mapa,
              onChanged: (String? newValue) {
                setState(() {
                  _mapa = newValue;
                });
              },
              items: _buildDropdownItems(_mapas),
              decoration: InputDecoration(
                labelText: 'Mapa',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              controller: _resultadoController,
              decoration: InputDecoration(
                labelText: 'Resultado',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _crearEncuentroEquipo,
              child: Text('Crear Encuentro de Equipo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearEncuentroEquipo() async {
    try {
      final nuevoEncuentroEquipo = {
        'nombre_equipo_local': _equipoLocal,
        'nombre_equipo_visitante': _equipoVisitante,
        'resultado': _resultadoController.text,
        'mapa': _mapa,
        'fecha': _fechaController.text,
      };
      await _httpService.crearEncuentroEquipo(nuevoEncuentroEquipo);
      Navigator.pop(context); // Regresar a la página anterior
    } catch (e) {
      print('Error al crear el encuentro de equipo: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error al crear el encuentro de equipo: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

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

  List<Widget> _buildSelectedItems(List<String> items) {
    return items.map<Widget>((String value) {
      return Text(
        value,
        style: TextStyle(
            color: Colors.white), // Color del texto cuando está seleccionado
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Encuentro',
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
              selectedItemBuilder: (BuildContext context) {
                return _buildSelectedItems(_equiposLocales);
              },
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
              selectedItemBuilder: (BuildContext context) {
                return _buildSelectedItems(_equiposVisitantes);
              },
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
              selectedItemBuilder: (BuildContext context) {
                return _buildSelectedItems(_mapas);
              },
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
            TextField(
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
              onPressed: _crearEncuentro,
              child: Text('Crear Encuentro'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearEncuentro() async {
    try {
      final nuevoEncuentro = {
        'equipo_local': _equipoLocal,
        'equipo_visitante': _equipoVisitante,
        'resultado': _resultadoController.text,
        'mapa': _mapa,
        'fecha':
            _fechaController.text.isNotEmpty ? _fechaController.text : null,
      };
      await _httpService.crearEncuentro(nuevoEncuentro);
      Navigator.pop(context); // Regresar a la página anterior
    } catch (e) {
      print('Error al crear el encuentro: $e');
    }
  }
}

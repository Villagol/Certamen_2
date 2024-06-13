import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';

class EditarEquipoPage extends StatefulWidget {
  final int equipoId;
  final String nombreActual;
  final String entrenadorActual;
  final int regionIdActual;

  EditarEquipoPage({
    required this.equipoId,
    required this.nombreActual,
    required this.entrenadorActual,
    required this.regionIdActual,
  });

  @override
  _EditarEquipoPageState createState() => _EditarEquipoPageState();
}

class _EditarEquipoPageState extends State<EditarEquipoPage> {
  final HttpService _httpService = HttpService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _entrenadorController;
  int? _regionSeleccionada;
  List<String> _regiones = ['Americas', 'EMEA', 'China'];
  Map<String, int> _regionMap = {
    'Americas': 1,
    'EMEA': 2,
    'China': 3,
  };

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreActual);
    _entrenadorController =
        TextEditingController(text: widget.entrenadorActual);
    _regionSeleccionada = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Equipo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: Fondo(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Equipo',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre del equipo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _entrenadorController,
                  decoration: InputDecoration(
                    labelText: 'Entrenador',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre del entrenador';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _regionSeleccionada,
                  items: _buildDropdownItems(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _regionSeleccionada = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Región',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor selecciona la región';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _editarEquipo();
                    }
                  },
                  child: Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    List<DropdownMenuItem<int>> items = [];
    items.add(
      DropdownMenuItem<int>(
        value: null,
        child: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
    _regiones.forEach((region) {
      items.add(
        DropdownMenuItem<int>(
          value: _regionMap[region],
          child: Text(
            region,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    });
    return items;
  }

  Future<void> _editarEquipo() async {
    try {
      final equipoData = {
        'nombre': _nombreController.text,
        'entrenador': _entrenadorController.text,
        'region_id': _regionSeleccionada,
      };
      await _httpService.editarEquipo(widget.equipoId, equipoData);
      Navigator.pop(context, true);
    } catch (e) {
      print('Error al editar el equipo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar el equipo: $e')),
      );
    }
  }
}

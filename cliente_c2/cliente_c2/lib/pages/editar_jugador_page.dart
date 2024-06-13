import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/fondo.dart';

class EditarJugadorPage extends StatefulWidget {
  final int jugadorId;
  final String nombreActual;
  final String apellidoActual;
  final String nicknameActual;
  final String agente1Actual;
  final String agente2Actual;
  final String agente3Actual;

  EditarJugadorPage({
    required this.jugadorId,
    required this.nombreActual,
    required this.apellidoActual,
    required this.nicknameActual,
    required this.agente1Actual,
    required this.agente2Actual,
    required this.agente3Actual,
  });

  @override
  _EditarJugadorPageState createState() => _EditarJugadorPageState();
}

class _EditarJugadorPageState extends State<EditarJugadorPage> {
  final HttpService _httpService = HttpService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _nicknameController;
  late TextEditingController _agente1Controller;
  late TextEditingController _agente2Controller;
  late TextEditingController _agente3Controller;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreActual);
    _apellidoController = TextEditingController(text: widget.apellidoActual);
    _nicknameController = TextEditingController(text: widget.nicknameActual);
    _agente1Controller = TextEditingController(text: widget.agente1Actual);
    _agente2Controller = TextEditingController(text: widget.agente2Actual);
    _agente3Controller = TextEditingController(text: widget.agente3Actual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Jugador', style: TextStyle(color: Colors.white)),
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
                    labelText: 'Nombre',
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
                      return 'Por favor ingresa el nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
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
                      return 'Por favor ingresa el apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Nickname',
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
                      return 'Por favor ingresa el nickname';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _agente1Controller,
                  decoration: InputDecoration(
                    labelText: 'Agente 1',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _agente2Controller,
                  decoration: InputDecoration(
                    labelText: 'Agente 2',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _agente3Controller,
                  decoration: InputDecoration(
                    labelText: 'Agente 3',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _editarJugador();
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

  Future<void> _editarJugador() async {
    try {
      final jugadorData = {
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'nickname': _nicknameController.text,
        'agente_1': _agente1Controller.text,
        'agente_2': _agente2Controller.text,
        'agente_3': _agente3Controller.text,
      };
      await _httpService.editarJugador(widget.jugadorId, jugadorData);
      Navigator.pop(context, true);
    } catch (e) {
      print('Error al editar el jugador: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar el jugador: $e')),
      );
    }
  }
}

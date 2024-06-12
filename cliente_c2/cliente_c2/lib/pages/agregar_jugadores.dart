// Código de Flutter con la comparación del nombre del equipo seleccionado con la lista de IDs

import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class AgregarJugadores extends StatefulWidget {
  const AgregarJugadores({Key? key}) : super(key: key);

  @override
  State<AgregarJugadores> createState() => _AgregarJugadoresState();
}

class _AgregarJugadoresState extends State<AgregarJugadores> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController agente1Controller = TextEditingController();
  TextEditingController agente2Controller = TextEditingController();
  TextEditingController agente3Controller = TextEditingController();
  String? equipoSeleccionado;

  final formKey = GlobalKey<FormState>();

  String errorMessage = "";

  // Lista de correspondencia entre nombres de equipos y sus IDs
  final Map<String, String> equipos = {
    "KRÜ Visa": "1",
    "Cloud 9": "2",
    "G2 Esports": "3",
    "Sentinels": "4",
    "NRG": "5",
    "Fut Esports": "6",
    "Team Heretics": "7",
    "Fnatic": "8",
    "Natus Vincere": "9",
    "Karmine Corp": "10",
    "EDward Gaming": "11",
    "Dragon Ranger Gaming": "12",
    "Nova Esports": "13",
    "FunPlus Phoenix": "14",
    "All Gamers": "15",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Jugador'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                controller: apellidoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nickname'),
                controller: nicknameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nickname';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Agente 1'),
                controller: agente1Controller,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Agente 2'),
                controller: agente2Controller,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Agente 3'),
                controller: agente3Controller,
              ),
              FutureBuilder<List<String>>(
                future: HttpService().obtenerEquipos(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> equiposNombres = snapshot.data ?? [];

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Equipo'),
                      value: equipoSeleccionado,
                      items: equiposNombres
                          .map<DropdownMenuItem<String>>((equipoNombre) {
                        return DropdownMenuItem<String>(
                          child: Text(equipoNombre),
                          value: equipoNombre,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          equipoSeleccionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona el equipo';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    errorMessage = "";
                  });

                  if (formKey.currentState!.validate()) {
                    String? equipoId = equipos[equipoSeleccionado!];

                    if (equipoId == null) {
                      setState(() {
                        errorMessage =
                            'Error: no se encontró el ID del equipo seleccionado';
                      });
                      return;
                    }

                    var respuesta = await HttpService().agregarJugador(
                      nombreController.text,
                      apellidoController.text,
                      nicknameController.text,
                      agente1Controller.text,
                      agente2Controller.text,
                      agente3Controller.text,
                      equipoId,
                    );

                    if (respuesta['success'] != null && respuesta['success']) {
                      Navigator.pop(context, true);
                    } else if (respuesta['error'] != null) {
                      setState(() {
                        errorMessage = respuesta['error'].toString();
                      });
                    } else {
                      setState(() {
                        errorMessage = "Error desconocido al agregar jugador";
                      });
                    }
                  }
                },
                child: Text('Agregar Jugador'),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class AgregarEquipoPage extends StatefulWidget {
  const AgregarEquipoPage({Key? key}) : super(key: key);

  @override
  State<AgregarEquipoPage> createState() => _AgregarEquipoPageState();
}

class _AgregarEquipoPageState extends State<AgregarEquipoPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController entrenadorController = TextEditingController();
  String? regionSeleccionada;

  final formKey = GlobalKey<FormState>();

  String errNombre = "";
  String errEntrenador = "";
  String errRegion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Equipo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Equipo'),
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del equipo';
                  }
                  return null;
                },
              ),
              Text(errNombre, style: TextStyle(color: Colors.red)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Entrenador'),
                controller: entrenadorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del entrenador';
                  }
                  return null;
                },
              ),
              Text(errEntrenador, style: TextStyle(color: Colors.red)),
              FutureBuilder<List<String>>(
                future: HttpService().obtenerRegiones(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> regiones = snapshot.data ?? [];

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Región'),
                      value: regionSeleccionada,
                      items: regiones.map<DropdownMenuItem<String>>((region) {
                        return DropdownMenuItem<String>(
                          child: Text(region),
                          value: region,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          regionSeleccionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona la región';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              Text(errRegion, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var respuesta = await HttpService().agregarEquipo(
                      nombreController.text,
                      entrenadorController.text,
                      regionSeleccionada!,
                    );

                    if (respuesta['message'] != null) {
                      var errores = respuesta['errors'];
                      setState(() {
                        errNombre = errores['nombre'] != null
                            ? errores['nombre'][0]
                            : '';
                        errEntrenador = errores['entrenador'] != null
                            ? errores['entrenador'][0]
                            : '';
                        errRegion = errores['region'] != null
                            ? errores['region'][0]
                            : '';
                      });
                    } else {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: Text('Agregar Equipo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

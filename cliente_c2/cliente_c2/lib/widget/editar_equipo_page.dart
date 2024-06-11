import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class EditarEquipoPage extends StatefulWidget {
  final int equipoId;

  EditarEquipoPage({
    required this.equipoId,
  });

  @override
  _EditarEquipoPageState createState() => _EditarEquipoPageState();
}

class _EditarEquipoPageState extends State<EditarEquipoPage> {
  final HttpService httpService = HttpService();
  TextEditingController nombreController = TextEditingController();
  TextEditingController entrenadorController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarDatosEquipo();
  }

  Future<void> cargarDatosEquipo() async {
    setState(() {
      isLoading = true;
    });
    try {
      var equipo = await httpService.obtenerEquipoPorId(widget.equipoId);
      nombreController.text = equipo['nombre'];
      entrenadorController.text = equipo['entrenador'];
    } catch (e) {
      print('Error al cargar los datos del equipo: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Equipo'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre del Equipo:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el nombre del equipo',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nombre del Entrenador:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(
                    controller: entrenadorController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el nombre del entrenador',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await httpService.actualizarEquipo(
                          widget.equipoId,
                          nombreController.text,
                          entrenadorController.text,
                        );
                        // Mostrar mensaje de éxito
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Equipo actualizado correctamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Volver a la página anterior
                        Navigator.pop(context);
                      } catch (e) {
                        // Mostrar mensaje de error si falla la actualización
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al actualizar el equipo: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:cliente_c2/services/http_service.dart';
import 'package:flutter/material.dart';

class EditarEncuentroPage extends StatefulWidget {
  final dynamic encuentro;

  EditarEncuentroPage({required this.encuentro});

  @override
  _EditarEncuentroPageState createState() => _EditarEncuentroPageState();
}

class _EditarEncuentroPageState extends State<EditarEncuentroPage> {
  final HttpService _httpService = HttpService();
  late TextEditingController _fechaController;
  late TextEditingController _horaController;

  @override
  void initState() {
    super.initState();

    _fechaController = TextEditingController(text: widget.encuentro['fecha']);
    _horaController = TextEditingController(text: widget.encuentro['hora']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Encuentro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: 'Fecha (dd/mm/yyyy)'),
            ),
            TextField(
              controller: _horaController,
              decoration: InputDecoration(labelText: 'Hora (hh:mm)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final encuentroId = widget.encuentro['id'];
                  final nuevaFecha = _fechaController.text;
                  final nuevaHora = _horaController.text;

                  await _httpService.editarFechaHoraEncuentro(
                      encuentroId, nuevaFecha, nuevaHora);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Fecha y hora del encuentro actualizados correctamente'),
                    duration: Duration(seconds: 2),
                  ));

                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Error al actualizar la fecha y hora del encuentro: $e'),
                    duration: Duration(seconds: 2),
                  ));
                  print('Error: $e');
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

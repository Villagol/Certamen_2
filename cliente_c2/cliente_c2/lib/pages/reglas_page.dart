import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cliente_c2/services/http_service.dart';

class ReglasPage extends StatefulWidget {
  final int regionId;

  ReglasPage({required this.regionId});

  @override
  _ReglasPageState createState() => _ReglasPageState();
}

class _ReglasPageState extends State<ReglasPage> {
  final HttpService httpService = HttpService();
  late Future<Map<String, dynamic>> regionFuture;

  @override
  void initState() {
    super.initState();
    regionFuture = httpService.obtenerRegionPorId(widget.regionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reglas de la region',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF4355),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: regionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final region = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre de la región: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${region['nombre']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Reglas de la región:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${region['reglas']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Fechas donde se juega:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${region['fechas']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Premios:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${region['premios']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 24),
                  Image.asset(
                    'assets/images/copa.jpg',
                    width: 300,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Copa para los campeones',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

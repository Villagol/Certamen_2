import 'package:flutter/material.dart';
import 'package:cliente_c2/pages/equipos_por_regiones_page.dart';
import 'package:cliente_c2/services/http_service.dart';

class RegionesPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regiones'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              List<dynamic> equipos = await httpService.equiposPorRegion(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EquiposPorRegionesPage(
                    equipos: equipos,
                    nombreRegion: 'Americas',
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/vctamericas.png',
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              List<dynamic> equipos = await httpService.equiposPorRegion(2);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EquiposPorRegionesPage(
                    equipos: equipos,
                    nombreRegion: 'EMEA',
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/vctemea.png',
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              List<dynamic> equipos = await httpService.equiposPorRegion(3);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EquiposPorRegionesPage(
                    equipos: equipos,
                    nombreRegion: 'China',
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/vctchina.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/region_button.dart';
import 'package:cliente_c2/pages/equipos_por_regiones_page.dart';
import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/fondo.dart'; // Importa el widget Fondo

class RegionesPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Fondo(
      // Utiliza el widget Fondo para aplicar la imagen de fondo
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Regiones',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor:
              Color(0xFFFF4355), // Cambia el color del AppBar a #FF4355
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RegionButton(
                imagePath: 'assets/images/vctamericas.png',
                onTap: () async {
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
              ),
              SizedBox(height: 20),
              RegionButton(
                imagePath: 'assets/images/vctemea.png',
                onTap: () async {
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
              ),
              SizedBox(height: 20),
              RegionButton(
                imagePath: 'assets/images/vctchina.png',
                onTap: () async {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

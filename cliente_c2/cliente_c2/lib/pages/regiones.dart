import 'package:cliente_c2/pages/intermedio.dart';
import 'package:flutter/material.dart';
import 'package:cliente_c2/widget/app_drawer.dart';
import 'package:cliente_c2/widget/region_button.dart';

import 'package:cliente_c2/services/http_service.dart';
import 'package:cliente_c2/widget/fondo.dart';

class RegionesPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Fondo(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Regiones',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFFF4355),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntermedioPage(
                        nombreRegion: 'Americas',
                        regionId: 1,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              RegionButton(
                imagePath: 'assets/images/vctemea.png',
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntermedioPage(
                        nombreRegion: 'EMEA',
                        regionId: 2,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              RegionButton(
                imagePath: 'assets/images/vctchina.png',
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntermedioPage(
                        nombreRegion: 'China',
                        regionId: 3,
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

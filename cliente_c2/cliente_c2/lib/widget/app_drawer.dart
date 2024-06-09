import 'package:cliente_c2/pages/calendario_page.dart';
import 'package:cliente_c2/pages/clasificacion_page.dart';
import 'package:cliente_c2/pages/regiones.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFF4355),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(MdiIcons.map),
              title: Text('Regiones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegionesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.calendar),
              title: Text('Calendario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarioPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Clasificación'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClasificacionPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cliente_c2/pages/regiones.dart';
import 'package:flutter/material.dart';

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
              leading: Icon(Icons.map),
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
              leading: Icon(Icons.calendar_today),
              title: Text('Calendario'),
              onTap: () {
                Navigator.pushNamed(context, '/calendario');
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Clasificación'),
              onTap: () {
                Navigator.pushNamed(context, '/clasificacion');
              },
            ),
          ],
        ),
      ),
    );
  }
}

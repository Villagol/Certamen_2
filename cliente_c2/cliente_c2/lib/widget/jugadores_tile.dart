import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JugadoresTile extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String nickname;
  final String agente1;
  final String agente2;
  final String agente3;
  final String nombreEquipo;

  JugadoresTile({
    required this.nombre,
    required this.apellido,
    required this.nickname,
    required this.agente1,
    required this.agente2,
    required this.agente3,
    required this.nombreEquipo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 1),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xDDFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$nombre ',
                    style: GoogleFonts.oxanium(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    apellido,
                    style: GoogleFonts.oxanium(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Nickname: $nickname',
                style: GoogleFonts.oxanium(
                  textStyle: TextStyle(fontSize: 11),
                ),
              ),
              Text(
                'Agente 1: $agente1',
                style: GoogleFonts.oxanium(
                  textStyle: TextStyle(fontSize: 11),
                ),
              ),
              Text(
                'Agente 2: $agente2',
                style: GoogleFonts.oxanium(
                  textStyle: TextStyle(fontSize: 11),
                ),
              ),
              Text(
                'Agente 3: $agente3',
                style: GoogleFonts.oxanium(
                  textStyle: TextStyle(fontSize: 11),
                ),
              ),
              Text(
                'Equipo: $nombreEquipo',
                style: GoogleFonts.oxanium(
                  textStyle: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}

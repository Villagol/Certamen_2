import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> jugadores() async {
    return listarDatos('jugadores');
  }

  Future<List<dynamic>> regiones() async {
    return listarDatos('regiones');
  }

  Future<List<dynamic>> equipos() async {
    return listarDatos('equipos');
  }

  Future<List<dynamic>> listarDatos(String coleccion) async {
    var respuesta = await http.get(Uri.parse(apiUrl + '/' + coleccion));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    }
    print(respuesta.statusCode);
    return [];
  }

  Future<List<dynamic>> equiposPorRegion(int idRegion) async {
    var respuesta =
        await http.get(Uri.parse('$apiUrl/equipos?region_id=$idRegion'));
    if (respuesta.statusCode == 200) {
      List<dynamic> equipos = json.decode(respuesta.body);
      equipos =
          equipos.where((equipo) => equipo['region_id'] == idRegion).toList();
      return equipos;
    }
    print(respuesta.statusCode);
    return [];
  }

  Future<List<dynamic>> obtenerJugadoresPorEquipo(int idEquipo) async {
    var respuesta = await http.get(Uri.parse('$apiUrl/jugadores'));
    if (respuesta.statusCode == 200) {
      List<dynamic> jugadores = json.decode(respuesta.body);
      jugadores = jugadores
          .where((jugador) => jugador['equipo']['id'] == idEquipo)
          .toList();
      return jugadores;
    }
    print(respuesta.statusCode);
    return [];
  }

  Future<List<dynamic>> obtenerEncuentrosEquipos() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/encuentro_equipos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load encounters');
      }
    } catch (e) {
      throw Exception('Error fetching encounters: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerRegionPorId(int regionId) async {
    final response = await http.get(Uri.parse('$apiUrl/regiones/$regionId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar la región');
    }
  }
}

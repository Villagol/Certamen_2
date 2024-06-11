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

  Future<void> borrarEquipo(int equipoId) async {
    // Endpoint para borrar un equipo
    final String url = '$apiUrl/equipos/$equipoId';

    try {
      // Realizar la solicitud DELETE
      final response = await http.delete(Uri.parse(url));

      // Verificar si la solicitud fue exitosa
      if (response.statusCode == 200) {
        // Equipo borrado exitosamente
        print('Equipo borrado exitosamente');
      } else {
        // Hubo un error al borrar el equipo
        throw Exception('Error al borrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      // Capturar y manejar cualquier error
      print('Error al borrar el equipo: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> obtenerEquipoPorId(int equipoId) async {
    final response = await http.get(Uri.parse('$apiUrl/equipos/$equipoId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el equipo con ID $equipoId');
    }
  }

  Future<void> editarEquipo(
      int equipoId, Map<String, dynamic> nuevoEquipo, String apiUrl) async {
    final String url = '$apiUrl/equipos/$equipoId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nuevoEquipo),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al editar el equipo con ID $equipoId');
      }
    } catch (e) {
      throw Exception('Error al editar el equipo: $e');
    }
  }

  Future<Map<String, dynamic>> agregarEquipo(
      String nombre, String entrenador, String region) async {
    try {
      Map<String, int> regiones = {
        'Americas': 1,
        'EMEA': 2,
        'China': 3,
      };

      if (!regiones.containsKey(region)) {
        return {'success': false, 'error': 'Región no válida'};
      }

      int regionId = regiones[region]!;

      var url = Uri.parse('$apiUrl/equipos');

      print('Datos a enviar:');
      print('Nombre: $nombre');
      print('Entrenador: $entrenador');
      print('Región: $regionId');
      print(jsonDecode);

      var respuesta = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nombre': nombre,
          'entrenador': entrenador,
          'region_id': regionId,
        }),
      );

      if (respuesta.statusCode == 201) {
        var nuevoEquipo = json.decode(respuesta.body);
        return {'success': true, 'equipo': nuevoEquipo};
      } else {
        var error = json.decode(respuesta.body);
        return {'success': false, 'error': error};
      }
    } catch (error) {
      print('Error al agregar equipo: $error');
      return {'success': false, 'error': 'Error al agregar equipo'};
    }
  }

  Future<Map<String, dynamic>> actualizarEquipo(
      int equipoId, String nombre, String entrenador) async {
    final response = await http.put(
      Uri.parse('$apiUrl/equipos/$equipoId'),
      body: {
        'nombre': nombre,
        'entrenador': entrenador,
      },
    );

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, devolver el cuerpo de la respuesta
      return {'message': 'Equipo actualizado correctamente'};
    } else {
      // Si la solicitud falla, lanzar una excepción
      throw Exception(
          'Error al actualizar el equipo: ${response.reasonPhrase}');
    }
  }

  Future<List<String>> obtenerRegiones() async {
    try {
      var respuesta = await http.get(Uri.parse('$apiUrl/regiones'));

      if (respuesta.statusCode == 200) {
        var data = jsonDecode(respuesta.body) as List<dynamic>;
        List<String> nombresRegiones =
            data.map<String>((region) => region['nombre'].toString()).toList();
        return nombresRegiones;
      } else {
        return [];
      }
    } catch (error) {
      print('Error al obtener las regiones: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> agregarJugadorAlEquipo(
      int equipoId,
      String nombre,
      String apellido,
      String nickname,
      String agente1,
      String agente2,
      String agente3) async {
    try {
      var url = Uri.parse('$apiUrl/equipos/$equipoId/jugadores');

      var respuesta = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nombre': nombre,
          'nickname': nickname,
          'agente_1': agente1,
          'agente_2': agente2,
          'agente_3': agente3,
        }),
      );

      if (respuesta.statusCode == 201) {
        return {'success': true};
      } else {
        var error = json.decode(respuesta.body);
        return {'success': false, 'error': error};
      }
    } catch (error) {
      print('Error al agregar jugador al equipo: $error');
      return {'success': false, 'error': 'Error al agregar jugador al equipo'};
    }
  }
}

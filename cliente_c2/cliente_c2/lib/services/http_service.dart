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
    final respuesta = await http.get(Uri.parse('$apiUrl/regiones/$regionId'));

    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(respuesta.body);
      return data;
    } else {
      throw Exception('Error al cargar la región');
    }
  }

  Future<void> borrarEquipo(int equipoId) async {
    final String url = '$apiUrl/equipos/$equipoId';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Equipo borrado exitosamente');
      } else {
        throw Exception('Error al borrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al borrar el equipo: $e');
      rethrow;
    }
  }

  Future<String?> borrarJugador(int jugadorId) async {
    final response = await http
        .delete(Uri.parse(apiUrl + '/jugadores/' + jugadorId.toString()));
    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Error al borrar el jugador: ${response.statusCode}';
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

  Future<Map<String, dynamic>> agregarJugadors(
      String nombre,
      String apellido,
      String nickname,
      String agente1,
      String agente2,
      String agente3,
      String equipo) async {
    try {
      var url = Uri.parse('$apiUrl/jugadores');

      var respuesta = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nombre': nombre,
          'apellido': apellido,
          'nickname': nickname,
          'agente_1': agente1,
          'agente_2': agente2,
          'agente_3': agente3,
        }),
      );

      if (respuesta.statusCode == 201) {
        var nuevoJugador = json.decode(respuesta.body);
        return {'success': true, 'jugador': nuevoJugador};
      } else {
        var error = json.decode(respuesta.body);
        return {'success': false, 'error': error};
      }
    } catch (error) {
      print('Error al agregar jugador: $error');
      return {'success': false, 'error': 'Error al agregar jugador'};
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

  Future<List<String>> obtenerEquipos() async {
    try {
      var respuesta = await http.get(Uri.parse('$apiUrl/equipos'));

      if (respuesta.statusCode == 200) {
        var data = jsonDecode(respuesta.body) as List<dynamic>;
        List<String> nombresEquipos =
            data.map<String>((equipo) => equipo['nombre'].toString()).toList();
        return nombresEquipos;
      } else {
        return [];
      }
    } catch (error) {
      print('Error al obtener los equipos: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> agregarJugador(
      String nombre,
      String apellido,
      String nickname,
      String agente1,
      String agente2,
      String agente3,
      String equipo) async {
    try {
      var url = Uri.parse('$apiUrl/jugadores');

      var respuesta = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nombre': nombre,
          'apellido': apellido,
          'nickname': nickname,
          'agente_1': agente1,
          'agente_2': agente2,
          'agente_3': agente3,
          'equipo_id': equipo,
        }),
      );

      if (respuesta.statusCode == 201) {
        var nuevoJugador = json.decode(respuesta.body);
        return {'success': true, 'jugador': nuevoJugador};
      } else {
        var error = json.decode(respuesta.body);
        return {'success': false, 'error': error};
      }
    } catch (error) {
      print('Error al agregar jugador: $error');
      return {'success': false, 'error': 'Error al agregar jugador'};
    }
  }

  Future<void> crearEncuentro(Map<String, dynamic> datosEncuentro) async {
    final response = await http.post(
      Uri.parse('$apiUrl/encuentros'),
      body: jsonEncode(datosEncuentro),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Encuentro creado exitosamente');
    } else {
      final responseBody = json.decode(response.body);
      throw Exception(
          'Error al crear el encuentro: ${response.statusCode} - ${responseBody['message'] ?? 'Sin mensaje'}');
    }
  }

  Future<void> actualizarEncuentro(int idEncuentroEquipos,
      Map<String, dynamic> datosEncuentroEquipos) async {
    final response = await http.put(
      Uri.parse('$apiUrl/encuentroEquipos/$idEncuentroEquipos'),
      body: jsonEncode(datosEncuentroEquipos),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Error al actualizar el encuentro: ${response.statusCode}');
    }
  }

  Future<void> eliminarEncuentro(int idEncuentro) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/encuentros/$idEncuentro'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el encuentro: ${response.statusCode}');
    }
  }

  Future<List<String>> obtenerMapas() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/mapas'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<String> nombresMapas =
            data.map<String>((mapa) => mapa.toString()).toList();
        return nombresMapas;
      } else {
        throw Exception('Failed to load maps');
      }
    } catch (e) {
      throw Exception('Error fetching maps: $e');
    }
  }
}

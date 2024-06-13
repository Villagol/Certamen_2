import 'dart:convert';
import 'dart:math';
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

  Future<void> crearEncuentroEquipo(
      Map<String, dynamic> nuevoEncuentroEquipo) async {
    final url = Uri.parse('$apiUrl/encuentro_equipos');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nuevoEncuentroEquipo),
      );

      if (response.statusCode == 201) {
        print('Encuentro de equipo creado correctamente');
      } else {
        final responseBody = json.decode(response.body);
        throw Exception(
            'Error al crear el encuentro de equipo: ${response.statusCode} - ${responseBody['message'] ?? 'Sin mensaje'}');
      }
    } catch (e) {
      print('Error al crear el encuentro de equipo: $e');
      throw Exception('Error al crear el encuentro de equipo: $e');
    }
  }

  Future<void> actualizarEncuentro(
      int idEncuentro, Map<String, dynamic> body) async {
    final String url =
        '$apiUrl/encuentro_equipos/$idEncuentro'; // URL completa para actualizar el encuentro

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Encuentro actualizado correctamente');
      } else {
        // Si la solicitud falla, lanzar una excepción con el mensaje de error
        throw Exception(
            'Error al actualizar el encuentro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al comunicarse con el servidor: $e');
    }
  }

  Future<void> eliminarEncuentro(int idEncuentro) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/encuentro_equipos/$idEncuentro'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Encuentro eliminado correctamente');
      } else {
        throw Exception(
            'Error al eliminar el encuentro: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud DELETE: $e');
      throw Exception('Error al eliminar el encuentro: $e');
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

  Future<void> editarJugador(
      int jugadorId, Map<String, dynamic> nuevoJugador) async {
    final String url = '$apiUrl/jugadores/$jugadorId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nuevoJugador),
      );

      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        throw Exception(
            'Error al editar el jugador: ${response.statusCode} - ${responseBody['message'] ?? 'Sin mensaje'}');
      }
    } catch (e) {
      print('Error al editar el jugador: $e');
      throw Exception('Error al editar el jugador: $e');
    }
  }

  Future<void> editarEquipo(
      int equipoId, Map<String, dynamic> nuevoEquipo) async {
    final String url = '$apiUrl/equipos/$equipoId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nuevoEquipo),
      );

      if (response.statusCode == 200) {
        print('Equipo actualizado correctamente');
      } else {
        final responseBody = json.decode(response.body);
        throw Exception(
            'Error al editar el equipo: ${response.statusCode} - ${responseBody['message'] ?? 'Sin mensaje'}');
      }
    } catch (e) {
      print('Error al editar el equipo: $e');
      throw Exception('Error al editar el equipo: $e');
    }
  }

  Future<List<dynamic>> obtenerTodosLosEquiposConPuntos() async {
    try {
      var response = await http.get(Uri.parse('$apiUrl/equipos'));

      if (response.statusCode == 200) {
        List<dynamic> equipos = jsonDecode(response.body);
        equipos.forEach((equipo) {
          // Asignar puntos aleatorios entre 1 y 50
          equipo['puntos'] = Random().nextInt(50) + 1;
        });

        // Ordenar equipos por puntos de manera descendente
        equipos.sort((a, b) => b['puntos'].compareTo(a['puntos']));

        return equipos;
      } else {
        throw Exception('Error al obtener equipos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }

  Future<void> editarResultadoFechaEncuentro({
    required int encuentroId,
    required Map<String, String> datosActualizados,
  }) async {
    try {
      final url = Uri.parse(
          '$apiUrl/encuentro_equipos/$encuentroId'); // Ajusta la URL según tu API
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200) {
        print('Encuentro actualizado exitosamente');
      } else {
        throw Exception(
            'Error al actualizar el encuentro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el encuentro: $e');
    }
  }

  Future<void> editarResultadoEncuentro(
      int encuentroEquipoId, String nuevoResultado) async {
    try {
      final url = Uri.parse(
          '$apiUrl/encuentro_equipos/$encuentroEquipoId'); // Asegúrate de que la URL sea correcta
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'resultado': nuevoResultado,
        }),
      );

      if (response.statusCode == 200) {
        print('Resultado del encuentro actualizado exitosamente');
      } else {
        throw Exception(
            'Error al actualizar el resultado del encuentro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el resultado del encuentro: $e');
    }
  }

  Future<void> editarEncuentro(
      int encuentroId, Map<String, dynamic> datosActualizados) async {
    try {
      final url = Uri.parse(
          '$apiUrl/encuentro_equipos/$encuentroId'); // URL para editar encuentro por ID
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200) {
        print('Encuentro actualizado exitosamente');
      } else {
        throw Exception(
            'Error al actualizar el encuentro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el encuentro: $e');
    }
  }

  Future<void> editarFechaHoraEncuentro(
      int encuentroId, String nuevaFecha, String nuevaHora) async {
    try {
      final url = Uri.parse(
          '$apiUrl/encuentro_equipos/$encuentroId'); // URL para editar encuentro por ID
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'fecha': nuevaFecha,
          'hora': nuevaHora,
        }),
      );

      if (response.statusCode == 200) {
        print('Fecha y hora del encuentro actualizados exitosamente');
      } else {
        throw Exception(
            'Error al actualizar la fecha y hora del encuentro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar la fecha y hora del encuentro: $e');
    }
  }
}

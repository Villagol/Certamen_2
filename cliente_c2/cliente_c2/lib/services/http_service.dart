import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> pilotos() async {
    return listarDatos('pilotos');
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

  // Future<LinkedHashMap<String, dynamic>> pilotosAgregar(String nombre, String apellido, int numero, String pais) async {
  Future<LinkedHashMap<String, dynamic>> pilotosAgregar(String nombre,
      String apellido, int numero, String pais, int equipo) async {
    var url = Uri.parse('$apiUrl/pilotos');
    var respuesta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode(<String, dynamic>{
        'nombre': nombre,
        'apellido': apellido,
        'numero': numero,
        'pais': pais,
        'equipo': equipo,
      }),
    );
    return json.decode(respuesta.body);
  }

  Future<List<dynamic>> paises() async {
    var respuesta = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,cca2&lang=spanish'));

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    }

    return [];
  }

  Future<bool> borrarPiloto(int pilotoId) async {
    var respuesta = await http
        .delete(Uri.parse(apiUrl + '/pilotos/' + pilotoId.toString()));
    return respuesta.statusCode == 200;
  }
}

class EncuentroEquipo {
  final int id;
  final String resultado;
  final String fecha;
  final String hora;
  final String mapa;
  final String equipoLocal;
  final String equipoVisitante;

  EncuentroEquipo({
    required this.id,
    required this.resultado,
    required this.fecha,
    required this.hora,
    required this.mapa,
    required this.equipoLocal,
    required this.equipoVisitante,
  });

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resultado': resultado,
      'fecha': fecha,
      'hora': hora,
      'mapa': mapa,
      'equipoLocal': equipoLocal,
      'equipoVisitante': equipoVisitante,
    };
  }

  // Factory method para crear desde un JSON
  factory EncuentroEquipo.fromJson(Map<String, dynamic> json) {
    return EncuentroEquipo(
      id: json['id'],
      resultado: json['resultado'],
      fecha: json['fecha'],
      hora: json['hora'],
      mapa: json['mapa'],
      equipoLocal: json['equipoLocal'],
      equipoVisitante: json['equipoVisitante'],
    );
  }
}

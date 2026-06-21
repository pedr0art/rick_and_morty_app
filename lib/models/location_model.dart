// ============================================================
// MODELO: LocationModel
// Representa um local (planeta, estação, etc.) da API.
// A API retorna os residentes como lista de URLs de personagens.
// ============================================================

class LocationModel {
  final int id;
  final String name;
  final String type;
  final String dimension;
  // Lista de URLs dos residentes (ex: "https://rickandmortyapi.com/api/character/1")
  final List<String> residents;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      dimension: json['dimension'] as String,
      // Converte a lista dinâmica para List<String>
      residents: List<String>.from(json['residents'] as List),
    );
  }
}

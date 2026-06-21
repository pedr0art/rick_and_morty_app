// ============================================================
// MODELO: CharacterModel
// Representa um personagem da API Rick and Morty.
// fromJson() converte o JSON da API em objeto Dart.
// ============================================================

class CharacterModel {
  final int id;
  final String name;
  final String status;   // Alive, Dead, unknown
  final String species;
  final String gender;
  final String image;
  final String originName;
  final String locationName;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.originName,
    required this.locationName,
  });

  // Converte um Map (JSON decodificado) em CharacterModel
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      // A API retorna origin e location como objetos com chave "name"
      originName: json['origin']['name'] as String,
      locationName: json['location']['name'] as String,
    );
  }

  // Converte o objeto em Map para salvar nos SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'image': image,
      'origin': {'name': originName},
      'location': {'name': locationName},
    };
  }
}

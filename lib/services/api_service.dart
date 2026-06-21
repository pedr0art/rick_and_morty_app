// ============================================================
// SERVIÇO: ApiService
// Centraliza TODAS as chamadas à Rick and Morty API.
// Usa o pacote `http` para fazer requisições GET.
// Cada método retorna um Map com os dados + info de paginação.
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/location_model.dart';

class ApiService {
  // URL base da API
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  // ----------------------------------------------------------
  // PERSONAGENS
  // ----------------------------------------------------------

  /// Busca uma página de personagens.
  /// Retorna um Map com:
  ///   - 'characters': List<CharacterModel>
  ///   - 'hasNextPage': bool (se existe próxima página)
  Future<Map<String, dynamic>> fetchCharacters(int page) async {
    final url = Uri.parse('$_baseUrl/character?page=$page');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // 'info' contém metadados de paginação
      final info = data['info'] as Map<String, dynamic>;
      final hasNextPage = info['next'] != null;

      // 'results' é a lista de personagens
      final results = data['results'] as List<dynamic>;
      final characters = results
          .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return {
        'characters': characters,
        'hasNextPage': hasNextPage,
      };
    } else {
      throw Exception('Erro ao buscar personagens: ${response.statusCode}');
    }
  }

  /// Busca os detalhes de um único personagem pelo ID.
  Future<CharacterModel> fetchCharacterById(int id) async {
    final url = Uri.parse('$_baseUrl/character/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return CharacterModel.fromJson(data);
    } else {
      throw Exception('Erro ao buscar personagem #$id: ${response.statusCode}');
    }
  }

  /// Busca múltiplos personagens de uma vez pelos IDs.
  /// Usado para carregar os residentes de um local.
  /// A API aceita: /character/1,2,3,4
  Future<List<CharacterModel>> fetchCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    final idsStr = ids.join(',');
    final url = Uri.parse('$_baseUrl/character/$idsStr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Se só um ID, a API retorna objeto; se vários, retorna lista
      if (data is List) {
        return data
            .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [CharacterModel.fromJson(data as Map<String, dynamic>)];
      }
    } else {
      throw Exception('Erro ao buscar personagens por IDs: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------------
  // LOCAIS
  // ----------------------------------------------------------

  /// Busca uma página de locais.
  /// Retorna um Map com:
  ///   - 'locations': List<LocationModel>
  ///   - 'hasNextPage': bool
  Future<Map<String, dynamic>> fetchLocations(int page) async {
    final url = Uri.parse('$_baseUrl/location?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final info = data['info'] as Map<String, dynamic>;
      final hasNextPage = info['next'] != null;

      final results = data['results'] as List<dynamic>;
      final locations = results
          .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return {
        'locations': locations,
        'hasNextPage': hasNextPage,
      };
    } else {
      throw Exception('Erro ao buscar locais: ${response.statusCode}');
    }
  }
}

// ============================================================
// PROVIDER: FavoritesProvider
// Gerencia os personagens favoritos do usuário.
// Persiste os dados localmente com SharedPreferences.
// SharedPreferences salva dados simples como Strings no dispositivo.
// ============================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class FavoritesProvider extends ChangeNotifier {
  // Chave usada para salvar no SharedPreferences
  static const String _storageKey = 'favorite_characters';

  List<CharacterModel> _favorites = [];

  List<CharacterModel> get favorites => _favorites;

  /// Verifica se um personagem é favorito pelo ID
  bool isFavorite(int characterId) {
    return _favorites.any((c) => c.id == characterId);
  }

  /// Carrega os favoritos salvos no dispositivo.
  /// Deve ser chamado ao iniciar o app.
  Future<void> loadFavorites() async {
    // Abre o armazenamento local
    final prefs = await SharedPreferences.getInstance();

    // Tenta ler a lista salva como String JSON
    final savedData = prefs.getString(_storageKey);

    if (savedData != null) {
      // Decodifica a String JSON para List
      final List<dynamic> decoded = jsonDecode(savedData) as List<dynamic>;

      // Converte cada item de volta para CharacterModel
      _favorites = decoded
          .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
          .toList();

      notifyListeners();
    }
  }

  /// Adiciona ou remove um personagem dos favoritos (toggle).
  Future<void> toggleFavorite(CharacterModel character) async {
    if (isFavorite(character.id)) {
      // Se já é favorito, remove
      _favorites.removeWhere((c) => c.id == character.id);
    } else {
      // Se não é favorito, adiciona
      _favorites.add(character);
    }

    // Salva a lista atualizada no dispositivo
    await _saveFavorites();
    notifyListeners();
  }

  /// Salva a lista de favoritos no SharedPreferences como JSON.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Converte a lista para JSON String
    final encoded = jsonEncode(
      _favorites.map((c) => c.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encoded);
  }
}

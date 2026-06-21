// ============================================================
// PROVIDER: CharacterProvider
// Gerencia o estado da lista de personagens.
// O Provider notifica os widgets quando os dados mudam.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

// Estados possíveis da requisição
enum LoadingState { idle, loading, success, error }

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CharacterModel> _characters = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false; // controla o carregamento de mais itens (paginação)

  // Getters — widgets leem esses valores
  List<CharacterModel> get characters => _characters;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;

  /// Carrega a primeira página (ou recarrega do zero).
  Future<void> loadCharacters() async {
    // Evita recarregar se já tiver dados
    if (_state == LoadingState.success && _characters.isNotEmpty) return;

    _state = LoadingState.loading;
    _currentPage = 1;
    _characters = [];
    notifyListeners(); // avisa os widgets que algo mudou

    try {
      final result = await _apiService.fetchCharacters(_currentPage);
      _characters = result['characters'] as List<CharacterModel>;
      _hasNextPage = result['hasNextPage'] as bool;
      _state = LoadingState.success;
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Carrega a próxima página (infinite scroll).
  Future<void> loadMore() async {
    // Não carrega mais se já estiver carregando ou não tiver próxima página
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final result = await _apiService.fetchCharacters(_currentPage);
      final newCharacters = result['characters'] as List<CharacterModel>;
      _characters.addAll(newCharacters); // adiciona ao final da lista
      _hasNextPage = result['hasNextPage'] as bool;
    } catch (e) {
      _currentPage--; // reverte a página em caso de erro
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Força recarregamento da lista.
  Future<void> refresh() async {
    _state = LoadingState.idle;
    _characters = [];
    await loadCharacters();
  }
}

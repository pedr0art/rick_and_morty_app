// ============================================================
// PROVIDER: LocationProvider
// Gerencia o estado da lista de locais.
// Mesma lógica do CharacterProvider, mas para locais.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';

enum LoadingState { idle, loading, success, error }

class LocationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LocationModel> _locations = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  List<LocationModel> get locations => _locations;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadLocations() async {
    if (_state == LoadingState.success && _locations.isNotEmpty) return;

    _state = LoadingState.loading;
    _currentPage = 1;
    _locations = [];
    notifyListeners();

    try {
      final result = await _apiService.fetchLocations(_currentPage);
      _locations = result['locations'] as List<LocationModel>;
      _hasNextPage = result['hasNextPage'] as bool;
      _state = LoadingState.success;
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final result = await _apiService.fetchLocations(_currentPage);
      final newLocations = result['locations'] as List<LocationModel>;
      _locations.addAll(newLocations);
      _hasNextPage = result['hasNextPage'] as bool;
    } catch (e) {
      _currentPage--;
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _state = LoadingState.idle;
    _locations = [];
    await loadLocations();
  }
}

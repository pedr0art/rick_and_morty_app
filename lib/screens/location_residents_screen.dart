// ============================================================
// TELA: LocationResidentsScreen (Residentes do Local)
// Recebe um LocationModel e busca os personagens residentes.
// Extrai os IDs das URLs e busca todos de uma vez na API.
// ============================================================

import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class LocationResidentsScreen extends StatefulWidget {
  final LocationModel location;

  const LocationResidentsScreen({super.key, required this.location});

  @override
  State<LocationResidentsScreen> createState() =>
      _LocationResidentsScreenState();
}

class _LocationResidentsScreenState extends State<LocationResidentsScreen> {
  final ApiService _apiService = ApiService();

  // Estados locais da tela (sem precisar de Provider aqui)
  bool _isLoading = true;
  String? _errorMessage;
  List<CharacterModel> _residents = [];

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cada URL de residente é como: "https://rickandmortyapi.com/api/character/38"
      // Extraímos só o número do final de cada URL
      final ids = widget.location.residents
          .map((url) => int.parse(url.split('/').last))
          .toList();

      final residents = await _apiService.fetchCharactersByIds(ids);
      setState(() {
        _residents = residents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
        backgroundColor: const Color(0xFF7B2FBE),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Cabeçalho com informações do local
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF7B2FBE).withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.location.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Tipo: ${widget.location.type}'),
                Text('Dimensão: ${widget.location.dimension}'),
              ],
            ),
          ),

          // Corpo: lista de residentes
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Carregando
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Erro
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Erro ao carregar residentes'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadResidents,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // Local sem residentes
    if (_residents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Este local não tem residentes conhecidos.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Lista de residentes
    return ListView.builder(
      itemCount: _residents.length,
      itemBuilder: (context, index) {
        final character = _residents[index];
        return CharacterCard(
          character: character,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CharacterDetailScreen(character: character),
            ),
          ),
        );
      },
    );
  }
}

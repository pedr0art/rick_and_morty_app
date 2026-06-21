// ============================================================
// TELA: LocationResidentsScreen — dark theme
// ============================================================

import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class LocationResidentsScreen extends StatefulWidget {
  final LocationModel location;
  const LocationResidentsScreen({super.key, required this.location});

  @override
  State<LocationResidentsScreen> createState() => _LocationResidentsScreenState();
}

class _LocationResidentsScreenState extends State<LocationResidentsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _errorMessage;
  List<CharacterModel> _residents = [];

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final ids = widget.location.residents
          .map((url) => int.parse(url.split('/').last))
          .toList();
      final residents = await _apiService.fetchCharactersByIds(ids);
      setState(() { _residents = residents; _isLoading = false; });
    } catch (e) {
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        title: Text(
          widget.location.name,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // Cabeçalho do local
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.purpleDim,
              border: Border(bottom: BorderSide(color: AppColors.purpleBorder)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language_outlined, color: AppColors.purple, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.location.type,
                        style: const TextStyle(fontSize: 11, color: AppColors.purple, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.location.dimension,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.location.residents.length} resid.',
                    style: const TextStyle(fontSize: 11, color: AppColors.purple, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.purple));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.redDim, shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.red),
            ),
            const SizedBox(height: 16),
            const Text('Erro ao carregar residentes', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadResidents,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purple,
                side: const BorderSide(color: AppColors.purpleBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_residents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.bgSurface, shape: BoxShape.circle),
              child: const Icon(Icons.person_off_outlined, size: 40, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            const Text('Sem residentes conhecidos', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Este local não possui residentes registrados.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _residents.length,
      itemBuilder: (context, index) {
        final character = _residents[index];
        return CharacterCard(
          character: character,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: character)),
          ),
        );
      },
    );
  }
}

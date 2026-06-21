// ============================================================
// TELA: FavoritesScreen — dark theme
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        title: const Text('Favoritos', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.amberDim,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_outline_rounded, size: 40, color: AppColors.amber),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum favorito ainda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Abra um personagem e toque na estrela',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(
                character: character,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: character)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

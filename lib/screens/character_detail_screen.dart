// ============================================================
// TELA: CharacterDetailScreen — dark theme com grid de info
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/character_model.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterModel character;
  const CharacterDetailScreen({super.key, required this.character});

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'alive':  return AppColors.portalGreen;
      case 'dead':   return AppColors.red;
      default:       return AppColors.textMuted;
    }
  }

  Color _statusBg(String s) {
    switch (s.toLowerCase()) {
      case 'alive':  return const Color(0x1A39D353);
      case 'dead':   return const Color(0x1AEF4444);
      default:       return const Color(0x1A6E7681);
    }
  }

  String _statusText(String s) {
    switch (s.toLowerCase()) {
      case 'alive':  return 'Vivo';
      case 'dead':   return 'Morto';
      default:       return 'Desconhecido';
    }
  }

  String _genderText(String g) {
    switch (g.toLowerCase()) {
      case 'male':       return 'Masculino';
      case 'female':     return 'Feminino';
      case 'genderless': return 'Sem gênero';
      default:           return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFav = favoritesProvider.isFavorite(character.id);

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          body: CustomScrollView(
            slivers: [
              // AppBar com imagem de fundo
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.bgBase,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.white),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        favoritesProvider.toggleFavorite(character);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav ? 'Removido dos favoritos' : 'Adicionado aos favoritos',
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFav ? AppColors.amber : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem
                      CachedNetworkImage(
                        imageUrl: character.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppColors.bgSurface),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.bgSurface,
                          child: const Icon(Icons.person, size: 80, color: AppColors.textMuted),
                        ),
                      ),
                      // Gradiente para o conteúdo abaixo não ficar cortado
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.bgBase],
                            stops: [0.55, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Conteúdo
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome + badge de status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              character.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _statusBg(character.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(
                                    color: _statusColor(character.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _statusText(character.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _statusColor(character.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        character.species,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // Grid de info (espécie, gênero)
                      _SectionLabel('Informações'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _InfoCell(label: 'Espécie', value: character.species, icon: Icons.biotech_outlined)),
                          const SizedBox(width: 10),
                          Expanded(child: _InfoCell(label: 'Gênero', value: _genderText(character.gender), icon: Icons.wc_outlined)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Localização
                      _SectionLabel('Localização'),
                      const SizedBox(height: 10),
                      _LocationCard(
                        label: 'Origem',
                        value: character.originName,
                        icon: Icons.home_outlined,
                        color: AppColors.portalGreen,
                      ),
                      const SizedBox(height: 8),
                      _LocationCard(
                        label: 'Localização atual',
                        value: character.locationName,
                        icon: Icons.place_outlined,
                        color: AppColors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCell({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _LocationCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET: CharacterCard — visual dark temático
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/character_model.dart';
import '../theme/app_theme.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':  return AppColors.portalGreen;
      case 'dead':   return AppColors.red;
      default:       return AppColors.textMuted;
    }
  }

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'alive':  return const Color(0x1A39D353);
      case 'dead':   return const Color(0x1AEF4444);
      default:       return const Color(0x1A6E7681);
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'alive':  return 'Vivo';
      case 'dead':   return 'Morto';
      default:       return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColors.portalGreen.withValues(alpha: 0.05),
        highlightColor: AppColors.portalGreen.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Avatar com borda verde sutil
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.portalGreenBorder,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 64,
                      height: 64,
                      color: AppColors.bgElevated,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 64,
                      height: 64,
                      color: AppColors.bgElevated,
                      child: const Icon(Icons.person, size: 32, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    // Badge de status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusBg(character.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _statusColor(character.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${_statusText(character.status)} · ${character.species}',
                            style: TextStyle(
                              fontSize: 11,
                              color: _statusColor(character.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            character.locationName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

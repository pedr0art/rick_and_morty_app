// ============================================================
// TELA: CharacterDetailScreen (Detalhes do Personagem)
// Exibe todas as informações do personagem.
// Botão de favorito que adiciona/remove usando FavoritesProvider.
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/character_model.dart';
import '../providers/favorites_provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailScreen({super.key, required this.character});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return 'Vivo';
      case 'dead':
        return 'Morto';
      default:
        return 'Desconhecido';
    }
  }

  String _genderText(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Masculino';
      case 'female':
        return 'Feminino';
      case 'genderless':
        return 'Sem gênero';
      default:
        return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer ouve FavoritesProvider para atualizar o ícone de favorito
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFav = favoritesProvider.isFavorite(character.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(character.name),
            backgroundColor: const Color(0xFF00B5CC),
            foregroundColor: Colors.white,
            // Botão de favorito no canto superior direito
            actions: [
              IconButton(
                // Muda o ícone dependendo se é favorito ou não
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.yellow : Colors.white,
                ),
                tooltip: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                onPressed: () {
                  favoritesProvider.toggleFavorite(character);
                  // Mostra um feedback rápido (SnackBar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? '${character.name} removido dos favoritos'
                            : '${character.name} adicionado aos favoritos',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: isFav ? Colors.red[400] : Colors.green[400],
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem em destaque ocupando toda a largura
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 80),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card com as informações
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Status com indicador colorido
                              _InfoRow(
                                icon: Icons.circle,
                                iconColor: _statusColor(character.status),
                                label: 'Status',
                                value: _statusText(character.status),
                              ),
                              const Divider(),
                              _InfoRow(
                                icon: Icons.bug_report,
                                label: 'Espécie',
                                value: character.species,
                              ),
                              const Divider(),
                              _InfoRow(
                                icon: Icons.wc,
                                label: 'Gênero',
                                value: _genderText(character.gender),
                              ),
                              const Divider(),
                              _InfoRow(
                                icon: Icons.home,
                                label: 'Origem',
                                value: character.originName,
                              ),
                              const Divider(),
                              _InfoRow(
                                icon: Icons.place,
                                label: 'Localização Atual',
                                value: character.locationName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------
// WIDGET INTERNO: _InfoRow
// Linha de informação com ícone, rótulo e valor.
// ----------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          // Rótulo em negrito
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Valor que expande para usar o espaço restante
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

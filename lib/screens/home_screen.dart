// ============================================================
// TELA: HomeScreen (Tela Inicial)
// Apresenta o app e botões de navegação para as outras telas.
// ============================================================

import 'package:flutter/material.dart';
import 'characters_screen.dart';
import 'locations_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo com gradiente temático
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone/logo do app
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B5CC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.rocket_launch,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nome do app
                  const Text(
                    'Guia Rick and Morty',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Descrição
                  Text(
                    'Explore personagens e locais do universo de Rick and Morty. '
                    'Salve seus favoritos e descubra onde cada um vive!',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Botão: Personagens
                  _NavButton(
                    icon: Icons.people,
                    label: 'Personagens',
                    color: const Color(0xFF00B5CC),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CharactersScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão: Locais
                  _NavButton(
                    icon: Icons.place,
                    label: 'Locais',
                    color: const Color(0xFF7B2FBE),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão: Favoritos
                  _NavButton(
                    icon: Icons.star,
                    label: 'Favoritos',
                    color: const Color(0xFFE94560),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoritesScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// WIDGET INTERNO: _NavButton
// Botão de navegação reutilizável da tela inicial.
// ----------------------------------------------------------
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ocupa toda a largura disponível
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

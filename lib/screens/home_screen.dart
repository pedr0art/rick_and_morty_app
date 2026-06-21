// ============================================================
// TELA: HomeScreen — visual dark com efeito portal
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'characters_screen.dart';
import 'locations_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com efeito portal
              _PortalHeader(),
              const SizedBox(height: 36),

              // Label seção
              const Text(
                'EXPLORAR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 12),

              // Botão: Personagens
              _NavCard(
                icon: Icons.people_outline,
                label: 'Personagens',
                subtitle: '826 do universo Rick & Morty',
                accentColor: AppColors.portalGreen,
                dimColor: AppColors.portalGreenDim,
                borderColor: AppColors.portalGreenBorder,
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CharactersScreen())),
              ),
              const SizedBox(height: 10),

              // Botão: Locais
              _NavCard(
                icon: Icons.language_outlined,
                label: 'Locais',
                subtitle: 'Planetas, estações e dimensões',
                accentColor: AppColors.purple,
                dimColor: AppColors.purpleDim,
                borderColor: AppColors.purpleBorder,
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LocationsScreen())),
              ),
              const SizedBox(height: 10),

              // Botão: Favoritos
              _NavCard(
                icon: Icons.star_outline,
                label: 'Favoritos',
                subtitle: 'Seus personagens salvos',
                accentColor: AppColors.amber,
                dimColor: AppColors.amberDim,
                borderColor: AppColors.amberBorder,
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// Header com título e decoração de portal
// ----------------------------------------------------------
class _PortalHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Anéis decorativos do portal (canto superior direito)
        Positioned(
          top: -20,
          right: -24,
          child: _PortalRings(),
        ),
        // Conteúdo do header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.portalGreenDim,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.portalGreenBorder, width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_outlined, size: 13, color: AppColors.portalGreen),
                  SizedBox(width: 6),  // já está dentro de const Row, implicitamente const
                  Text(
                    'Universo Rick & Morty',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.portalGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Título
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: 'Guia '),
                  TextSpan(
                    text: 'Rick\n& Morty',
                    style: TextStyle(color: AppColors.portalGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Explore personagens e locais das\ndimensões conhecidas. Salve seus favoritos.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Anéis concêntricos do portal em CSS puro
class _PortalRings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(110, 0.08),
          _ring(82,  0.13),
          _ring(56,  0.20),
          _ring(30,  0.30),
          // Núcleo
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.portalGreen,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.portalGreen.withValues(alpha: opacity),
          width: 1.5,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// Card de navegação
// ----------------------------------------------------------
class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final Color dimColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accentColor,
    required this.dimColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: accentColor.withValues(alpha: 0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: dimColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              // Ícone
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accentColor.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

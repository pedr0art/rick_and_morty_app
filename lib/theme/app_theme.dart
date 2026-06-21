// ============================================================
// TEMA: AppTheme
// Centraliza todas as cores e estilos do app.
// Tema escuro inspirado na estética do Rick and Morty.
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  // Fundos
  static const Color bgBase     = Color(0xFF0D1117); // fundo principal
  static const Color bgSurface  = Color(0xFF161B22); // cards
  static const Color bgElevated = Color(0xFF21262D); // bordas / hover

  // Destaque — verde portal
  static const Color portalGreen       = Color(0xFF39D353);
  static const Color portalGreenDim    = Color(0xFF1A3A2E); // fundo sutil verde
  static const Color portalGreenBorder = Color(0x4039D353); // borda 25% opacidade

  // Roxo — locais
  static const Color purple       = Color(0xFFA78BFA);
  static const Color purpleDim    = Color(0xFF1E1B2E);
  static const Color purpleBorder = Color(0x408B5CF6);

  // Âmbar — favoritos
  static const Color amber       = Color(0xFFFCD34D);
  static const Color amberDim    = Color(0xFF2A2010);
  static const Color amberBorder = Color(0x40F59E0B);

  // Vermelho — morto
  static const Color red    = Color(0xFFEF4444);
  static const Color redDim = Color(0xFF2A1010);

  // Texto
  static const Color textPrimary   = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted     = Color(0xFF6E7681);

  // Borda padrão
  static const Color border = Color(0xFF21262D);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.portalGreen,
        secondary: AppColors.purple,
        surface: AppColors.bgSurface,
        onPrimary: AppColors.bgBase,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBase,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        // Linha sutil embaixo do AppBar
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      dividerColor: AppColors.border,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.portalGreen,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.bgSurface,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: AppColors.border),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

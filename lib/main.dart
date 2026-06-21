// ============================================================
// MAIN.DART — aplica o tema escuro globalmente
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/character_provider.dart';
import 'providers/location_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barra de status com ícones claros (fundo escuro)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider.value(value: favoritesProvider),
      ],
      child: const RickAndMortyApp(),
    ),
  );
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia Rick and Morty',
      debugShowCheckedModeBanner: false,
      // Aplica o tema escuro em todo o app
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

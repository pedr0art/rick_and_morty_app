// ============================================================
// MAIN.DART — Ponto de entrada do app
// Aqui configuramos todos os Providers e iniciamos o app.
// MultiProvider permite registrar vários providers de uma vez.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/character_provider.dart';
import 'providers/location_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // Necessário para usar plugins antes do runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Cria o FavoritesProvider e carrega os favoritos salvos ANTES de mostrar o app
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites();

  runApp(
    // MultiProvider disponibiliza os providers para toda a árvore de widgets
    MultiProvider(
      providers: [
        // CharacterProvider: gerencia a lista de personagens
        ChangeNotifierProvider(create: (_) => CharacterProvider()),

        // LocationProvider: gerencia a lista de locais
        ChangeNotifierProvider(create: (_) => LocationProvider()),

        // FavoritesProvider: gerencia favoritos (já carregados acima)
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
      debugShowCheckedModeBanner: false, // remove a faixa "debug" do canto
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B5CC),
        ),
        useMaterial3: true,
        // Fonte padrão do app
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

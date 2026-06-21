// ============================================================
// TELA: CharactersScreen (Listagem de Personagens)
// Exibe lista paginada com infinite scroll.
// Usa Consumer<CharacterProvider> para ouvir mudanças de estado.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  // ScrollController permite detectar quando o usuário chegou no final da lista
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Carrega os personagens ao entrar na tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().loadCharacters();
    });

    // Escuta o scroll: quando chegar perto do final, carrega mais
    _scrollController.addListener(() {
      // Se o scroll chegou a 90% da lista...
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<CharacterProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // libera recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens'),
        backgroundColor: const Color(0xFF00B5CC),
        foregroundColor: Colors.white,
      ),
      // Consumer ouve o CharacterProvider e reconstrói quando ele muda
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          // Estado: carregando pela primeira vez
          if (provider.state == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado: erro
          if (provider.state == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar personagens',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Estado: lista vazia
          if (provider.characters.isEmpty) {
            return const Center(child: Text('Nenhum personagem encontrado.'));
          }

          // Estado: sucesso — exibe a lista
          return RefreshIndicator(
            // Puxar para baixo recarrega a lista
            onRefresh: provider.refresh,
            child: ListView.builder(
              controller: _scrollController,
              // +1 para o indicador de carregamento no final
              itemCount: provider.characters.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Último item: indicador de carregamento (infinite scroll)
                if (index == provider.characters.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final character = provider.characters[index];
                return CharacterCard(
                  character: character,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailScreen(character: character),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

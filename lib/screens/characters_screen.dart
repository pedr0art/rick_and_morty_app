// ============================================================
// TELA: CharactersScreen — dark theme
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().loadCharacters();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<CharacterProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        title: const Text(
          'Personagens',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
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
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          if (provider.state == LoadingState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.portalGreen),
            );
          }

          if (provider.state == LoadingState.error) {
            return _ErrorState(onRetry: provider.refresh);
          }

          if (provider.characters.isEmpty) {
            return const Center(
              child: Text('Nenhum personagem encontrado.', style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          return RefreshIndicator(
            color: AppColors.portalGreen,
            backgroundColor: AppColors.bgSurface,
            onRefresh: provider.refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: provider.characters.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.characters.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.portalGreen),
                      ),
                    ),
                  );
                }
                final character = provider.characters[index];
                return CharacterCard(
                  character: character,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: character)),
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

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.redDim,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.red),
          ),
          const SizedBox(height: 16),
          const Text('Erro ao carregar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Verifique sua conexão e tente novamente.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.portalGreen,
              side: const BorderSide(color: AppColors.portalGreenBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

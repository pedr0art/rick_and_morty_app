// ============================================================
// TELA: LocationsScreen — dark theme
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../theme/app_theme.dart';
import 'location_residents_screen.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadLocations();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<LocationProvider>().loadMore();
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
        title: const Text('Locais', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
      body: Consumer<LocationProvider>(
        builder: (context, provider, child) {
          if (provider.state == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.purple));
          }

          if (provider.state == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.redDim, shape: BoxShape.circle),
                    child: const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.red),
                  ),
                  const SizedBox(height: 16),
                  const Text('Erro ao carregar locais', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: provider.refresh,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.purple,
                      side: const BorderSide(color: AppColors.purpleBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.locations.isEmpty) {
            return const Center(child: Text('Nenhum local encontrado.', style: TextStyle(color: AppColors.textSecondary)));
          }

          return RefreshIndicator(
            color: AppColors.purple,
            backgroundColor: AppColors.bgSurface,
            onRefresh: provider.refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: provider.locations.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.locations.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purple),
                      ),
                    ),
                  );
                }

                final location = provider.locations[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LocationResidentsScreen(location: location)),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    splashColor: AppColors.purple.withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // Ícone
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.purpleDim,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.purpleBorder),
                            ),
                            child: const Icon(Icons.language_outlined, color: AppColors.purple, size: 22),
                          ),
                          const SizedBox(width: 12),
                          // Texto
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  location.type,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(Icons.people_outline, size: 11, color: AppColors.textMuted),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${location.residents.length} residente(s)',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                        ],
                      ),
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

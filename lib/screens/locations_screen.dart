// ============================================================
// TELA: LocationsScreen (Listagem de Locais)
// Exibe lista paginada de locais com infinite scroll.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
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
      appBar: AppBar(
        title: const Text('Locais'),
        backgroundColor: const Color(0xFF7B2FBE),
        foregroundColor: Colors.white,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, provider, child) {
          // Carregando
          if (provider.state == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erro
          if (provider.state == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Erro ao carregar locais'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: provider.refresh,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.locations.isEmpty) {
            return const Center(child: Text('Nenhum local encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.locations.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Indicador de carregamento no final
                if (index == provider.locations.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final location = provider.locations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2FBE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.place,
                        color: Color(0xFF7B2FBE),
                      ),
                    ),
                    title: Text(
                      location.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Tipo: ${location.type}'),
                        Text(
                          '${location.residents.length} residente(s)',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationResidentsScreen(location: location),
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

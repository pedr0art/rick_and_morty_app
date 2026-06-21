# Guia Rick and Morty 🚀

Aplicativo Flutter que consome a [Rick and Morty API](https://rickandmortyapi.com/) para exibir personagens, locais e gerenciar favoritos.

## Funcionalidades

- **Tela Inicial** — navegação para todas as seções
- **Personagens** — lista paginada com infinite scroll
- **Detalhes do Personagem** — imagem, status, espécie, gênero, origem e localização
- **Favoritos** — adicionar/remover com persistência local (SharedPreferences)
- **Locais** — lista paginada com infinite scroll
- **Residentes** — personagens que vivem em cada local

## Tecnologias

| Biblioteca | Uso |
|---|---|
| `http` | Requisições HTTP para a API |
| `provider` | Gerenciamento de estado |
| `shared_preferences` | Persistência local dos favoritos |
| `cached_network_image` | Cache de imagens da rede |

## Estrutura do Projeto

```
lib/
├── main.dart                        # Ponto de entrada, configuração dos Providers
├── models/
│   ├── character_model.dart         # Modelo de Personagem
│   └── location_model.dart          # Modelo de Local
├── services/
│   └── api_service.dart             # Todas as chamadas à API
├── providers/
│   ├── character_provider.dart      # Estado da lista de personagens
│   ├── location_provider.dart       # Estado da lista de locais
│   └── favorites_provider.dart      # Estado e persistência dos favoritos
├── screens/
│   ├── home_screen.dart             # Tela inicial
│   ├── characters_screen.dart       # Lista de personagens
│   ├── character_detail_screen.dart # Detalhes do personagem
│   ├── favorites_screen.dart        # Lista de favoritos
│   ├── locations_screen.dart        # Lista de locais
│   └── location_residents_screen.dart # Residentes de um local
└── widgets/
    └── character_card.dart          # Card reutilizável de personagem
```

## Como executar

```bash
# Instalar dependências
flutter pub get

# Executar no dispositivo/emulador
flutter run
```

## Requisitos

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Conexão com internet (para acessar a API)

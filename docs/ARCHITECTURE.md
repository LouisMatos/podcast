# Arquitetura — MVVM com Riverpod

## Camadas

```
View  →  ViewModel  →  Repository  →  Source (API / RSS / SQLite)
(widget)  (Notifier)    (domínio)      (dados brutos)
```

A dependência só aponta pra baixo. Uma View nunca importa um repositório ou uma
API diretamente; um repositório nunca importa Flutter.

### View — `features/*/view/`

- Só widgets. Lê estado com `ref.watch(xViewModelProvider)`.
- Dispara ações chamando métodos do notifier:
  `ref.read(xViewModelProvider.notifier).minhaAcao()`.
- Nunca chama repositório, data source ou `Dio` diretamente.
- Nunca guarda estado de negócio em `StatefulWidget` — estado local de UI pura
  (ex: se um tooltip está aberto) pode viver ali; dado de domínio, não.

### ViewModel — `features/*/view_model/`

- Um `Notifier<XState>` (ou `AsyncNotifier`) por tela, gerado com `@riverpod`.
- Estado imutável em Freezed, com o formato:

  ```dart
  @freezed
  class DiscoverState with _$DiscoverState {
    const factory DiscoverState({
      @Default(false) bool isLoading,
      @Default([]) List<Podcast> results,
      String? error,
    }) = _DiscoverState;
  }
  ```

- **Proibido** importar `package:flutter/material.dart` (ou `cupertino.dart`)
  num ViewModel. Isso é o que garante que ele testa sem widget e sem `pump`.
- ViewModel injeta o repositório via `ref.watch(xRepositoryProvider)`, nunca
  instancia um data source direto.

### Model — `data/repositories/` + `data/sources/`

- **Repository**: expõe entidades de domínio (`Podcast`, `Episode`,
  `Subscription`) e esconde de onde o dado veio. É aqui que se decide "busca
  da API ou do cache local".
- **Source**: uma classe burra por origem de dado — `ItunesSearchApi`,
  `RssFeedParser`, os DAOs do drift. Sem lógica de negócio, só tradução de
  formato bruto (JSON/XML/SQL) pra modelo.

## Convenção de providers

- Cada arquivo de repositório e de data source expõe seu próprio
  `@riverpod` provider no fim do arquivo (`podcastRepositoryProvider`, etc).
- ViewModels moram em `features/<nome>/view_model/<nome>_view_model.dart`,
  o estado em `<nome>_state.dart` (arquivo Freezed separado).

## Por que essa separação

- **Testável sem widget**: um ViewModel sem import de Flutter testa em
  milissegundos com `ProviderContainer`, sem `WidgetTester`.
- **Fonte de dado trocável**: se um dia trocarmos `rss_dart` por outro parser,
  só o `RssFeedParser` muda — repositório e ViewModel não sabem a diferença.
- **UI sem lógica escondida**: se um bug está na lista errada, ele está no
  ViewModel ou no repositório, nunca espalhado em `setState` dentro de um
  widget.

Ver `docs/DESIGN_SYSTEM.md` para as regras de tema e animação, e
`docs/ROADMAP.md` para o estado atual do projeto.

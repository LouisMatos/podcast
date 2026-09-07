# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

App de escuta de podcasts para Android e iOS. Monorepo com duas pastas de topo:

- `frontend/` — o app Flutter inteiro (única coisa que existe hoje).
- `backend/` — reservada para um servidor futuro (sync entre aparelhos, conta,
  recomendação). Vazia de propósito na v1: o app é local-only, sem login, sem
  sync, tudo em SQLite embutido via `drift`.

**Antes de qualquer trabalho, leia `docs/ROADMAP.md`** (histórico v1 — Fases
0–8, concluídas) e **`docs/ROADMAP_V2.md`** (evolução em andamento — Fases 9+).
São a fonte de verdade do estado do projeto e devem ser atualizados ao fim de
cada fase. Trabalho novo = uma fase do `ROADMAP_V2.md`.

## Estilo de resposta

- Sempre em pt-BR.
- Respostas objetivas, claras, o mais curtas possível sem perder entendimento.
  Sem enrolação, sem repetir o que o código já diz, sem narrar passo a passo
  óbvio.
- Não reler/recolar arquivo inteiro já mostrado na conversa — referenciar por
  caminho e linha.
- Preferir Grep/Glob a varrer diretório inteiro; ler só o trecho necessário do
  arquivo, não o arquivo inteiro quando evitável.
- Ao explicar decisão técnica, uma frase de porquê basta — sem lista de
  alternativas descartadas a menos que perguntado.

## Mapa do repositório

Estado atual (v1 completa; v2 Fase 9 concluída — ver `docs/ROADMAP_V2.md`):

```text
podcast/
  CLAUDE.md                  este arquivo
  docs/
    ROADMAP.md                histórico v1 (Fases 0–8), dívidas técnicas
    ROADMAP_V2.md             evolução (Fases 9+) — menu priorizado, pausável
    ARCHITECTURE.md           contrato MVVM entre camadas
    DESIGN_SYSTEM.md          paleta, raios, sombras, regras de animação
  backend/
    README.md                  placeholder — nada implementado ainda
  frontend/                    projeto Flutter (único código do app)
    pubspec.yaml                dependências — ver seção abaixo
    analysis_options.yaml       lints; exclui *.g.dart e *.freezed.dart
    scripts/
      run_android.sh            build + emulador + run (ver Comandos)
      gen.sh                     atalho pro build_runner
    lib/
      main.dart                  async — inicializa AudioService e FlutterDownloader
                                  antes do runApp
      app.dart                   ProviderScope/MaterialApp.router
      core/                      theme/, router/ (+ /player e /settings/downloads
                                  fora/dentro das abas, /discover/category dentro),
                                  network/, database/ (drift, schemaVersion 3),
                                  prefs/ (PreferencesStore, shared_preferences),
                                  widgets/ (SoftCard, PillButton, SearchField,
                                  PodcastListTile, ...)
      data/                      models/, sources/ (itunes_search_api,
                                  apple_charts_api, rss_feed_parser, DAOs),
                                  repositories/ (Podcast, Library, Download)
      features/                  discover/ (busca + carrossel Top 20 + categorias),
                                  category/, library/, podcast_detail/ (abas
                                  Episódios/Baixados, busca/filtro/ordenação,
                                  progresso no tile), episode_detail/ (descrição
                                  HTML, /episode), settings/,
                                  player/ (mini-player + tela cheia + volume/
                                  equalizador), downloads/ (+ widgets/DownloadButton)
                                  — layout completo descrito em "Arquitetura" abaixo
      services/audio/            PodcastAudioHandler (just_audio + audio_service;
                                  AndroidEqualizer no AudioPipeline)
      services/download/         DownloadService (flutter_downloader)
    test/                        61 testes — core/prefs/, core/database/ (migração),
                                  data/sources/, data/repositories/, features/discover/,
                                  features/podcast_detail/, features/episode_detail/,
                                  features/player/, support/ (helpers), widget_test.dart
    android/                     projeto nativo Android (manifests, gradle)
                                  MainActivity estende AudioServiceActivity (Fase 4)
    ios/                         projeto nativo iOS (build só na Fase 7)
```

Ao entrar em fase nova que cria pastas em `lib/` (`core/`, `data/`,
`features/`, `services/`), não é preciso atualizar este mapa a cada arquivo —
a árvore alvo já está descrita em "Arquitetura" logo abaixo. Só atualizar
aqui se a divisão de pastas de topo (`frontend/`, `backend/`, `docs/`) mudar.

## Comandos

Todos rodam de dentro de `frontend/`.

```bash
flutter pub get                 # resolver dependências
dart analyze                    # lint/analyze COMPLETO (inclui riverpod_lint) — sempre limpo
flutter analyze                 # mais rápido, mas NÃO roda o plugin riverpod_lint
flutter test                    # todos os testes
flutter test test/caminho_test.dart                      # um arquivo
flutter test test/caminho_test.dart --plain-name "nome"  # um teste

dart run build_runner build --delete-conflicting-outputs  # codegen (uma vez)
./scripts/gen.sh watch          # codegen observando mudanças

./scripts/run_android.sh        # liga o AVD Pixel_6 se preciso, espera boot,
                                 # roda codegen se houver algo pra gerar, `flutter run`
```

`run_android.sh` aceita `AVD_NAME=` e `BOOT_TIMEOUT=` como variáveis de
ambiente, e repassa qualquer argumento extra pro `flutter run` (ex:
`./scripts/run_android.sh --release`).

Build iOS não funciona nesta máquina até instalar Xcode + CocoaPods (ver
Fase 7 no ROADMAP) — só o build Android é suportado por enquanto.

## Arquitetura — MVVM

```text
View  →  ViewModel  →  Repository  →  Source (API / RSS / SQLite)
```

A dependência só aponta pra baixo. Regras (detalhadas em `docs/ARCHITECTURE.md`):

- **View** (`lib/features/*/view/`): só widgets. Lê estado com
  `ref.watch(xViewModelProvider)`, dispara ações com
  `ref.read(xViewModelProvider.notifier).metodo()`. Nunca chama repositório
  ou API direto.
- **ViewModel** (`lib/features/*/view_model/`): um `Notifier<XState>` (ou
  `AsyncNotifier`) por tela, gerado com `@riverpod`. Estado imutável em
  Freezed (`isLoading` / `data` / `error`). **Nunca importa
  `package:flutter/material.dart`** — é isso que garante testar sem widget.
- **Model** (`lib/data/repositories/` + `lib/data/sources/`): repositórios
  expõem entidades de domínio e escondem se o dado veio da API, do RSS ou do
  SQLite local. Data sources (`ItunesSearchApi`, `RssFeedParser`, DAOs do
  drift) são burros e substituíveis, sem lógica de negócio.

Estrutura de pastas em `lib/`:

```text
core/theme/       tokens de design (cor, tipografia, raio, sombra, motion)
core/router/      go_router
core/network/     cliente Dio
core/database/    schema e DAOs do drift
core/widgets/     componentes compartilhados (SoftCard, PillButton, ...)
data/models/      Freezed + json_serializable
data/sources/     itunes_search_api, rss_feed_parser, DAOs
data/repositories/
features/<nome>/{view,view_model}/   uma pasta por tela
services/audio/   PodcastAudioHandler (audio_service + just_audio)
services/download/  DownloadService (flutter_downloader)
```

## Design system

Regra de ouro: **nenhum widget escreve cor, raio, sombra ou duração
literal** — tudo vem de `lib/core/theme/`. Detalhes completos (paleta pastel
exata, valores de raio/sombra, durações e curvas de animação permitidas) em
`docs/DESIGN_SYSTEM.md`. Resumo:

- Paleta pastel (lavanda/menta/pêssego), tons claro e escuro.
- Sem `Divider`/borda dura — separação por sombra suave.
- Tipografia Nunito via `google_fonts`.
- Animações lentas e suaves: `Curves.easeOutCubic`/`easeInOutCubicEmphasized`,
  nunca `Curves.linear` ou "bounce". Loading é shimmer, não spinner girando.

## Stack

Ver `frontend/pubspec.yaml` (Riverpod 3 + Freezed para estado/MVVM,
go_router, dio + `rss_dart` para busca/RSS, drift para persistência local,
just_audio + audio_service para player em background/lockscreen,
flutter_downloader, `shared_preferences` para preferências,
`flutter_widget_from_html_core` para a descrição do episódio). Projeto
requer Flutter stable atual (3.47.2+ / Dart 3.13.2+) — versões mais antigas
não resolvem freezed 4 + riverpod_generator 4 + drift_dev 2.34 juntos.

`dart analyze` roda o `riverpod_lint` (plugin nativo `analysis_server_plugin`,
configurado em `analysis_options.yaml`). `flutter analyze` **não** roda o
plugin — use `dart analyze` pra o check completo. `custom_lint` continua fora
(riverpod_lint 3.x não precisa dele).

## Invariantes do projeto (seguir sempre)

- **Cor/raio/sombra/duração**: nunca literal num widget — sempre de
  `lib/core/theme/` (`AppColors`, `AppRadii`, `AppShadows`, `AppMotion`).
- **`AppColors.onAccent`** pra texto/ícone sobre preenchimento sólido de
  `primary`/`secondary` (`PillButton` primário/secundário). Nunca
  `textPrimary` ali — no tema escuro ele é claro e não passa contraste sobre
  pastel claro (medido 2.5:1, WCAG pede 4.5:1). Ver ROADMAP Fase 6.
- **`TabBar`** sempre com `dividerColor: Colors.transparent` +
  `indicatorSize: TabBarIndicatorSize.label` (design sem borda dura).
- **Estado que precisa persistir entre sessões** (tema, volume, velocidade,
  equalizador): `PreferencesStore` (`core/prefs/`, sobre `shared_preferences`).
  Não `StateProvider`, não drift. Posição de escuta e assinaturas continuam
  em drift (`LibraryRepository`).
- **`StateProvider`** não vem mais de `flutter_riverpod.dart` (Riverpod 3
  moveu pra `.../legacy.dart`) — preferir `Notifier`/`NotifierProvider`.
- **`AsyncValue.valueOrNull` não existe** no Riverpod 3.4.3 — usar `.value`
  (já nullable).
- **Provider `@Riverpod(keepAlive: true)` só pode depender de outro
  `keepAlive`** (`riverpod_lint: only_use_keep_alive_inside_keep_alive`) —
  por isso `dioClientProvider` e `podcastRepositoryProvider` são keepAlive.
- **Freezed 4**: `abstract class Foo with _$Foo` (sem `abstract` dá "Missing
  concrete implementations").
- **Classes geradas pelo drift terminam em `Row`** (`@DataClassName`) — sem
  o sufixo, `EpisodeCache` geraria `Episode` e colidiria com o modelo de
  domínio. Repositórios só devolvem/recebem modelos de domínio, nunca `*Row`.
- **Coluna PK int sem `.autoIncrement()`**: no `.insert()` gerado ela é
  opcional (`Value.absent()`) — pra `Subscriptions.id` (o `collectionId` da
  iTunes) sempre passar `Value(podcast.id)` explícito.
- **Fetch de rede numa tela que pode ter cache local** deve cair pro cache
  no erro (`PodcastDetailViewModel` → `LibraryRepository.cachedEpisodes`) —
  é o que mantém episódio baixado acessível em modo avião.
- **Feeds vivos (v2 Fase 9)**: `LibraryRepository` tem `RssFeedParser`
  injetado. `refreshFeed(id, {force})` / `refreshAllSubscriptions({force})`
  fazem upsert no `episodeCache` e devolvem nº de episódios inéditos; sem
  `force` respeitam `Subscriptions.lastRefreshedAt` (throttle de 1h).
  `PodcastDetailViewModel.build` chama `cacheEpisodesIfSubscribed` (no-op se
  não assinado). `startupFeedRefreshProvider` roda ao abrir o app
  (`AppShell` é `ConsumerWidget`, faz `ref.listen`).
- **`ADD COLUMN NOT NULL` com default de expressão trava o app** — SQLite
  não aceita, a migração drift lança e o banco nunca abre (tela fica no
  shimmer pra sempre, sem erro visível). Coluna nova numa tabela existente:
  **nullable** (`addedAt`, `lastRefreshedAt`), preencher no INSERT pela app,
  backfill na migração. `EpisodeCache.addedAt` (nullable) é a data confiável
  pra "novos"; `null` = já estava no cache antes da v3.
- **`RssFeedParser` parseia em `Isolate.run`** — `RssFeed.parse` é síncrono
  e pesado; sem isolate, `refreshAllSubscriptions()` no startup trava a UI
  por segundos. `parseRssEpisodes` é top-level de propósito (sendável).
- **Selecionar episódio não toca**: tocar no card do `_EpisodeTile` abre
  `/episode` (`EpisodeDetailScreen`). Play só via `IconButton` de play do
  tile ou botão "Tocar" da tela — esses passam `autoPlay: true`.
  `PlayerViewModel.playEpisode` tem `autoPlay` default `false`;
  `PodcastAudioHandler.playQueue`/`skipToQueueItem` default `true` (o
  auto-avanço no fim da fila continua). Ao navegar pro player, **não**
  esperar `playEpisode` terminar antes do `context.push` (a tela já mostra
  `isBuffering`).
- **Botão de download / progresso de episódio só com podcast assinado** —
  `Downloads`/`EpisodeCache`/`PlaybackProgress` têm FK em `Subscriptions.id`.
- **Filtro/ordenação de episódio** é a função pura `applyEpisodeControls`
  (`episode_list_controls.dart`, sem Flutter). Aba "Baixados" vem de
  `LibraryRepository.watchDownloadedEpisodes` e reusa o `_EpisodeTile`.
- **Estado de erro dentro de container de altura fixa** (carrossel) não pode
  ser `EmptyState` (estoura RenderFlex) — card compacto (`_CarouselError`).
- **Hero da capa**: `podcast-artwork-<id>` em toda tela; a tela de episódio
  usa `episode-artwork-<guid>` pra não colidir com o mini-player.
- **`rss_dart`, não `webfeed_plus`** (fixa `intl ^0.19.0`, quebra go_router 18).
- **Não declarar `sqlite3_flutter_libs`** — publicado `0.6.0+eol`,
  `drift_flutter` já resolve o sqlite nativo.

## Notas de plataforma / libs (por que o código é assim)

- **iTunes Search API + Apple Charts devolvem `Content-Type: text/javascript`**
  — o decoder automático do Dio não pega. Os data sources pedem
  `ResponseType.plain` e fazem `jsonDecode` na mão. Seguir esse padrão pra
  qualquer API que não declare `application/json`.
- **iTunes `/lookup` não devolve na ordem dos ids** —
  `PodcastRepository._resolveRanked` reordena pelo índice pedido (o rank do
  carrossel) e descarta id sem `feedUrl`. genreIds de categoria são
  hardcoded em `lib/features/discover/podcast_genres.dart`.
- **`flutter_downloader` roda em isolate de background separado** — a volta
  pro isolate principal é `IsolateNameServer`/`ReceivePort` (não Riverpod).
  O callback top-level (`downloadCallback`) só repassa; quem trata é
  `DownloadService`. O warning KGP no build Android é upstream (o plugin
  aplica o Kotlin Gradle Plugin) — mitigado com `android.builtInKotlin=false`
  em `gradle.properties`, builda normal.
- **Emulador Android mata o `AudioService` por "app idle"** depois de ~2m30s
  de tela apagada, mesmo com foreground service — energia do emulador, não
  bug (ver ROADMAP Fase 4).
- **Equalizador só existe no Android** (`just_audio`); volume funciona nos
  dois. `AndroidEqualizer` entra no `AudioPipeline` **na construção** do
  `AudioPlayer` (`_player` é `late final`) — não dá pra adicionar depois.
  `AndroidEqualizer.parameters` só resolve depois de um áudio carregado, por
  isso `_loadEqualizer()` roda no fim de `playEpisode`. Dois checks de
  plataforma, de propósito: `Platform.isAndroid` no ViewModel (OS do host —
  `false` em `flutter test`, mantém o teste rápido) e
  `defaultTargetPlatform == TargetPlatform.android` na View (alvo, pra UI).
  Nº de bandas e faixa de dB variam por device — presets
  (`equalizerPresetGains`, pura) interpolam uma curva de 5 pontos e fazem
  `clamp(minDb, maxDb)`.

## Setup de teste

- **Overrides obrigatórios** em qualquer teste que monte `PodcastApp`,
  `PlayerScreen`/`MiniPlayer`/`EpisodeDetailScreen` ou construa
  `PlayerViewModel`/`themeModeProvider`:
  `audioHandlerProvider.overrideWithValue(PodcastAudioHandler())` e
  `preferencesStoreProvider.overrideWithValue(await fakePreferencesStore())`
  (helper em `test/support/fake_preferences.dart`). Sem eles o provider
  lança `UnimplementedError` e o widget tree quebra (às vezes aparece como
  "RenderFlex overflow", não como o erro real).
- **Widget test de tela real** precisa de `MaterialApp(theme: AppTheme.light())`
  — senão `Theme.of(context).extension<AppColors>()!` estoura null-check.
- **Provider `autoDispose` em `ProviderContainer`** precisa de um listener
  permanente (`container.listen(provider, (_, _) {})` no `setUp`) — senão o
  notifier (e seus `Timer`s, ex: debounce do `DiscoverViewModel`) é
  derrubado antes do `await`.
- **`test()` puro que instancia `PodcastAudioHandler`** precisa de
  `TestWidgetsFlutterBinding.ensureInitialized()` (o `just_audio.AudioPlayer`
  do construtor registra method channel handler).
- **`HtmlWidget` vira `RichText`** — em teste usar `find.byType(HtmlWidget)`,
  não `find.textContaining`.
- **Teste de repositório drift**: `AppDatabase(NativeDatabase.memory())`
  (`package:drift/native.dart`) + `tearDown(() => db.close())`. Inserir a
  `Subscriptions` antes de qualquer linha com FK.

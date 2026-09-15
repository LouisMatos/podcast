# CLAUDE.md

Guidance pra Claude Code trabalhar neste repositório.

## Modo obrigatório

Toda sessão neste repo: ativar caveman ultra + ponytail ultra antes de
qualquer resposta/ação. Persiste sessão inteira, sem re-drift.

## Repositório

App escuta podcast, Android/iOS. `frontend/` = app Flutter (único código
hoje). `backend/` = reservada, vazia de propósito (app local-only, sem
login/sync, SQLite via `drift`).

Antes de trabalhar, ler `docs/ROADMAP.md` (v1, Fases 0–8), `docs/ROADMAP_V2.md`
(Fases 9–18, concluída), `docs/roadmap_v3.md` (Fases 19+, "Onde parei" no
topo diz o que falta) e `docs/roadmap_debito_tecnico.md` (dívida deferida —
não mexer sem pedir). Fonte de verdade do estado; atualizar fim de cada fase.
Trabalho novo = uma fase de um desses.

## Estilo de resposta

pt-BR, curto, sem enrolação, sem repetir o que código/tool output/diff já
mostrou. Referenciar arquivo por caminho:linha em vez de recolar. Grep/Glob
em vez de varrer diretório; ler só trecho necessário. Porquê de decisão
técnica = 1 frase. Sem resumo redundante após Edit/Write/Bash (resultado já
visível), sem banner/tabela decorativa, confirmação de ação = 1 linha.
**Código gerado (Edit/Write) nunca leva comentário, nenhum caso — nem de
docstring, nem de "por quê" — só código.** Prioriza tokens/velocidade sobre
documentação inline; decisão técnica não-óbvia vai na mensagem de resposta,
não no arquivo.

## Mapa

v1+v2 completas (Fases 0–18); v3 Fases 19–26b + 24 concluídas, só 26c
pendente (Android Auto real — precisa Desktop Head Unit ou carro,
`docs/roadmap_v3.md`).

```text
podcast/
  docs/            ROADMAP*.md, roadmap_v3.md, roadmap_debito_tecnico.md,
                    ARCHITECTURE.md (contrato MVVM), DESIGN_SYSTEM.md
  backend/         placeholder
  frontend/
    pubspec.yaml, analysis_options.yaml (exclui *.g.dart/*.freezed.dart)
    scripts/       run_android.sh, gen.sh (build_runner)
    lib/
      main.dart      runZonedGuarded; init síncrona (AudioService/
                      FlutterDownloader/Workmanager/notifications/shortcuts)
                      antes do runApp; FeedSyncScheduler pós-frame
      app.dart        ProviderScope/MaterialApp.router
      core/           theme/, router/ (abas Início/Descobrir/Biblioteca/
                      Ajustes; /podcast /episode /player /resolve/* topo),
                      network/ (Dio+RetryInterceptor), database/ (drift v7),
                      diagnostics/ (ErrorLog), prefs/ (PreferencesStore),
                      widgets/ (SoftCard, PillButton, ...)
      data/           models/, sources/ (itunes_search_api, apple_charts_api,
                      rss_feed_parser, DAOs), repositories/ (Podcast,
                      Library, Download, Queue)
      features/       home/, discover/(+category/), library/(+search/),
                      podcast_detail/, episode_detail/, subscribe_feed/,
                      deeplink/, history/, stats/, settings/(+downloads/),
                      player/ (bottom sheet — ver Arquitetura)
      services/       audio/ (PodcastAudioHandler, equalizer+loudness),
                      download/, notifications/, sync/ (WorkManager),
                      chapters/, deeplinks/, opml/, share/, shortcuts/,
                      battery/
    test/           215 testes, espelha lib/
    android/        MainActivity : AudioServiceActivity; keystore fora repo
    ios/            build só após Xcode+CocoaPods
```

Nova fase que cria pasta em `lib/`: não precisa atualizar mapa por arquivo,
só se pasta de topo mudar.

## Comandos

De dentro de `frontend/`:

```bash
flutter pub get
dart analyze                    # completo, com riverpod_lint — manter limpo
flutter analyze                 # mais rápido, SEM riverpod_lint
flutter test
flutter test test/caminho_test.dart --plain-name "nome"
dart run build_runner build --delete-conflicting-outputs
./scripts/gen.sh watch
./scripts/run_android.sh        # AVD Pixel_6, codegen se preciso, flutter run
```

`run_android.sh`: `AVD_NAME=`/`BOOT_TIMEOUT=` env, repassa args extras.
iOS não builda nesta máquina (falta Xcode/CocoaPods).

## Arquitetura — MVVM

`View → ViewModel → Repository → Source` (API/RSS/SQLite), dependência só pra
baixo (detalhes em `docs/ARCHITECTURE.md`). View (`features/*/view/`): só
widgets, `ref.watch`/`ref.read(...notifier)`, nunca repositório/API direto.
ViewModel (`features/*/view_model/`): `Notifier`/`AsyncNotifier` por tela via
`@riverpod`, estado Freezed, **nunca importa `material.dart`** (testa sem
widget). Model (`data/repositories/`+`data/sources/`): repositório esconde
origem do dado; sources burros, sem lógica de negócio.

Player é **bottom sheet**, não rota push (`showPlayerSheet`→`PlayerView`,
perde Hero de propósito); rota `/player` só existe pra deep link/Android Auto.

## Design system

Nenhum widget escreve cor/raio/sombra/duração literal — sempre
`lib/core/theme/` (detalhes em `docs/DESIGN_SYSTEM.md`). Paleta pastel
(lavanda/menta/pêssego), sem `Divider`/borda dura (sombra suave), Nunito via
`google_fonts`, animações lentas (`easeOutCubic`/`easeInOutCubicEmphasized`,
nunca linear/bounce), loading = shimmer.

## Stack

`pubspec.yaml`: Riverpod 3+Freezed (MVVM), go_router, dio+`rss_dart`, drift,
just_audio+audio_service, flutter_downloader, shared_preferences,
flutter_widget_from_html_core, workmanager+flutter_local_notifications,
connectivity_plus, sensors_plus (sleep timer), share_plus, quick_actions,
file_picker+xml (OPML), `permission_handler ^13.0.2`
(compileSdk 37 pinado à mão em `android/app/build.gradle.kts`, Fase 24 v3
— Flutter 3.47.2 ainda default pra 36). `app_links` descartado de propósito
(deep link = custom scheme direto no go_router). Flutter 3.47.2+/Dart 3.13.2+
obrigatório (freezed 4+riverpod_generator 4+drift_dev 2.34 juntos).

`dart analyze` roda `riverpod_lint` (plugin nativo); `flutter analyze` não.
`custom_lint` fora de propósito.

Keystore de release fora do repo; senha placeholder `podcast-changeme`
**trocar antes de publicar** (`docs/PLAY_STORE.md`).

## Invariantes (seguir sempre)

- Cor/raio/sombra/duração: nunca literal, sempre `AppColors`/`AppRadii`/
  `AppShadows`/`AppMotion`. `AppColors.onAccent` (não `textPrimary`) sobre
  fill sólido primary/secondary — contraste falha no tema escuro.
- `TabBar`: `dividerColor: Colors.transparent` + `indicatorSize: .label`.
- Estado persistente entre sessões (tema/volume/velocidade/equalizador):
  `PreferencesStore`, não `StateProvider`/drift. Posição/assinaturas ficam
  em drift (`LibraryRepository`).
- Riverpod 3: `StateProvider` vem de `.../legacy.dart` (preferir `Notifier`);
  `AsyncValue.valueOrNull` não existe, usar `.value`; `@Riverpod(keepAlive)`
  só depende de outro keepAlive (por isso `dioClientProvider`/
  `podcastRepositoryProvider` são keepAlive).
- Freezed 4: `abstract class Foo with _$Foo` (sem `abstract` quebra).
- Classes drift terminam em `Row` (`@DataClassName`) — repositórios só
  devolvem modelo de domínio, nunca `*Row`. PK int sem `.autoIncrement()`:
  `.insert()` exige `Value(x)` explícito (`Subscriptions.id`).
- Tela com cache local cai pro cache no erro de rede
  (`PodcastDetailViewModel`→`cachedEpisodes`) — mantém baixado em modo avião.
- Feeds vivos: `LibraryRepository.refreshFeed/refreshAllSubscriptions({force})`
  fazem upsert em `episodeCache`; sem `force` respeita throttle 1h
  (`lastRefreshedAt`). `startupFeedRefreshProvider` roda ao abrir app.
- Refresh background: `feedSyncCallbackDispatcher` (isolate WorkManager,
  `@pragma('vm:entry-point')`) reconstrói `AppDatabase`/`Dio`/
  `LibraryRepository` **sem Riverpod**, mesmo arquivo drift (WAL). 6h,
  constraint `unmetered`/`connected`.
- Arquivar episódio: `EpisodeCache.archived` + configs auto-download/delete/
  velocidade por assinatura (defaults = nada automático). Listas filtram
  `archived == false`; `AutoDownloadService.run()` roda no main isolate.
- `ADD COLUMN NOT NULL` com default de expressão **trava o app** (SQLite
  rejeita, migração lança, banco não abre). Coluna nova: nullable, backfill
  na migração.
- `RssFeedParser` parseia em `Isolate.run` (síncrono/pesado, travaria UI).
- Tocar episódio não toca áudio — abre `/episode`; play só via botão
  (`autoPlay: true`). Não esperar `playEpisode` antes de abrir o sheet.
- Fila: `QueueItems` reescrito inteiro a cada mutação; `queueProvider`
  (keepAlive) é fonte de verdade, `PlayerViewModel` espelha via
  `ref.listen`→`_syncQueue`. Item em foco = índice 0. `playEpisode` preserva
  resto da fila. `await` sempre seguido de `if (!ref.mounted) return`.
- Download/progresso só com podcast assinado (FK `Subscriptions.id`);
  exceção `listen_history` (sem FK, sobrevive a desassinar).
- Filtro/ordenação = função pura `applyEpisodeControls`.
- Erro em container de altura fixa (carrossel): card compacto, não
  `EmptyState` (estoura RenderFlex).
- Hero: `podcast-artwork-<id>` geral, `episode-artwork-<guid>` na tela de
  episódio (não colide com mini-player).
- `rss_dart` (não `webfeed_plus`, quebra go_router). Não declarar
  `sqlite3_flutter_libs` (`drift_flutter` já resolve).
- Deep link desconhecido → `/resolve/invalid` explícito + snackbar, nunca
  redirect silencioso pra Home.
- `AndroidLoudnessEnhancer`/`AndroidEqualizer` entram no `AudioPipeline` na
  construção do `AudioPlayer` — não dá pra adicionar depois.

## Notas de plataforma

iTunes/Apple Charts devolvem `Content-Type: text/javascript` —
`ResponseType.plain` + `jsonDecode` manual (padrão pra qualquer API sem
`application/json`). `/lookup` não devolve na ordem dos ids —
`_resolveRanked` reordena, descarta sem `feedUrl`; genreIds hardcoded em
`podcast_genres.dart`. `flutter_downloader` roda em isolate próprio, volta
via `IsolateNameServer` (não Riverpod); warning KGP é upstream, mitigado
`android.builtInKotlin=false`. Emulador mata `AudioService` por "app idle"
~2m30s tela apagada (energia do emulador, não bug). Equalizer/loudness só
Android; `AndroidEqualizer.parameters` só após áudio carregado
(`_loadEqualizer()` no fim de `playEpisode`); `Platform.isAndroid` no
ViewModel, `defaultTargetPlatform` na View; presets interpolam curva 5
pontos com `clamp`. Android Auto sem teste automatizado (precisa DHU/carro).
`RetryInterceptor` só re-tenta GET timeout/502-504 (POST/DELETE não são
idempotentes) — backoff `200ms·2^n`+jitter, cap 5s.

## Setup de teste

Testes que montam `PodcastApp`/`PlayerScreen`/`MiniPlayer`/
`EpisodeDetailScreen` ou `PlayerViewModel`/`themeModeProvider`: overrides
`audioHandlerProvider`+`preferencesStoreProvider` (`fakePreferencesStore()`
em `test/support/`) obrigatórios, senão `UnimplementedError` (às vezes
mascarado como "RenderFlex overflow"). Widget test de tela real precisa
`MaterialApp(theme: AppTheme.light())`. `autoDispose` em `ProviderContainer`
precisa listener permanente no `setUp` (senão `Timer`s morrem antes do
`await`). Teste puro com `PodcastAudioHandler`:
`TestWidgetsFlutterBinding.ensureInitialized()`. `HtmlWidget` vira
`RichText` em teste — usar `find.byType`, não `find.textContaining`.
Repositório drift: `NativeDatabase.memory()` + `tearDown(close)`, inserir
`Subscriptions` antes de FK; **trava dentro de `testWidgets`** — nesse caso
sobrescrever provider de dados, não `appDatabaseProvider`; widgets de
player/app também precisam `queueProvider.overrideWith(Stream.value([]))`.
`updatedAt`/`publishedAt` são unix em segundos — ordem por data precisa >1s
de gap real. `/podcast` é rota de topo (root nav, próprio `MiniPlayer`);
`/home` é `initialLocation`.

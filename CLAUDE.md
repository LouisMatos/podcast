# CLAUDE.md

## Modo & Regras de Resposta (Economia Extrema de Tokens)
- **Modo Ativo**: Ativar `caveman ultra` + `ponytail ultra` na 1ª mensagem da sessão.
- **Zero Comentários**: NUNCA adicionar comentários em código gerado (`Edit`/`Write`) — sem docstrings, sem explicações inline.
- **Respostas Ultra-secas**:
  - Referências: apenas `caminho/arquivo.dart:linha`.
  - Não recolar código, diffs ou saídas de ferramentas que já estão visíveis.
  - Decisões técnicas = máximo 1 frase na mensagem (nunca no arquivo).
  - Confirmações = 1 linha. Sem tabelas decorativas ou banners.
  - Busca: usar `grep`/`glob` focado. Ler estritamente as linhas necessárias.

## Estado do Projeto
App Flutter de podcasts (local-only, SQLite via `drift`). `frontend/` (ativo), `backend/` (vazio).
- **Status**: v1/v2 completas; v3 Fases 19–26b + 24 prontas; PENDENTE apenas 26c (Android Auto real).
- **Documentos-Fonte**: `docs/ROADMAP.md`, `docs/ROADMAP_V2.md`, `docs/roadmap_v3.md`. Dívida técnica em `docs/roadmap_debito_tecnico.md` (NÃO alterar sem autorização).

## Protocolo de Sessão ⚡
1. **Início (Obrigatório)**: Ler `.claude/SESSION_CONTEXT.md`. Consultar `.claude/COMMON_MISTAKES.md`, `.claude/QUICK_START.md`, `.claude/ARCHITECTURE_MAP.md` somente sob demanda (ex.: bater em erro recorrente → ler COMMON_MISTAKES.md).
2. **Fim de Tarefa**: Criar `.claude/completions/YYYY-MM-DD-nome.md`, mover sessão para `.claude/sessions/archive/`.
3. **Proibido carregar sem pedido**: `.claude/completions/`, `.claude/sessions/`, `docs/archive/`.

## Leitura Seletiva de Referências 📖
**Regra**: Sempre comece uma feature/sessão lendo APENAS `.claude/SESSION_CONTEXT.md`. Abra os demais arquivos somente se:
- **Encontrar erro que pareça recorrente** → abra `.claude/COMMON_MISTAKES.md` (búsca rapida via `grep` do padrão de erro).
- **Precisar entender fluxo arquitetural não mapeado em SESSION_CONTEXT** → abra `.claude/ARCHITECTURE_MAP.md`.
- **Precisar de lista completa de comandos** → abra `.claude/QUICK_START.md`.
- **Não abra nenhum antes de começar a feature** — evita sobrecarga de tokens desnecessária.

## Comandos (em `frontend/`)
- `dart analyze` (completo + riverpod_lint) | `flutter analyze` (rápido, sem lint)
- `flutter test` | `flutter test test/caminho_test.dart --plain-name "nome"`
- `dart run build_runner build --delete-conflicting-outputs` | `./scripts/gen.sh watch`
- `./scripts/run_android.sh` (AVD Pixel_6) | *iOS desativado nesta máquina (sem Xcode)*

## Arquitetura & Stack
- **MVVM**: `View → ViewModel → Repository → Source` (dependência estritamente top-down).
  - `View` (`features/*/view/`): Apenas widgets (`ref.watch`/`ref.read`). PROIBIDO repositório/API direto.
  - `ViewModel` (`features/*/view_model/`): `Notifier`/`AsyncNotifier` (`@riverpod`), estado Freezed. PROIBIDO importar `material.dart`.
  - `Model` (`data/repositories/` + `data/sources/`): Sources burros, sem lógica de negócio.
- **Player**: Bottom sheet (`showPlayerSheet` → `PlayerView`). Rota `/player` é exclusiva para deep links/Android Auto.
- **Design System**: Centralizado em `lib/core/theme/` (`AppColors`, `AppRadii`, `AppShadows`, `AppMotion`). PROIBIDO cor/raio/sombra/duração literal. Use `AppColors.onAccent` sobre fills primary/secondary.
- **Stack**: Flutter 3.47.2+ / Dart 3.13.2+, Riverpod 3 + Freezed 4, go_router, Dio + `rss_dart`, Drift v7, just_audio + audio_service, workmanager + flutter_local_notifications. `permission_handler ^13.0.2` (compileSdk 37 pinado em `build.gradle.kts`). `app_links` e `custom_lint` descartados.

## Invariantes & Regras Técnicas
- **Riverpod 3 / Freezed 4**:
  - `StateProvider` via `.../legacy.dart` (preferir `Notifier`). Use `.value` em vez de `.valueOrNull`.
  - `@Riverpod(keepAlive)` só depende de outro keepAlive (`dioClientProvider`, `podcastRepositoryProvider`).
  - Freezed 4: obrigatoriamente `abstract class Foo with _$Foo`.
- **Drift (SQLite)**:
  - `@DataClassName` termina em `Row`. Repositórios usam modelos de domínio, nunca `*Row`.
  - PK int sem `.autoIncrement()` exige `Value(x)` no `.insert()` (`Subscriptions.id`).
  - Colunas novas: SEMPRE nullable (evita crash SQLite `ADD COLUMN NOT NULL`).
- **Feeds & Background Sync**:
  - Erro de rede: cai para o cache local (`PodcastDetailViewModel` → `cachedEpisodes`).
  - `LibraryRepository.refreshFeed/refreshAllSubscriptions({force})`: upsert em `episodeCache`, throttle 1h (`lastRefreshedAt`).
  - Refresh Background: `feedSyncCallbackDispatcher` (WorkManager, `@pragma('vm:entry-point')`) reconstrói DB/Dio/Repo SEM Riverpod (WAL, 6h, unmetered/connected).
  - `RssFeedParser`: executa em `Isolate.run`.
- **Player & Fila**:
  - `queueProvider` (keepAlive) é SSOT. Item em foco = índice 0. `playEpisode` preserva resto da fila.
  - `PlayerViewModel` espelha fila via `ref.listen` → `_syncQueue`.
  - Sempre usar `if (!ref.mounted) return` após `await`.
  - Abrir episódio navega para `/episode` (não toca áudio). Play só via botão (`autoPlay: true`).
- **Download & Arquivamento**:
  - Progresso/download exige podcast assinado (`Subscriptions.id`); exceção: `listen_history`.
  - `EpisodeCache.archived`: listas filtram `archived == false`. `AutoDownloadService.run()` no main isolate.
- **Geral**:
  - Deep link desconhecido → `/resolve/invalid` + snackbar.
  - Container com altura fixa em erro: card compacto (não `EmptyState`).
  - Hero: `podcast-artwork-<id>` geral, `episode-artwork-<guid>` na tela de episódio.
  - Audio pipeline: `AndroidLoudnessEnhancer`/`AndroidEqualizer` inseridos na construção do `AudioPlayer`.

## Notas de Plataforma
- **iTunes/Apple API**: Devolve `Content-Type: text/javascript` → `ResponseType.plain` + `jsonDecode` manual. `/lookup` reordenado via `_resolveRanked`.
- **Audio/Equalizer**: Equalizer/loudness apenas Android (`AndroidEqualizer.parameters` após áudio carregado em `_loadEqualizer()`).
- **Dio Retry**: `RetryInterceptor` refaz apenas GET timeout/502-504 (backoff `200ms·2^n`+jitter, max 5s).
- **Emulador**: Mata `AudioService` por app idle ~2m30s tela apagada (comportamento esperado em emulador).

## Setup de Teste
- **Overrides Obrigatórios**: `audioHandlerProvider` + `preferencesStoreProvider` (`fakePreferencesStore()`) para widgets de app/player/tela.
- **Widget Tests**: `MaterialApp(theme: AppTheme.light())`. `HtmlWidget` vira `RichText` (`find.byType`).
- **ProviderContainer**: `autoDispose` exige listener no `setUp`.
- **Testes Drift**: `NativeDatabase.memory()` + `tearDown(close)`. Inserir `Subscriptions` antes de FK. Se congelar em `testWidgets`, sobrescrever provider de dados (não `appDatabaseProvider`) e adicionar `queueProvider.overrideWith(Stream.value([]))`.
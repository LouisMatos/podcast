# Roadmap v2 — evolução (Android)

> **Continuação do `docs/ROADMAP.md`.** A v1 (Fases 0–8) entregou o app
> funcional: descobrir, assinar, tocar em background, baixar offline,
> equalizador, tela de episódio. A v2 é sobre **experiência**: tornar o uso
> linear, agradável e fluido — abrir o app e já saber o que ouvir, fila de
> verdade, menos fricção.
>
> **Menu priorizado.** Fases numeradas a partir da 9, numa ordem sugerida por
> dependência + impacto. Cada uma é independente e shippável — dá pra seguir
> na ordem, pular, ou parar no meio de qualquer uma (sub-fases quando grande).

## Onde parei

**Fase 14 concluída** (player avançado). 123 testes, `dart analyze` limpo,
verificado no emulador (schema v6 migra, capítulos, sleep timer com shake,
normalização de volume, pular silêncio). Próximo: **Fase 15** (transições e gestos).
Sequência recomendada: **9 ✅ → 11 ✅ → 12 ✅ → 10 ✅ → 13 ✅ → 14 ✅ → 15 → 16 → 17 → 18**.

## Regra de ouro (por fase)

Herda da v1. Toda fase termina com:

- `dart analyze` limpo (roda `riverpod_lint`; `flutter analyze` **não** roda o
  plugin — usar `dart analyze`).
- `flutter test` verde — **os testes das Fases 0–8 continuam passando** (zero
  regressão é requisito, não meta).
- App rodando via `./scripts/run_android.sh`.
- Commit `feat:`/`chore: fase N — ...`.
- `docs/ROADMAP_V2.md` (checkboxes + "Onde parei") e `CLAUDE.md` (mapa/notas se
  mudou) atualizados.

Regras que não mudam: MVVM (`docs/ARCHITECTURE.md`), design system
(`docs/DESIGN_SYSTEM.md` — cor/raio/sombra/duração só de `core/theme/`).
Migração drift: bloco `if (from < N)` sequencial, bump `schemaVersion`,
adicionar schema test. Dep nova: `flutter pub get` + `dart analyze` logo
depois (`intl`/`analyzer` já causaram conflito na v1).

## Premissas (confirmadas)

- **Local-only** — sem backend, sem conta, sem sync entre aparelhos. Tudo em
  SQLite (drift) + `shared_preferences`.
- **Só Android** — iOS segue pausado (Fase 7 da v1).
- **Vai publicar na Play Store** — por isso a Fase 18 (assinatura de release,
  política de privacidade) é real, não "algum dia". Antecipar a assinatura de
  release se for publicar antes de terminar a v2.
- OK adicionar dependências quando a feature exigir.

---

## Fase 9 — Feeds vivos (cache que atualiza) · CRÍTICO · esforço M ✅

**Problema:** o `episodeCache` de um podcast assinado **congela na hora da
assinatura**. `PodcastDetailViewModel.build` buscava o RSS ao vivo mas nunca
persistia. Nada no app sabia que saiu episódio novo.

- [x] `PodcastDetailViewModel.build`: chama
      `LibraryRepository.cacheEpisodesIfSubscribed(podcast.id, episodes)` após
      o fetch — no-op se não assinado (a FK barra). `refresh()` novo pro
      pull-to-refresh (`invalidateSelf` + `future`).
- [x] `LibraryRepository` ganha `RssFeedParser` injetado.
      `refreshFeed(podcastId, {force})` — rebusca RSS, upsert no cache,
      devolve nº de episódios inéditos (diff por `guid`); sem `force` pula se
      `lastRefreshedAt` < 1h. `refreshAllSubscriptions({force})` — itera todos,
      engole erro por feed.
- [x] Schema drift **v3**: `EpisodeCache.addedAt`
      (`dateTime().withDefault(currentDateAndTime)`) +
      `Subscriptions.lastRefreshedAt` (`dateTime().nullable()`). Migração
      `if (from < 3)` com dois `addColumn`.
- [x] `startupFeedRefreshProvider` (`features/library/view_model/`) —
      `refreshAllSubscriptions()` ao abrir o app; `AppShell` virou
      `ConsumerWidget` e faz `ref.listen` nele (throttle por feed evita
      spam de rede).
- [x] Pull-to-refresh na aba "Episódios" do detalhe (`RefreshIndicator` →
      `notifier.refresh()`).
- [x] Testes: `library_repository_test` grupo "Fase 9" (5 novos, 60 no total)
      — traz episódio novo, não duplica, throttle sem `force`,
      `refreshAllSubscriptions` ignora feed que falha, `cacheEpisodesIfSubscribed`
      no-op sem assinatura.

**Não quebrou:** `subscribe` continua cacheando na assinatura; fallback
offline (`cachedEpisodes`) agora tem dado fresco.

### Hotfix Fase 9 — migração travava a tela no shimmer

Achado testando com o banco v2 real (5 assinaturas, 4517 episódios em cache):
a tela de detalhe ficava presa no shimmer, nunca carregava.

- **Causa**: `EpisodeCache.addedAt` era `NOT NULL` com default
  `currentDateAndTime`. SQLite **não aceita `ALTER TABLE ADD COLUMN NOT NULL`
  com default de expressão** → a migração v2→v3 lançava exceção → o banco
  nunca abria → `PodcastDetailViewModel.build` ficava pendente pra sempre.
- **Fix**: `addedAt` e `lastRefreshedAt` agora **nullable**. `_cacheEpisodes`
  preenche `addedAt` no INSERT de episódio novo (`insertOrIgnore` preserva o
  valor de quem já está no cache; segunda passada com
  `insertAllOnConflictUpdate` atualiza só os metadados). Migração faz backfill
  `added_at = published_at` nos episódios já cacheados.
- **Bônus**: o parse de RSS (`RssFeedParser`) agora roda em `Isolate.run` —
  era síncrono na main isolate, e `refreshAllSubscriptions()` no startup
  parseava 5 feeds grandes seguidos, travando a UI por segundos.
- **Teste novo**: `test/core/database/migration_v2_to_v3_test.dart` — monta um
  banco v2 na mão (via `sqlite3`), abre com `AppDatabase`, confirma que a
  migração roda, as colunas entram e os dados sobrevivem. 61 testes no total.
- Teste formal com o schema tooling do `drift_dev` ainda fica pra Fase 18.

## Fase 10 — Refresh em background + notificação de episódio novo · ALTO · M ✅

- [x] Dep `workmanager ^0.10.10` — task periódica (6h; ~15min é o mínimo real
      do Android). `feedSyncCallbackDispatcher` (`services/sync/background_sync.dart`,
      `@pragma('vm:entry-point')`) reconstrói banco+Dio+`LibraryRepository`
      **sem Riverpod** e chama `refreshAllSubscriptions()`. `FeedSyncScheduler`
      (`services/sync/`) registra/cancela conforme a preferência —
      `ExistingPeriodicWorkPolicy.update`, constraint de rede
      `unmetered`/`connected` conforme "só Wi-Fi".
- [x] Dep `flutter_local_notifications ^22.3.0` — `NotificationService`
      (`services/notifications/`): 1 notificação por podcast (id = `podcast.id`,
      substitui) + resumo do grupo se >1 podcast. Tocar abre `/home`.
      `permission_handler` **não** foi preciso — a própria fln pede
      `POST_NOTIFICATIONS` (`requestNotificationsPermission`).
- [x] `LibraryRepository`: `refreshFeed` devolve `List<Episode>` inéditos;
      `refreshAllSubscriptions` devolve `List<FeedRefreshResult>`
      (`{podcast, newEpisodes}`) — só os feeds que tiveram episódio novo.
- [x] Ajustes → seção "Atualização" (`_FeedRefreshCard`): atualizar em segundo
      plano / só no Wi-Fi / avisar de episódio novo.
      `feedRefreshSettingsProvider` (Notifier) persiste no `PreferencesStore` e
      reagenda; ligar a notificação pede permissão (negada → volta pra off).
- [x] `main.dart`: `Workmanager().initialize` + `NotificationService.create` +
      `FeedSyncScheduler().apply(...)` conforme a preferência ao abrir.
- [x] Manifest: `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED`.
      `build.gradle.kts`: core library desugaring (`desugar_jdk_libs 2.1.4`,
      exigência da fln).
- [x] Testes: `notification_service_test` (4 — formatação 1/N/resumo),
      `feed_refresh_settings_test` (6 — persistência, reagenda, permissão
      negada), `library_repository_test` Fase 9 atualizado pro novo retorno.

**Não quebrou:** permissão negada → refresh segue, só sem notificação.
`startupFeedRefreshProvider` continua (agora soma `newEpisodes.length`).

Armadilha: o isolate de background do WorkManager abre o **mesmo** arquivo
drift que o app — SQLite WAL cobre 1 escritor + N leitores entre isolates.
`refreshAllSubscriptions()` respeita o throttle de 1h por feed, então rodar a
task logo após um refresh não rebusca nada (nem notifica).

## Fase 11 — Aba Início · CRÍTICO · M ✅

**O payoff.** Abrir o app e já saber o que ouvir, sem caçar.

- [x] `LibraryRepository`: `watchContinueListening({limit})` (cross-assinatura —
      `PlaybackProgress` onde `!completed && positionSeconds > 0`, por
      `updatedAt` desc, join `episodeCache` × `subscriptions`) e
      `watchRecentEpisodes({limit})` (episódios com data de todas as
      assinaturas, `publishedAt` desc). Typedefs `ContinueListeningItem` /
      `RecentEpisodeItem`.
- [x] `features/home/` — `home_providers.dart` (`continueListeningProvider`,
      `recentEpisodesProvider`, streams reativos, padrão do `DownloadsViewModel`)
      + `HomeScreen`: seção "Continuar ouvindo" (carrossel de cards com barra
      de progresso), "Novos episódios" (lista). Pull-to-refresh →
      `refreshAllSubscriptions(force: true)`. Estado vazio aponta pra Descobrir.
- [x] `AppShell`: 4ª aba "Início" (`Icons.home_outlined`), **primeira**,
      `initialLocation` = `/home`. `app_router.dart` ganha o branch.
- [x] Navegação path-agnostic: **detalhe do podcast virou rota de topo
      `/podcast`** (root nav, monta o próprio `MiniPlayer` como `/episode`).
      `/discover/podcast` e `/library/podcast` saíram. Todos os tiles
      (`PodcastListTile`, `_RankedPodcastCard`, `_SubscriptionTile`) apontam
      pra `/podcast`.
- [x] Tiles de episódio da Início abrem `/episode` (`queue: [episode]`).
- [x] Testes: `library_repository_test` grupo "Fase 11" (3 novos, 64 total);
      `widget_test` atualizado (abre na Início; overrides dos providers de
      Início — `NativeDatabase` trava dentro de `testWidgets`, então usa
      `overrideWith(Stream.value([]))`).

**Não quebrou:** Descobrir/Biblioteca/Ajustes intactos — entrou 1 aba.
`IndexedStack` mantém estado das 4.

Armadilha: `AppDatabase(NativeDatabase.memory())` **trava dentro de
`testWidgets`** (funciona em `test()` puro). Em widget test, sobrescrever os
providers de dados, não o `appDatabaseProvider`.

## Fase 12 — Fila de reprodução real · CRÍTICO · esforço G ✅

**Problema:** a "fila" era só a lista do podcast atual, recarregada inteira a
cada play, sumia ao fechar o app.

- [x] Schema drift **v4**: tabela `QueueItems` — `position` (0-based, contígua,
      reescrita a cada mutação), `podcastId`/`episodeGuid` (PK) + dados de
      podcast/episódio **desnormalizados** (a fila pode ter episódio de podcast
      não assinado, sem linha em `episodeCache`/`subscriptions` pra join).
      Migração `if (from < 4) createTable`.
- [x] `QueueRepository` (`data/repositories/queue_repository.dart`) —
      `watchQueue`/`currentQueue`, `playNow` (põe na frente, preserva o resto),
      `addToEnd`, `playNextAfter` (após o item atual), `removeAt`/`removeEpisode`,
      `move`, `replaceWith`, `clear`. Toda escrita é uma transação que reescreve
      a tabela com posições 0..n. `queueProvider` (`@Riverpod(keepAlive:true)`,
      stream) é a fonte de verdade da ordem.
- [x] `PodcastAudioHandler`: `setQueue(items, {playFirst})` espelha a fila
      persistida; `skipToNext`/`_advance` **consome a frente** (item em foco =
      índice 0) e chama `onItemConsumed` (callback pro `PlayerViewModel`
      remover da fila persistida). `skipToPrevious` = volta ao início do
      episódio (sem histórico). `_onEpisodeCompleted` = `_advance`.
      `MediaItem.extras` carrega `guid`/`podcastId`.
- [x] `PlayerViewModel`: `playEpisode` → `queueRepo.playNow` (não recebe mais
      `List<Episode> queue`). `enqueue`/`playNext`/`enqueueAll`/`removeFromQueueAt`/
      `reorderQueue`/`clearQueue`. `ref.listen(queueProvider)` → `_syncQueue`
      re-espelha no handler sem recarregar o áudio (guarda por lista de ids).
      `_entries` resolve podcast/episódio do `MediaItem` que passa a tocar.
- [x] UI: `QueueMenuButton` (menu "⋮" — Tocar a seguir / Adicionar à fila) nos
      tiles de episódio (detalhe do podcast, "Novos episódios" da Início);
      botões na `EpisodeDetailScreen` + "Enfileirar próximos (N)" quando aberta
      de uma lista; sheet de fila no player (`ReorderableListView` com
      `onReorderItem`, remover item, badge com contagem, "Limpar"); "A seguir:
      …" no player.
- [x] **Decisão b:** tocar um episódio = `playNow` (vai pra frente, preserva a
      fila existente). Não substitui a fila pela lista inteira do podcast; não
      auto-continua o podcast. Enfileirar os seguintes é ação explícita.
- [x] Testes: `queue_repository_test` (10 — ordem/reindex, playNow, playNextAfter,
      move/removeAt, cross-podcast, rehidratação); `migration_v3_to_v4_test`;
      `player_view_model_test` atualizado (`setQueue`/`_MockQueue`). 74 no total.

**Não quebrou:** "não toca ao selecionar" (Fase 8.3) intacto — `playEpisode`
default `autoPlay: false`. Retomar posição salva (Fase 3) e tocar do arquivo
baixado (Fase 5) seguem em `playEpisode`. Auto-avanço no fim continua (agora
consumindo a fila).

Armadilha: `PlayerViewModel` é `keepAlive` → todo provider que ele consome
tem que ser `keepAlive` (`queueProvider`). E `playEpisode`/`_syncQueue` fazem
`if (!ref.mounted) return` depois de cada `await` (senão um teste que não
espera a Future explode com "Ref after dispose").

## Fase 13 — Gestão de episódios · ALTO · M ✅

- [x] Marcar ouvido / não-ouvido manual — `LibraryRepository.setEpisodeCompleted`
      (grava `PlaybackProgress.completed`, zera a posição). No menu "⋮" do tile
      (`QueueMenuButton` ganhou `manage`), só pra podcast assinado.
- [x] Arquivar episódio — schema **v5**: `EpisodeCache.archived`
      (`boolean().withDefault(false)`). `setEpisodeArchived` +
      `watchArchivedGuids`. Some de `watchEpisodes`/`watchRecentEpisodes`/
      `watchContinueListening`; `applyEpisodeControls` ganhou `archivedGuids` +
      `showArchived`; chip "Mostrar arquivados" no detalhe.
- [x] Schema **v5**: `Subscriptions` ganha `autoDownload` (`never`/`wifi`/
      `always`), `autoDownloadLimit` (3), `autoDeletePlayedDays` (0),
      `playbackSpeedOverride` (`real?`). Migração = 5 `addColumn` com default
      constante. `SubscriptionSettings` (typedef) + `watchSubscriptionSettings`/
      `updateAutoManagement`/`setPlaybackSpeedOverride`.
- [x] Auto-download + limpeza — `AutoDownloadService`
      (`services/download/auto_download_service.dart`, dep `connectivity_plus`):
      roda ao fim de `startupFeedRefreshProvider`. Por assinatura com
      `autoDownload != never` (e wifi quando `wifi`), baixa
      `recentUndownloadedEpisodes(limit)`; com `autoDeletePlayedDays > 0`,
      remove `playedDownloadsToPrune(dias)` via `DownloadService.remove`.
- [x] Config por podcast — engrenagem (`Icons.tune`) no AppBar do detalhe
      (só assinado) → `subscription_settings_sheet.dart` (SegmentedButton +
      stepper + ChoiceChips, reativo, escreve direto no repo).
- [x] Velocidade por podcast — `PlayerViewModel.playEpisode` chama
      `_applyPodcastSpeed` (usa `playbackSpeedOverride`, cai pra global).
- [x] Testes: `library_repository_test` grupo "Fase 13" (5),
      `auto_download_service_test` (4), `episode_list_controls_test` (arquivados),
      `migration_v4_to_v5_test`. 95 no total.

**Não quebrou:** defaults = tudo desligado → comportamento idêntico.
Global defaults em Ajustes ficaram de fora (per-podcast cobre; nice-to-have).

## Fase 14 — Player avançado · ALTO · esforço G ✅

- [x] `RssFeedParser`: extrair `podcast:chapters` (URL JSON via namespace XML),
      `itunes:episode`/`season`/`episodeType`, `<link>`, `content:encoded`
      (descrição melhor). Capítulos embutidos no ID3 não expostos por `just_audio`.
- [x] `Episode` + `EpisodeCache` ganham `seasonNumber?`, `episodeNumber?`,
      `episodeType?`, `link?`, `chaptersUrl?`. Schema **v6**. Tabela `Chapters`
      (`podcastId`, `episodeGuid`, `startMs`, `title`, `imageUrl?`; PK
      `{podcastId, episodeGuid, startMs}`, sem FK).
- [x] Player: lista de capítulos + pular capítulo + capítulo atual destacado +
      no título da notificação (via `MediaItem.displaySubtitle`).
- [x] Pular silêncio: `_player.setSkipSilenceEnabled(true)` (ExoPlayer, Android) —
      toggle no player, persistido em prefs.
- [x] Normalização de volume: `AndroidLoudnessEnhancer` no `AudioPipeline`
      (junto do `AndroidEqualizer`, na construção do `_player`) — toggle + slider 0–15 dB.
- [x] Velocidade por podcast — `SubscriptionSettings.playbackSpeedOverride`,
      já entregue na **Fase 13** (`_applyPodcastSpeed`, cai pra global).
- [x] Sleep timer: "fim do episódio" + "agitar pra estender 5min"
      (dep `sensors_plus`, acelerômetro real em Android/iOS apenas).
- [x] Corpo do player rolável (`SingleChildScrollView` + `ConstrainedBox`) —
      faixa de capítulos + aviso do timer estouravam RenderFlex em telas pequenas.
- [x] Testes: 123 no total (95→123). Novos: parser capítulos + chapters,
      migration v5→v6, `player_state`/`player_view_model` com capítulos/sleep/efeitos,
      player_screen overflow.

**Não quebrou:** tudo opt-in (defaults = desligado); feed sem capítulo funciona igual.
`AndroidLoudnessEnhancer`/`setSkipSilenceEnabled` precisam estar no `AudioPipeline`
na construção do `AudioPlayer` — não dá adicionar depois. `sensors_plus` acelerômetro
só assina em Android/iOS (`Platform.isAndroid || Platform.isIOS`).

## Fase 15 — Transições e gestos (fluidez) · MÉDIO-ALTO · M

- [ ] Mini → full player: sheet arrastável de verdade (custom ou
      `DraggableScrollableSheet`) no lugar de `context.push('/player')` —
      expande de baixo, arrasta pra fechar. `/player` continua como rota (deep
      link, Android Auto).
- [ ] Swipe nos tiles de episódio: → adicionar à fila, ← marcar ouvido
      (`Dismissible` + fundo colorido + snackbar de undo).
- [ ] Haptics (`HapticFeedback`) nos controles principais, ao enfileirar, ao
      completar episódio.
- [ ] Pull-to-refresh onde falta (detalhe do podcast, Biblioteca).
- [ ] Micro-animações: tempo com `AnimatedSwitcher`, progresso suave, troca de
      capítulo. Respeitar `MediaQuery.disableAnimations`.
- [ ] Testes: swipe → ação; reduce-motion.

## Fase 16 — Integrações Android · MÉDIO (ALTO no carro) · esforço G

- [ ] **Android Auto**: árvore do `MediaBrowserService` via `audio_service`
      (`getChildren`/`getMediaItem`/`playFromMediaId`) — raízes "Continuar
      ouvindo", "Fila", "Assinaturas", "Baixados". `<meta-data>` no manifest.
      Testar com Desktop Head Unit.
- [ ] **App shortcuts** (long-press no ícone): "Continuar", "Fila" — dep
      `quick_actions` ou `shortcuts.xml` nativo.
- [ ] **Compartilhar episódio**: dep `share_plus` — link do site/feed +
      timestamp opcional.
- [ ] **Deep links / App Links**: `podcastapp://podcast/<id>`,
      `podcastapp://episode/<guid>` + `https://` App Links (se houver domínio).
      Intent filter `VIEW`/`BROWSABLE` no manifest; `go_router` resolve as rotas.
- [ ] **Abrir feed RSS externo**: intent filter `application/rss+xml` /
      `text/xml` → tela "assinar este feed".
- [ ] Testes: deep link → rota certa; media browser tree (unit).

**Não quebra:** manifest só ganha filtros. Media session atual
(`MediaButtonReceiver`, controles) continua. Precisa de 11+12 pra árvore de Auto.

## Fase 17 — Biblioteca e descoberta · MÉDIO · M

- [ ] Busca de episódios (não só podcasts) — iTunes Search `entity=podcastEpisode`.
- [ ] Busca dentro da biblioteca — episódios de todas as assinaturas (query no
      `episodeCache`).
- [ ] Biblioteca: ordenar/filtrar/agrupar assinaturas (não-ouvidos primeiro,
      recência, alfabético), toggle grade/lista, contador de não-ouvidos por
      podcast.
- [ ] OPML import/export — dep `xml` (provavelmente já transitivo via
      `rss_dart`). Exporta assinaturas; importa e assina em lote.
- [ ] Histórico de escuta — tabela `ListenHistory` ou derivar de
      `PlaybackProgress`. Tela em Ajustes.
- [ ] Estatísticas — tempo total, por semana, streak. Card na Início ou Ajustes.
- [ ] Testes: OPML round-trip; contador de não-ouvidos (drift in-memory).

## Fase 18 — Publicação e robustez · ALTO (pra publicar) · M

- [ ] **Assinatura de release**: keystore + `key.properties` (no `.gitignore`),
      `signingConfigs.release` em `app/build.gradle.kts`, `isMinifyEnabled = true`
      + proguard (`audio_service`, `just_audio`, `drift`, `flutter_downloader`,
      `workmanager`). Fecha dívida da v1.
- [ ] **Play Store**: política de privacidade (página estática — "nenhum dado
      sai do device"), declaração de dados na Console, permissões + porquê.
      `versionCode`/`versionName` de release.
- [ ] **Acessibilidade**: pass de TalkBack (`Semantics`, labels, ordem de
      foco), respeitar tamanho de fonte do sistema, contraste nas telas novas.
- [ ] **Robustez**: interceptor Dio com retry/backoff; estados offline
      consistentes nas telas novas; prompt "desativar otimização de bateria"
      (`Ignore Battery Optimizations` intent).
- [ ] **Testes**: integração da fila, do refresh de feed, das migrations
      (drift schema tests). Fecha o widget test do equalizador (dívida v1).
- [ ] Ícone/splash finais, screenshots.

**Não quebra:** hardening + config de build; código de feature intacto.

---

## Dependências novas previstas

Checar conflito (`flutter pub get` + `dart analyze`) logo após adicionar cada uma.

| Fase | Dep | Uso |
| --- | --- | --- |
| 10 | `workmanager` | refresh periódico headless |
| 10 | `flutter_local_notifications` | notificação de episódio novo |
| 10 | `permission_handler` | `POST_NOTIFICATIONS` runtime |
| 13 | `connectivity_plus` | política "só no wifi" |
| 14 | `sensors_plus` | "agitar pra estender" no sleep timer |
| 14 | `xml` | parse namespace `podcast:chapters` no RSS (já entra na 14) |
| 16 | `share_plus` | compartilhar episódio |
| 16 | `quick_actions` | app shortcuts (ou `shortcuts.xml` nativo) |
| 17 | — | — |

---

## Ordem e dependências

```text
9 (feeds vivos)  ──►  10 (background + notificação)
     │                      │
     └──►  11 (Início)  ◄───┘
               │
               ▼
          12 (fila)  ──►  13 (gestão de episódios)   [13 também precisa da 9]
               │                    │
               ▼                    ▼
          15 (gestos)  ◄────────────┘
               │
     14 (player avançado)   — independente; pode entrar depois da 12
               │
          16 (Android Auto / deep links)   — precisa de 11 + 12 pra árvore do Auto
               │
          17 (biblioteca / descoberta)   — independente
               │
          18 (publicação)   — por último (ou antecipar só a assinatura de release)
```

**Sequência recomendada:** 9 → 11 → 12 → 10 → 13 → 15 → 14 → 16 → 17 → 18.
(11 antes de 10 dá payoff visível mais cedo; 10 traz o background logo depois.)

---

## Futuro / não planejado

- Sync entre aparelhos, conta, backend — contradiz local-only.
- iOS — Fase 7 da v1, pausada de propósito.
- Transcrições (`podcast:transcript`), `podcast:soundbite`, `podcast:person`,
  comunidade/chat.
- Monetização.

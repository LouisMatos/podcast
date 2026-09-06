# Roadmap — estado do projeto

> **Este arquivo é a fonte de verdade para retomar o trabalho.**
> Ao terminar uma fase: marque os checkboxes, atualize "Onde parei" e faça commit.
> Ao voltar depois de dias: leia "Onde parei", depois `docs/ARCHITECTURE.md`, depois a fase atual.

## Onde parei

**Fase 8 em andamento** — 7 features novas, faseadas (ver "Fase 8" abaixo).
v1 (Fases 0–6) segue completa e intacta. Fase 7 (iOS) continua pausada de
propósito — só Android por enquanto.

**Fase atual:** 8 — novas features (descoberta, progresso, player)
**Sub-fase concluída:** 8.3 — selecionar episódio abre a tela de descrição
(HTML) sem tocar; player minimizado no rodapé; "Abrir player" pra tela
cheia; auto-avanço no fim da fila mantido. 43 testes (era 39).
**Próximo passo concreto:** Fase 8.4 — controles de volume + equalizador
(Android) no player. Ver checklist da 8.4 abaixo.
**Plano completo da Fase 8:** `~/.claude/plans/deve-ler-o-readmap-md-giggly-floyd.md`.

## Regra de ouro

Toda fase termina com o app **rodando** via `./scripts/run_android.sh` e um commit.
Nunca deixe uma fase pela metade sem anotar acima o que falta.

---

## Fase 0 — Fundação e script de execução ✅

- [x] `git init` na raiz
- [x] `flutter create` em `frontend/` (org `com.luismatos`, projeto `podcast_app`)
- [x] `backend/README.md` como placeholder
- [x] `pubspec.yaml` com a stack completa
- [x] `analysis_options.yaml` com lints e exclusão dos arquivos gerados
- [x] `scripts/run_android.sh` e `scripts/gen.sh`
- [x] `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN_SYSTEM.md`
- [x] App padrão abre no emulador pelo script

## Fase 1 — Design system e casca de navegação ✅

- [x] `core/theme/app_colors.dart` — paleta pastel, claro e escuro
- [x] `core/theme/app_typography.dart` — Nunito via `google_fonts`
- [x] `core/theme/app_radii.dart` e `app_shadows.dart`
- [x] `core/theme/motion.dart` — durações e curvas
- [x] `core/theme/app_theme.dart` — monta o `ThemeData` a partir dos tokens
- [x] `core/widgets/`: `SoftCard`, `PillButton`, `PastelChip`, `ShimmerBox`, `SectionHeader`, `EmptyState`
- [x] `core/router/app_router.dart` + `app_shell.dart` — `go_router` com `StatefulShellRoute` de 3 abas e transição fade+slide
- [x] Telas Descobrir / Biblioteca / Ajustes com dados mockados
- [x] `app.dart` com `ProviderScope` + `MaterialApp.router`
- [x] **Pronto quando:** navegação funciona, tema claro/escuro alterna, animações no tempo definido

Nota: `themeModeProvider` usa `Notifier`/`NotifierProvider`, não `StateProvider` —
Riverpod 3 moveu `StateProvider` pra `package:flutter_riverpod/legacy.dart`.
Ficou mais alinhado ao resto do projeto (que já usa `@riverpod`/codegen).

## Fase 2 — Descoberta e detalhe do podcast ✅

- [x] `core/network/dio_client.dart`
- [x] `data/models/podcast.dart` e `episode.dart` (Freezed — sem JSON codegen; a tradução do JSON/XML bruto é manual dentro dos data sources, ver ARCHITECTURE.md)
- [x] `data/sources/itunes_search_api.dart`
- [x] `data/sources/rss_feed_parser.dart` (`rss_dart`, lendo `itunes:duration`, `itunes:image`, `enclosure`)
- [x] `data/repositories/podcast_repository.dart`
- [x] `DiscoverViewModel` com debounce de busca (400ms)
- [x] `PodcastDetailViewModel` (`AsyncNotifier.family` pelo próprio `Podcast`)
- [x] `PodcastDetailScreen` com `Hero` na capa vindo da lista
- [x] **Pronto quando:** busca real retorna podcasts e o detalhe lista episódios reais

Notas:

- Freezed 4 exige `abstract class Foo with _$Foo` (não mais `class Foo with _$Foo`)
  — sem o `abstract`, dá erro "Missing concrete implementations" no analyze.
- A iTunes Search API devolve `Content-Type: text/javascript`, não
  `application/json`. O parser automático do Dio (`Dio.get<Map<...>>`) não
  decodifica isso — vinha um `DioException`/`type 'String' is not a subtype
  of Map` silencioso. Corrigido pedindo `ResponseType.plain` e decodificando
  com `jsonDecode` na mão (ver `ItunesSearchApi.search`).
- Datas de `pubDate` do RSS são parseadas com `intl`'s `DateFormat('EEE, dd
  MMM yyyy HH:mm:ss Z', 'en_US')`; falha vira `null` (episódio sem data),
  não trava a tela.

## Fase 3 — Persistência local ✅

- [x] Schema drift: `Subscriptions`, `EpisodeCache`, `PlaybackProgress`, `Downloads`
      (`core/database/tables.dart` + `app_database.dart`)
- [x] `LibraryRepository` (só usa `SubscriptionRow`/`EpisodeCacheRow` — nunca
      vaza tipo do drift pra fora; devolve/recebe `Podcast`/`Episode`)
- [x] Assinar / desassinar, com cache dos episódios na assinatura
- [x] Biblioteca reativa (`LibraryViewModel`, `Stream` do drift → `StreamNotifier`)
- [x] Botão assinar/desassinar no detalhe do podcast (`isSubscribedProvider`,
      reativo entre telas — desassinar pela Biblioteca atualiza o detalhe sozinho)
- [x] **Pronto quando:** assinatura sobrevive ao fechar o app

Notas:

- `playback_progress` e `downloads` só têm o schema pronto — ninguém
  escreve neles ainda. Ficam pra Fase 4 (player) e Fase 5 (download).
  "Posição de escuta sobrevive ao restart" do critério original fica
  adiado pra Fase 4, quando existir um player que gere essa posição.
- Tabelas com FK em `Subscriptions.id` (`EpisodeCache`, `PlaybackProgress`,
  `Downloads`) usam `onDelete: KeyAction.cascade` — desassinar já limpa o
  cache de episódios sozinho, sem `DELETE` manual em cada tabela.
- Toda classe gerada pelo drift termina em `Row` (`SubscriptionRow`,
  `EpisodeCacheRow`) de propósito — sem isso, o nome gerado da tabela
  `EpisodeCache` colidiria com o modelo de domínio `Episode`.
- Coluna `id` de `Subscriptions` não é `autoIncrement()`, mas o
  `.insert()` gerado ainda trata como opcional (`Value.absent()` por
  padrão) — sempre passar `Value(podcast.id)` explícito.

## Fase 4 — Player ✅

- [x] `services/audio/podcast_audio_handler.dart` (`BaseAudioHandler` + `QueueHandler` + `SeekHandler`, `just_audio` por baixo)
- [x] Config Android: `MainActivity` estende `AudioServiceActivity`, `<service>` + `<receiver>` no manifesto, permissões (`INTERNET` movida pro manifest principal — antes só existia no de debug), `minSdk` 24 (default do Flutter já atende o ≥23 pedido), `launchMode="singleTop"` (já vinha do template)
- [x] Mini-player sobre o bottom nav (`AppShell`), só aparece depois do primeiro play
- [x] Full player em `/player` (rota de topo, fora das 3 abas) com `Hero` na capa vindo da lista/mini-player
- [x] Velocidade 0.5×–3.0×
- [x] Skip -15s / +30s
- [x] Sleep timer (5/15/30/60 min, cancelável)
- [x] Progresso salvo a cada ~5s enquanto toca + na hora que pausa (não só no ciclo periódico)
- [x] Retoma da posição salva ao tocar o episódio de novo (`LibraryRepository.playbackPositionFor`)
- [x] **Pronto quando:** toca com a tela apagada e os controles aparecem na notificação/lockscreen

Notas:

- `PlayerViewModel` é `keepAlive: true` — o áudio toca em background e o
  mini-player aparece em qualquer aba, então não pode ser descartado ao
  trocar de tela.
- Status de assinatura e player ficam deliberadamente em providers
  diferentes (`isSubscribedProvider` já existia da Fase 3): juntar
  play/pause no mesmo estado do fetch de episódios faria assinar/desassinar
  ou trocar de faixa refazer o fetch inteiro do RSS.
- `AsyncValue.valueOrNull` não existe no Riverpod 3.4.3 — `value` já é
  nullable (`ValueT? get value`). Usar `state.value`, não `.valueOrNull`.
- Riverpod codegen usa `Ref` genérico (não mais `XRef` por provider) —
  `import 'package:riverpod_annotation/riverpod_annotation.dart'` já expõe.
- Navegar pro player **antes** de esperar o `playEpisode` terminar (fire
  Future sem `await`, depois `context.push`) — esperar primeiro deixa o
  toque parecendo sem resposta enquanto o áudio buffereia. A tela do
  player já lida com `isBuffering`.
- iTunes API devolvia `Content-Type: text/javascript`; visto na Fase 2.
  Já corrigido lá — mencionado aqui porque foi o mesmo tipo de armadilha
  silenciosa (exceção engolida) que quase escondeu o bug de navegação
  desta fase.
- **Emulador mata o serviço de áudio por "app idle" depois de ~2m30s de
  tela apagada** (`ActivityManager: Stopping service due to app idle`),
  mesmo com foreground service + notificação ativos. Confirmado como
  comportamento de gerenciamento de energia do emulador/Android (Doze/App
  Standby), não bug do app — reproduzir num device real com "não otimizar
  bateria" ligado pro app antes de investigar mais.

## Fase 5 — Download offline ✅

- [x] `services/download/download_service.dart` com `flutter_downloader`
- [x] Fila e progresso persistidos em drift (`Downloads` ganhou `taskId` +
      `progress`, migração v1→v2)
- [x] Player prefere o arquivo local quando existe (`Uri.file(...)` no
      lugar da URL, resolvido por todo o `queue` de uma vez)
- [x] Tela de downloads (`/settings/downloads`) com uso de espaço (lido
      direto do arquivo, `File.lengthSync()`) e remoção
- [x] Permissão `POST_NOTIFICATIONS` (Android 13+) — já vem embutida no
      manifesto do próprio plugin `flutter_downloader`, nada a adicionar
- [x] **Pronto quando:** episódio baixado toca em modo avião

Notas:

- Botão de download só aparece com o podcast assinado — `Downloads` e
  `EpisodeCache` têm FK em `Subscriptions.id`, então baixar sem assinar
  não tem onde guardar o episódio.
- **Bug real achado testando modo avião de verdade** (não só o player —
  o fluxo inteiro): `PodcastDetailViewModel` sempre buscava o RSS ao
  vivo, então sem rede a tela de detalhe travava no erro antes mesmo de
  mostrar a lista — o episódio baixado ficava inacessível pela navegação
  normal do app. Corrigido com fallback: se o fetch falhar e já existir
  cache local (`LibraryRepository.cachedEpisodes`), usa o cache; só
  propaga o erro se não tiver nada salvo. Esse é o tipo de bug que só
  aparece testando o cenário real (avião + reiniciar o app), não com
  mocks ou com a rede sempre disponível.
- `flutter_downloader` roda num isolate de background separado; a
  comunicação com o isolate principal é via `IsolateNameServer`/
  `ReceivePort`, não Riverpod — só depois que o evento chega em
  `DownloadService._onIsolateMessage` é que vira uma escrita no drift
  (aí sim tudo reativo de novo).
- `DownloadRepository` nunca faz join contra `Subscriptions`/`EpisodeCache`
  fora de `watchAll()` — os outros métodos (`watchForEpisode`,
  `completedPathsForPodcast`) só leem `Downloads`, mais rápido e o
  chamador já tem os dados que precisa (o `Episode`/`Podcast` completo).

## Fase 6 — Polimento e testes ✅

- [x] Estados vazios e de erro ilustrados, com retry (`EmptyState` ganhou
      `onRetry`/`retryLabel`; usado em Descobrir, Biblioteca, detalhe do
      podcast e Downloads)
- [x] Shimmer em todo carregamento (Downloads usava `CircularProgressIndicator`
      — trocado por skeleton, igual às outras listas)
- [x] Testes unitários dos ViewModels e do parser de RSS (`mocktail`):
      `RssFeedParser`, `ItunesSearchApi`, `DiscoverViewModel`
- [x] Widget test do player (`PlayerScreen`/`MiniPlayer` no estado ocioso)
- [x] Acessibilidade: contraste ≥ 4.5:1 no texto (`AppColors.onAccent` +
      `textMuted` mais escuro no tema claro), tooltips nos controles do
      player que não tinham (replay/play-pause/forward, velocidade, sleep
      timer, mini-player)

Notas:

- **`AppColors` ganhou `onAccent`**: texto/ícone sobre um preenchimento
  sólido de `primary`/`secondary` (ex: `PillButton` primário, "Assinar").
  Medindo contraste real (fórmula WCAG) achei dois problemas de verdade,
  não hipotéticos: `textMuted` claro (`#8B8493`) tinha só 3.4:1 sobre o
  fundo (abaixo do mínimo de 4.5:1 pra texto normal), e o botão "Assinar"
  no tema escuro tinha 2.5:1 (texto `textPrimary` claro sobre um `primary`
  também claro — a mesma cor de texto que funciona bem no tema claro fica
  ilegível no escuro quando o fundo é um pastel que não escurece junto).
  `onAccent` é fixo nos dois temas porque `primary`/`secondary` têm
  luminância parecida em claro e escuro. Ver `PillButton` e
  `AppTheme.elevatedButtonTheme`.
- **`ProviderContainer` em teste + provider `autoDispose` precisa de um
  listener permanente** — sem isso o container derruba o notifier (e
  cancela qualquer `Timer` interno, ex: o debounce do `DiscoverViewModel`)
  assim que o `read()` retorna, antes de qualquer `await` no teste ter
  chance de ver o efeito. Fix: `container.listen(provider, (_, _) {})` no
  `setUp`. Ver `discover_view_model_test.dart`.
- Widget test que monta telas reais (`PlayerScreen`, `MiniPlayer`) precisa
  de `MaterialApp(theme: AppTheme.light(), ...)` — sem isso,
  `Theme.of(context).extension<AppColors>()!` estoura `null check operator`
  (o `ThemeData()` default do Flutter não tem nossa extensão).

## Fase 7 — iOS e evolução

- [ ] Instalar Xcode + CocoaPods
- [ ] `UIBackgroundModes: audio` no `Info.plist`
- [ ] Testar no simulador iOS
- [ ] `scripts/run_ios.sh`
- [ ] Backlog: OPML import/export, fila de reprodução, sync entre aparelhos

---

## Fase 8 — Novas features (descoberta, progresso, player)

7 features do usuário, quebradas em 4 sub-fases pausáveis. Cada sub-fase
termina com `flutter analyze` limpo + `flutter test` verde +
`./scripts/run_android.sh` + commit `feat: fase 8.x — ...` + esta seção e o
`CLAUDE.md` atualizados.

Decisões (brainstorm): charts via Apple Marketing Tools RSS + iTunes lookup
(sem backend); descrição de episódio em HTML rico (pacote novo); selecionar
episódio não dá autoplay, mas auto-avanço ao fim de um episódio na fila
continua; equalizador só Android + slider de volume nos dois.

### Fase 8.1 — Descobrir: carrossel Top 20 BR + categorias ✅

- [x] `data/sources/apple_charts_api.dart` — `topPodcastIds({limit, genreId})`,
      Marketing Tools RSS (geral) / RSS legado por gênero. Decode manual.
- [x] `ItunesSearchApi.lookup(ids)` — resolve ids em `Podcast` completos numa
      chamada; **não preserva ordem**, quem chama reordena.
- [x] `PodcastRepository.topPodcasts()` / `.podcastsByGenre(genreId)` +
      `RankedPodcast = ({int rank, Podcast podcast})`.
- [x] `features/discover/podcast_genres.dart` — 14 categorias pt-BR → genreId Apple.
- [x] `FeaturedViewModel` (keepAlive) e `CategoryViewModel` (family em genreId).
- [x] Widgets compartilhados extraídos: `core/widgets/search_field.dart`,
      `core/widgets/podcast_list_tile.dart` (+ skeleton).
- [x] `DiscoverScreen`: carrossel horizontal com badge de rank + grade de
      categorias quando a busca está vazia; resultados de busca inalterados.
- [x] `features/category/` — `CategoryScreen` + rota `/discover/category`
      (`extra` = `({int id, String label})`).
- [x] Testes: `apple_charts_api_test`, `podcast_repository_test` (7 novos).

Armadilhas:

- **iTunes `/lookup` não devolve na ordem dos ids** — `PodcastRepository.
  _resolveRanked` reordena pelo índice pedido e descarta id sem `feedUrl`.
- Endpoints de charts (Marketing Tools e RSS legado) não mandam
  `application/json` confiável — mesmo tratamento da Search API
  (`ResponseType.plain` + `jsonDecode` manual).
- Dois formatos de JSON de charts: novo (`feed.results[].id` string) e legado
  (`feed.entry[].id.attributes["im:id"]`) — `AppleChartsApi._idOf` cobre os dois.
- genreIds das categorias são hardcoded em `podcast_genres.dart` (1489
  Notícias, 1303 Comédia, ...). Lista curada, não vem de API.
- Estado de erro do carrossel é um card compacto (`_CarouselError`), **não**
  `EmptyState` — `EmptyState` estoura o `SizedBox` de 232px de altura.

### Fase 8.2 — Detalhe: progresso + busca/filtro/ordenação + aba Baixados ✅

Features 3 e 4.

- [x] `LibraryRepository.watchProgressForPodcast(id)` →
      `Stream<Map<String, EpisodeProgress>>` (`EpisodeProgress = ({int
      positionSeconds, bool completed})`). Provider `episodeProgress(id)`.
- [x] `LibraryRepository.watchDownloadedEpisodes(id)` → `Stream<List<Episode>>`
      (join `episodeCache` × `downloads` status complete). Provider
      `downloadedEpisodes(id)`.
- [x] `_EpisodeTile` ganha `progress` opcional → `_EpisodeProgressLine`
      (selo "Ouvido" se completo; barra fina + "Faltam Xmin" se começado).
- [x] `episode_list_controls.dart` — enums `EpisodeFilter`/`EpisodeSort`,
      state Freezed, `@riverpod` family `episodeListControls(podcastId)`,
      função pura `applyEpisodeControls(episodes, controls, progress)`.
- [x] `PodcastDetailScreen`: header + `PillButton` acima, `DefaultTabController`
      de 2 abas ["Episódios", "Baixados"], `TabBar(dividerColor: transparent)`.
- [x] Aba Episódios: `SearchField` + `_SelectableChip`s de filtro +
      `_SortButton` (`PopupMenuButton`), lista via `applyEpisodeControls`.
- [x] Aba Baixados: reusa `_EpisodeTile` (com o botão já no estado "remover").
- [x] Testes: `library_repository_test` (drift `NativeDatabase.memory()`),
      `episode_list_controls_test` (7 novos, 39 no total).

Armadilhas:

- **`_EpisodeTile` foi movido pra `_EpisodesTab`/`_DownloadsTab`** dentro de
  `podcast_detail_screen.dart`. O corpo do detalhe agora é
  `DefaultTabController` > `Column` [header, `TabBar`, `Expanded(TabBarView)`]
  — não mais um `ListView` único. Cada aba tem seu próprio `ListView`.
- `TabBar` traz divisória e indicador padrão — sempre setar
  `dividerColor: Colors.transparent` + `indicatorSize: TabBarIndicatorSize.label`
  pra respeitar o design (sem borda dura).
- Progresso (`playbackProgress`) só existe pra podcast **assinado** (FK em
  `Subscriptions`) — a aba de episódios de um podcast não assinado mostra
  os tiles sem `_EpisodeProgressLine`, e é o esperado.
- Teste de repositório com drift: `AppDatabase(NativeDatabase.memory())`
  (`package:drift/native.dart`), `tearDown(() => db.close())`. Inserir a
  `Subscriptions` antes de qualquer coisa com FK.

### Fase 8.3 — Sem autoplay ao selecionar + tela de episódio ✅

Features 5 e 7.

- [x] `PodcastAudioHandler.playQueue`/`skipToQueueItem` ganham `autoPlay`
      (default `true`); só chamam `_player.play()` se `true`.
      `_onEpisodeCompleted` mantém `true` (auto-avanço no fim da fila).
- [x] `PlayerViewModel.playEpisode(..., {bool autoPlay = false})` — default
      `false`. `playNextInQueue` passa `true` (ação explícita).
- [x] pubspec: `flutter_widget_from_html_core: ^0.17.0` (Dart puro, sem
      conflito de analyzer/intl).
- [x] `features/episode_detail/` — `EpisodeDetailScreen`: `MiniPlayer` no
      `bottomNavigationBar`, capa (Hero tag `episode-artwork-<guid>`),
      `HtmlWidget` da descrição, `PillButton` "Tocar"/"Retomar"/"Pausar" +
      `DownloadButton`, `PillButton` ghost "Abrir player" → `/player`.
- [x] Rota `/episode` (root nav), `extra` = record
      `({Podcast podcast, Episode episode, List<Episode> queue})`.
- [x] `DownloadButton` extraído pra `features/downloads/widgets/` (usado em 3
      telas). `_EpisodeTile`: card abre `/episode`; ícone de play à esquerda
      virou `IconButton` que toca de fato (`autoPlay: true`).
- [x] Testes: `player_view_model_test` (fake handler, autoPlay),
      `episode_detail_screen_test`. 4 novos, 43 no total.

Armadilhas:

- **Selecionar episódio (tocar no card do `_EpisodeTile`) abre `/episode`,
  não toca.** O play rápido está no `IconButton` de play à esquerda do tile
  e no botão "Tocar" da tela de episódio — ambos com `autoPlay: true`.
- `EpisodeDetailScreen` monta o próprio `const MiniPlayer()` no
  `bottomNavigationBar` porque `/episode` é rota de root (cobre o `AppShell`
  e o mini-player dele).
- Hero da capa na tela de episódio usa tag `episode-artwork-<guid>` — as
  telas de podcast/player usam `podcast-artwork-<id>`, então não colidem
  quando o mini-player (que tem a tag do podcast) está visível.
- Teste de `PlayerViewModel` com `test()` puro: `TestWidgetsFlutterBinding.
  ensureInitialized()` no início do `main` — o construtor do
  `PodcastAudioHandler` cria um `just_audio.AudioPlayer` que registra method
  channel handler e precisa do binding. Fake handler sobrescreve `playQueue`
  pra não bater em channel.
- `HtmlWidget` renderiza `RichText` — em teste, `find.textContaining` não
  acha o texto; usar `find.byType(HtmlWidget)`. Links da descrição ainda não
  abrem (sem `url_launcher` — backlog).

### Fase 8.4 — Player: volume + equalizador ⬜

Feature 6.

- [ ] `PodcastAudioHandler`: `AndroidEqualizer` via `AudioPipeline` na
      construção do `AudioPlayer`; `setVolume`, `setEqualizerEnabled`,
      `equalizerBands()`, `setEqualizerBandGain`.
- [ ] `PlayerState`: `volume`, `equalizerEnabled`, `equalizerBands`.
- [ ] `PlayerViewModel`: `setVolume`, `toggleEqualizer`, `setEqualizerBand`,
      `applyEqualizerPreset` (Flat/Voz/Grave/Agudo, com clamp).
- [ ] `PlayerScreen`: slider de volume; `IconButton` de equalizador (só
      Android) abrindo `_EqualizerSheet`.
- [ ] Testes: `player_state_test` estendido.
- [ ] Marcar Fase 8 concluída aqui e no `CLAUDE.md`.

---

## Dívidas técnicas conhecidas

| Item | Detalhe |
|---|---|
| `custom_lint` / `riverpod_lint` | Fora do `pubspec.yaml`: `custom_lint` 0.8.x fixa `analyzer ^8.0.0`, `drift_dev` 2.34.x exige `analyzer >=13.0.0`. Reincluir quando `custom_lint` subir o analyzer. |
| `webfeed_plus` | Descartado por fixar `intl ^0.19.0`, incompatível com `go_router` 18. Usamos `rss_dart`. |
| `sqlite3_flutter_libs` | Publicado como `0.6.0+eol`. Não declarar direto — `drift_flutter` resolve o sqlite nativo. |
| Android `cmdline-tools` | Ausente no SDK; `flutter doctor` reclama e as licenças ficam "unknown". Não bloqueou o build até agora. Se travar: instalar via Android Studio e rodar `flutter doctor --android-licenses`. |
| Xcode / CocoaPods | Ausentes. Build iOS só na Fase 7. |

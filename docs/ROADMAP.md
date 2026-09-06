# Roadmap — estado do projeto

> **Este arquivo é a fonte de verdade para retomar o trabalho.**
> Ao terminar uma fase: marque os checkboxes, atualize "Onde parei" e faça commit.
> Ao voltar depois de dias: leia "Onde parei", depois `docs/ARCHITECTURE.md`, depois a fase atual.

## Onde parei

**Fase atual:** 7 — iOS e evolução
**Última coisa concluída:** Fase 6 (polimento e testes) — retry nos estados de erro, shimmer consistente, contraste de texto corrigido, 25 testes automatizados
**Próximo passo concreto:** instalar Xcode + CocoaPods nesta máquina, depois `UIBackgroundModes: audio` no Info.plist e `scripts/run_ios.sh`

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
- [ ] Backlog: OPML import/export, fila de reprodução, busca por categoria, sync entre aparelhos

---

## Dívidas técnicas conhecidas

| Item | Detalhe |
|---|---|
| `custom_lint` / `riverpod_lint` | Fora do `pubspec.yaml`: `custom_lint` 0.8.x fixa `analyzer ^8.0.0`, `drift_dev` 2.34.x exige `analyzer >=13.0.0`. Reincluir quando `custom_lint` subir o analyzer. |
| `webfeed_plus` | Descartado por fixar `intl ^0.19.0`, incompatível com `go_router` 18. Usamos `rss_dart`. |
| `sqlite3_flutter_libs` | Publicado como `0.6.0+eol`. Não declarar direto — `drift_flutter` resolve o sqlite nativo. |
| Android `cmdline-tools` | Ausente no SDK; `flutter doctor` reclama e as licenças ficam "unknown". Não bloqueou o build até agora. Se travar: instalar via Android Studio e rodar `flutter doctor --android-licenses`. |
| Xcode / CocoaPods | Ausentes. Build iOS só na Fase 7. |

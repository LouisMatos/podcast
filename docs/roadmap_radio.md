# Roadmap Rádio — 5ª aba, streaming ao vivo

> Feature nova, branch `feat/radio` (a partir de `feat/fase-9`). Legado de
> podcast não muda de comportamento — única edição em código compartilhado é
> um guard de 2 linhas em `PlayerViewModel` (ver Fase R3). Plano completo em
> `~/.claude/plans/quer-implementar-uma-nova-parsed-kitten.md`.

## Decisões

- Fonte: Radio Browser API (`de1.api.radio-browser.info`), pública, sem
  chave, JSON real. Sem programação do dia — campo nullable, não populado.
- Player: reusa `PodcastAudioHandler` existente, `setQueue([mediaItem])`
  direto, fora do fluxo `playEpisode`/fila/download/capítulos/progresso.
  `MediaItem` da rádio leva `extras: {'isRadio': true}` — guard evita que
  `PlayerViewModel` grave posição da rádio sob guid de episódio real.
- Sem mini-bar cross-tab na v1 (YAGNI).
- v2 (R5-R7, 2026-09-11): busca client-side, tela de detalhe, favoritos via
  `PreferencesStore`. Sem grade de programação/now-playing — sem API
  gratuita real pra isso (só ICY metadata via stream, "tocando agora", nem
  toda estação preenche; decisão do usuário, plano em
  `~/.claude/plans/ficar-scrollando-ate-achar-melodic-spark.md`).

## Fases

- [x] **R0 — branch + dados**: `RadioStation` model, `RadioBrowserApi`,
  `RadioRepository`+provider. Teste: unit do source com Dio mockado.
- [x] **R1 — ViewModel + tela sem áudio**: `RadioState`/`RadioViewModel`,
  `RadioScreen`/`RadioStationTile`, sem play funcional. Teste: unit com
  repo fake.
- [x] **R2 — wiring rota/aba**: `app_router.dart` + `app_bottom_bar.dart`,
  5ª aba navegável. Teste: `flutter test` completo.
- [x] **R3 — playback ao vivo**: `extras: {'isRadio': true, 'stationId':
  ...}`, `RadioViewModel.play()`→`setQueue`, guard em
  `player_view_model.dart` (`_onMediaItemChanged`, `_onPlaybackStateChanged`,
  `_onTick` — este último não estava no plano original mas também lia
  `_handler.playbackState` direto e chamava `_saveProgress`, mesmo risco).
  Testes: guard não mexe em `state.podcast/episode/position`/
  `_saveProgress`; `setQueue`/toggle play-pause/isPlaying-isBuffering
  corretos.
- [x] **R4 — polish + validação real**: rodado no emulador (Pixel_6) com
  Radio Browser API de verdade. Achado e corrigido bug real: trocar pra um
  episódio de podcast depois de tocar rádio deixava o tile da estação
  travado em "tocando" (`RadioViewModel` não reagia a `mediaItem` deixar
  de ser rádio). Fix: `_onMediaItemChanged` zera `nowPlayingId`/
  `isPlaying`/`isBuffering` quando o handler compartilhado passa a tocar
  outra coisa. Coberto por teste unit + confirmado visualmente
  (screenshot antes/depois do fix).

- [x] **R5 — busca**: `RadioState.query`, `RadioViewModel.setQuery`, função
  pura `filterStations` (nome/gênero/estado, case-insensitive), `SearchField`
  na `RadioScreen`. Teste: `setQuery` + `filterStations`.
- [x] **R6 — tela de detalhe**: rota `/radio-detail` (padrão `/podcast`),
  `RadioDetailScreen` (logo/nome/gênero/estado/play, sem grade — dado não
  existe). Tap no tile abre detalhe; play/favoritar viraram botões próprios
  (`onPlayTap`/`onFavoriteTap`) separados do tap do card.
- [x] **R7 — favoritos**: `PreferencesStore.favoriteRadioIds` (
  `getStringList`/`setStringList` nativo, sem jsonEncode), `RadioState.
  favoriteIds`, `RadioViewModel.toggleFavorite`, ícone estrela no tile,
  abas "Todas"/"Favoritas" (`TabBar`/`DefaultTabController`, mesmo padrão
  de `podcast_detail_screen.dart`) com busca compartilhada entre as duas.
- [x] **R8 — redesign da tela de detalhe + volume**: `RadioDetailScreen`
  centralizada (`Center`+`SingleChildScrollView`, sem espaço vazio
  residual), arte 160→220px (`AppRadii.surfaceAll`), botão play envolto
  em círculo `colors.primary` translúcido, controle de volume (`Slider`
  reusando `playerViewModelProvider.state.volume`/`setVolume` — mesmo
  `PodcastAudioHandler` do player de episódio, sem campo novo em
  `RadioState`). Sem widget test novo (não havia nenhum antes; lógica de
  volume já coberta em `player_view_model_test.dart`).

## Onde parei

**Feature completa (R0–R8), 2026-09-12.** Rádio toca ao vivo (Radio
Browser API, BR), 5ª aba, guard `isRadio` protege o player de podcast em
3 pontos (`_onMediaItemChanged`, `_onPlaybackStateChanged`, `_onTick`),
`RadioViewModel` reseta estado quando o handler compartilhado sai do
modo rádio (bug achado e corrigido em teste manual no emulador). v2
(R5-R7) adicionou busca, tela de detalhe e favoritos persistidos; R8
reformulou o layout da tela de detalhe (estava pequena/vazia) e trouxe
volume pra tela de rádio. `dart analyze` limpo, 236/236 testes verdes (1
flaky pré-existente de debounce em `discover_view_model_test.dart`,
passa isolado e na 2ª rodada — não relacionado a esta feature).

**R5-R8 validados em device físico (SM-G570M, 2026-09-13)**: buscar
estação ("jovem" → resultado correto), abrir detalhe redesenhado (artwork,
gêneros, localização), ajustar volume, favoritar/desfavoritar, aba
Favoritas (mostra a favoritada, ícone de pausa refletindo estado real),
tocar favorita direto da lista — tudo sem travar, mini-player sincronizado
em cada ação. Nenhum bug encontrado. Sem grade de programação/now-playing
(YAGNI, sem API gratuita real — ver Decisões). **Pronto pra review/merge em
`feat/fase-9`, validação manual completa.**

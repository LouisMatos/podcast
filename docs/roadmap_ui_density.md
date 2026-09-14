# Densidade visual — reduzir scroll nas listas

App funcional, sem bug conhecido, branch `release/1.0.0` já criada como snapshot.
Objetivo aqui: itens de lista (cards de episódio/podcast) estão grandes demais,
usuário scrolla muito pra achar coisa. Plano faseado, só visual (espaçamento,
tamanho, opcionalmente animação leve) — nunca lógica/estado/provider/callback.
Cada fase = commit próprio, testado isolado no device físico (SM-G570M) antes de
avançar. Se bug aparecer depois em uso real, dá pra reverter só a fase culpada.

Diagnóstico: não existe token de espaçamento (`AppSpacing`) — tudo hardcoded
inline. Ponto de alavancagem central é `SoftCard`
(`frontend/lib/core/widgets/soft_card.dart:12`, padding default
`EdgeInsets.all(16)`), consumido sem override por quase toda linha de lista do
app (Home, Discover, Library, Podcast Detail, Episode Detail, Downloads). Existe
duplicação de "linha de episódio" em 3 lugares (`EpisodeRow`,
`_RecentEpisodeRow` em home_screen.dart, `_EpisodeTile` em
podcast_detail_screen.dart) — unificar é opcional, fase separada, mais arriscada.

## Baseline (2026-09-14)
- `dart analyze`: limpo
- `flutter test`: 246/246
- Branch: `release/1.0.0` (snapshot pré-otimização, pushada)

## Fase 0 — Token `AppSpacing` (infra, zero mudança visual) — concluída
- [x] Criar `frontend/lib/core/theme/app_spacing.dart` (padrão de
      `AppRadii`/`AppShadows`): `xs=4, sm=8, md=12, lg=16, xl=20, xxl=24`
- [x] Não consumido em nenhum widget ainda
- [x] `dart analyze` + `flutter test` limpos (246/246)
- [x] Teste manual device: N/A (nada mudou na tela)

## Fase 1 — Reduzir padding do `SoftCard` — concluída
- [x] `soft_card.dart:12`: `EdgeInsets.all(16)` → `EdgeInsets.all(AppSpacing.md)` (12)
- [x] Sombra hardcoded (`soft_card.dart:31-33`) → `AppShadows.soft(context)`
      (mesmo valor, remove duplicação)
- [x] Cards de carrossel (`_ContinueCard`, `_RankedPodcastCard`,
      `_SubscriptionGridCard`, já padding:10 explícito) intactos
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): Home, Discover, Library e Podcast Detail
      (`_EpisodeTile` — item mais denso, play overlay + progresso + trailing
      ⋮/download) conferidos via screenshot real — sem overflow, sem ícone
      espremido, sem texto cortado

## Fase 2 — Espaçamento entre itens de lista — concluída
- [x] `SizedBox(height:12)`/`Padding(bottom:12)` entre itens (não o gap interno
      artwork↔texto) → `AppSpacing.sm` (8) em: home_screen.dart,
      discover_screen.dart, library_screen.dart, podcast_detail_screen.dart,
      downloads_screen.dart
- [x] Não mexido em `SectionHeader` nesta fase
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): Home (scroll com mais itens visíveis) e
      Podcast Detail (`_EpisodeTile`, item mais denso) via screenshot real —
      sem overflow, ícones trailing intactos, mais item cabe na tela

## Fase 3 — Artwork 56→48 em linhas de lista — concluída
- [x] `EpisodeRow` (`episode_row.dart`), `_RecentEpisodeRow` (home_screen.dart),
      `_EpisodeTile`/`_EpisodeArtworkPlayButton` (podcast_detail_screen.dart),
      `PodcastListTile`: 56→48, `memCacheWidth/Height` ajustado junto
- [x] Não tocado 96x96 (header Podcast Detail) nem 200x200 (Episode Detail) —
      não são linha de lista
- [x] Fallback/skeleton ajustado pro mesmo tamanho (mesmo `sed` cobriu os dois)
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): botão play sobreposto no artwork do
      Podcast Detail — proporcional, sem overflow, trailing icons intactos

## Fase 4 — Unificar EpisodeRow/_RecentEpisodeRow/_EpisodeTile — concluída
Feita em branch própria (`feature/ui-density-fase4-unify-episode-row`), depois
da Fase 6, por ser a de maior risco (mexe em estrutura de widget).
- [x] 4.1: `EpisodeRow` estendido com `leading`/`progress`/`crossAxisAlignment`
      opcionais, sem trocar consumidor ainda — histórico/busca biblioteca
      continuam idênticos nos testes
- [x] 4.2: `_RecentEpisodeRow` (Home) migrado e removido (junto com
      `_EpisodeRowSkeleton` local, agora reusa `EpisodeRowSkeleton`) — testado
      isolado no device: visual idêntico, QueueMenuButton, toque abre /episode
- [x] 4.3: `_EpisodeTile` (Podcast Detail) migrado — `leading` customizado
      (`_EpisodeArtworkPlayButton`), `progress` (`_EpisodeProgressLine`),
      `trailing` com `Row([QueueMenuButton, DownloadButton?])`,
      `crossAxisAlignment: start` preservado; `EpisodeSwipeActions` continua
      envolvendo por fora, inalterado
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): play/pause pelo artwork (mini-player
      atualiza), menu de fila (marcar ouvido/arquivar), download
      (baixar→ícone vira cancelar), swipe pra marcar ouvido com "Desfazer",
      toque no corpo abre `/episode` sem tocar áudio — tudo funcional e
      visualmente equivalente ao anterior

## Fase 5 — Alturas fixas de carrossel — concluída
Risco documentado no CLAUDE.md: overflow `RenderFlex` em carrossel de altura
fixa já aconteceu antes nesse componente.
- [x] Discover `_FeaturedCarousel`: 232→208 (conteúdo calculado ~196, folga
      preservada) — testado isolado primeiro, sem overflow
- [x] Home `_ContinueCard`: mais justo (conteúdo ~207 de 210 disponíveis) —
      reduzido width 150→140 (imagem 130→120 via fórmula `_width-20`) junto
      com altura do container 210→198, mantendo a mesma folga proporcional
- [x] Discover e Home testados em etapas separadas, cada um rebuild+screenshot
      próprio no device antes de avançar
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): ambos carrosséis sem overflow, título
      ainda 2 linhas com ellipsis, progress bar do `_ContinueCard` intacta

## Fase 6 (opcional) — Animação leve de entrada de lista — concluída (Home)
- [x] `AnimatedSwitcher` (padrão já usado em Discover/Library) envolvendo a
      seção "Novos episódios" da Home, keyed por estado
      (`skeleton`/`empty`/`list-N`) — fade dispara só na transição
      skeleton→dados, não a cada rebuild/scroll
- [x] `AppMotion.effective(context, AppMotion.fast)` + `AppMotion.enter`/
      `AppMotion.standard`; sem stagger por item (reuso do padrão existente,
      não `AnimationController` manual)
- [x] Aplicado só na Home; propagar pras demais telas fica pendente/opcional
- [x] `dart analyze` + `flutter test` (246/246) limpos
- [x] Teste manual device (SM-G570M): layout intacto pós build, sem overflow;
      comportamento de fade é o mesmo padrão já validado em Discover/Library

## Pendente / decisões em aberto
Nenhuma — Fases 0-6 concluídas e validadas no device físico.

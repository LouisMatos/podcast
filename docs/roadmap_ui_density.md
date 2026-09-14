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

## Fase 2 — Espaçamento entre itens de lista
- [ ] `SizedBox(height:12)`/`Padding(bottom:12)` entre itens (não o gap interno
      artwork↔texto) → `AppSpacing.sm` (8) em: home_screen.dart,
      discover_screen.dart, library_screen.dart, podcast_detail_screen.dart,
      downloads_screen.dart
- [ ] Não mexer em `SectionHeader` nesta fase
- [ ] `flutter test` passa
- [ ] Teste manual device: comparar itens visíveis por tela antes/depois, scroll
      não "grudado", área de toque ainda confortável

## Fase 3 — Artwork 56→48 em linhas de lista
- [ ] `EpisodeRow` (`episode_row.dart:47-53` + skeleton `:104`),
      `_RecentEpisodeRow` (home_screen.dart:218-224),
      `_EpisodeTile`/`_EpisodeArtworkPlayButton` (podcast_detail_screen.dart),
      `PodcastListTile`: 56→48, ajustar `memCacheWidth/Height` junto
- [ ] Não tocar 96x96 (header Podcast Detail) nem 200x200 (Episode Detail) —
      não são linha de lista
- [ ] Fallback/skeleton ajustado pro mesmo tamanho (evita "pulo" de layout)
- [ ] `flutter test` passa
- [ ] Teste manual device: botão play sobreposto no artwork do Podcast Detail
      (área de toque, proporção), skeleton sem "piscar" tamanho errado

## Fase 4 (opcional, maior risco) — Unificar EpisodeRow/_RecentEpisodeRow/_EpisodeTile
- [ ] 4.1: estender `EpisodeRow` (slot leading customizável, barra de progresso
      opcional, múltiplos trailings) sem trocar consumidor ainda — `EpisodeRow`
      atual continua idêntico nos testes
- [ ] 4.2: migrar `_RecentEpisodeRow` (Home, caso simples) primeiro, testar
      isolado no device
- [ ] 4.3: migrar `_EpisodeTile` (Podcast Detail — play overlay, progresso
      condicional, 2 trailings, `EpisodeSwipeActions` envolvendo o card por
      fora) só depois de 4.2 validado
- [ ] Teste manual device: episódio com/sem progresso salvo, play/pause pelo
      artwork trocando "current", swipe ouvido/arquivar, download
      baixar/cancelar, toque no corpo abre `/episode` sem tocar áudio
- Decisão: se reduzir risco for prioridade, pular esta fase — dívida técnica,
  não afeta densidade (já usa padding da Fase 1)

## Fase 5 — Alturas fixas de carrossel
Risco documentado no CLAUDE.md: overflow `RenderFlex` em carrossel de altura
fixa já aconteceu antes nesse componente.
- [ ] Home `_ContinueCard` (h:210) e Discover `_FeaturedCarousel` (h:232) —
      medir conteúdo interno antes de cortar altura, não chutar número
- [ ] Reduzir em incrementos pequenos, testar overflow a cada incremento, Home
      e Discover em etapas separadas (estruturas diferentes)
- [ ] Se overflow persistir, não forçar — parar e reportar antes de mudar
      `maxLines`/truncamento (sai do escopo "só visual")
- [ ] `flutter analyze`/`flutter test` limpos
- [ ] Teste manual device: modo debug com overflow indicator visível, título
      mais longo disponível nos dados reais; repetir em profile/release

## Fase 6 (opcional) — Animação leve de entrada de lista
- [ ] Fade-in único via `AppMotion.enter` + `AppMotion.fast` (250ms), sempre
      `AppMotion.effective(context,...)`; sem stagger por item (caro no
      SM-G570M)
- [ ] Aplicar primeiro só na Home, validar, depois decidir se propaga
- [ ] Disparar só no carregamento inicial da lista, não a cada rebuild/scroll
- [ ] Preferir `AnimatedOpacity`/`TweenAnimationBuilder` com key estável a
      `AnimationController` manual por item
- [ ] Teste manual device: fade perceptível mas não "lento", sem jank/soluço,
      respeita preferência de baixo movimento do sistema, scroll rápido não
      afetado

## Pendente / decisões em aberto
- Fase 4 e Fase 6 são opcionais — confirmar com usuário depois da Fase 3 se
  valem a pena ou se o ganho de 0-3+5 já resolve o scroll excessivo.

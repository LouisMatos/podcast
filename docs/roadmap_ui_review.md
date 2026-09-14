# Revisão UI/UX pontual (skill ui-ux-pro-max)

Sessão de 2026-09-14, branch `feature/cache-offline-fase27-pr-ready`. Device:
Samsung Galaxy J5 Prime (SM-G570M, Android 8.0/API 26, serial
`42002b900177452d`) via USB, mesmo device de `roadmap_perf_device.md`.

Objetivo: revisar UI/UX do app usando a skill `ui-ux-pro-max`, navegando o app
real no device físico (Início → Descobrir → Biblioteca → Rádio → Ajustes →
Detalhe do podcast → Detalhe do episódio → Player) e cruzando o que aparece na
tela com o código-fonte. Não é redesenho — é polimento sobre o design system
já existente (`docs/DESIGN_SYSTEM.md`, `lib/core/theme/`). Todos os itens
abaixo são inconsistências/bugs confirmados visualmente no device, com causa
já localizada no código.

## Resolvidos — Fase 28 (`docs/roadmap_v3.md`)

Todos os 8 itens abaixo viraram sub-fases 28.1–28.8, branch
`feature/ui-review-fase28`, validados em device físico (SM-G570M). Item 5
não precisou de mudança de código (scroll horizontal já existia); item 4
revelou um bug extra só visível no device (overflow de 8px no bottom sheet
do temporizador), corrigido junto.

### 1. Rádio: linha da lista corta título e gêneros ✅ (28.3)
Nomes aparecem como "Rádio Cidade..." e gêneros "chamame,ecleti...". A row já
usa `Expanded` + `maxLines: 1` corretamente
(`lib/features/radio/view/radio_station_tile.dart:65-84`), mas logo 56px +
botão favoritar + botão play (~32px de ícone) deixam pouca largura sobrando
numa tela de 360dp.
- Ação: `maxLines: 2` no título e/ou reduzir a área do botão de play pro
  mesmo padrão 40px do `IconToggleButton` de favoritar.
- Arquivo: `lib/features/radio/view/radio_station_tile.dart`.

### 2. Player: título do podcast cortado na barra superior ✅ (28.4)
Barra superior empilha 5 ícones (colapsar, fila, share, equalizer, sleep
timer) + título em `Expanded maxLines: 1`
(`lib/features/player/view/player_screen.dart:296-345`) — sobra pouco espaço,
vira "Não Inviab...".
- Ação: mover ações menos usadas (share, sleep timer) pra um menu overflow ou
  pro bottom sheet de configurações já existente, liberando espaço pro
  título.
- Arquivo: `lib/features/player/view/player_screen.dart`.

### 3. Ajustes: seletor de tema usa borda dura ✅ (28.1)
`SegmentedButton<AppThemeMode>` padrão do Material desenha `OutlinedBorder`
visível entre "Claro/Escuro/Sistema" — viola a regra do projeto "sem
`Divider`/borda dura" (`CLAUDE.md` → Design system).
- Ação: `SegmentedButton.styleFrom(side: BorderSide.none)` + `shape:
  AppRadii.pillAll`, ou trocar por toggle custom baseado em `PillButton`.
- Arquivo: `lib/features/settings/view/settings_screen.dart:42`.

### 4. Biblioteca: dois campos de busca redundantes, placeholder cortado ✅ parcial (28.7)
"Filtrar por no..." (placeholder truncado) empilhado com "Buscar episódios na
biblioteca" — dois inputs muito parecidos, sem diferenciação clara de escopo
(um filtra assinaturas, outro busca episódios).
- Ação: encurtar o placeholder (ex. "Filtrar assinaturas") pra não cortar; e/
  ou dar hierarquia visual clara entre os dois campos (segundo campo só
  aparece ao expandir "Buscar episódios", por exemplo). **Requer decisão de
  produto antes de mexer** — não é só texto.
- Arquivo: `lib/features/library/view/library_screen.dart`.

### 5. Detalhe do podcast: chip "Ouvidos" cortado pelo ícone de ordenação ✅ (28.5, já corrigido antes — só verificação)
Fileira `Todos / Não ouvidos / Ouvidos` + ícone de ordenar não cabe na
largura da tela, último chip cortado.
- Ação: envolver a fileira em `SingleChildScrollView(scrollDirection:
  Axis.horizontal)`, mesmo padrão já usado em Descobrir/Categorias.
- Arquivo: fileira de filtros em `lib/features/podcast_detail/view/`.

### 6. Detalhe do podcast: badge de gênero em inglês ("Comedy Fiction") ✅ (28.6)
UI é 100% pt-BR, mas o chip de categoria mostra string bruta do iTunes,
quebrando consistência de idioma. Já existe mapa de gêneros por ID em
`podcast_genres.dart` — esse campo específico provavelmente vem de outro
lugar (categoria textual direta do RSS/lookup) sem passar pelo mapa.
- Ação: mapear a string de categoria mostrada pra pt-BR, reaproveitando/
  estendendo `podcast_genres.dart`.
- Arquivo: `lib/data/models/podcast_genres.dart` + tela de detalhe do
  podcast.

### 7. Pull-to-refresh usa spinner Material padrão, não tematizado ✅ (28.2)
`RefreshIndicator` default (`lib/features/home/view/home_screen.dart:38`) é
a única exceção à regra "loading = shimmer, nunca spinner"
(`CLAUDE.md` → Design system) — aparece cinza/branco sobre fundo pastel.
- Ação: no mínimo tematizar com `color: AppColors.primary` / `backgroundColor:
  AppColors.surface`. Verificar o mesmo padrão em Descobrir/Biblioteca/Rádio.
  Redesenho completo do indicador é opcional, baixa prioridade.
- Arquivo: `lib/features/home/view/home_screen.dart` (+ equivalentes nas
  outras 3 abas).

### 8. `docs/DESIGN_SYSTEM.md` desatualizado ✅ (28.8)
Doc cita `google_fonts` e `textMuted #8B8493`, mas código usa fontes
vendorizadas em `assets/fonts/` (offline-first) e `textMuted #6B6474`
(ajuste de contraste 4.5:1 só comentado no código, não no doc).
- Ação: atualizar `docs/DESIGN_SYSTEM.md` com os valores reais.

## Fora de escopo (citado, não implementar aqui)

- Contagem "não lidos" da Biblioteca sem cap visual (`library_screen.dart`
  ~183, hits 1836/1730) — já é TODO conhecido em `roadmap_v3.md`.
- Ícones de ação sem `tooltip` explícito (share/equalizer/sleep timer no
  player) — passe de acessibilidade separado; conferir de passagem ao mexer
  no item 2.

## Ordem sugerida

1. Item 3 (borda do segmented button) — trivial, zero risco.
2. Item 7 (tema do RefreshIndicator) — trivial, 4 arquivos.
3. Item 1 (Rádio maxLines/ícone) — isolado.
4. Item 2 (player app bar → overflow menu) — médio.
5. Item 5 (chips scrolláveis no detalhe) — isolado.
6. Item 4 (biblioteca) — validar decisão de produto antes.
7. Item 6 (tradução de gênero) — achar a origem exata da string primeiro.
8. Item 8 (doc) — por último.

## Verificação por item

`flutter analyze` limpo + `flutter test` (271/271 hoje, ajustar teste se
`maxLines`/estrutura mudar) + reinstalar no device físico
(`./scripts/run_android.sh`) e renavegar as mesmas 8 telas pra confirmar o
fix visualmente.

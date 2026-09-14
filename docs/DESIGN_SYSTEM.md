# Design System — pastel, arredondado, lento

Regra de ouro: **nenhum widget escreve cor, raio, sombra ou duração literal.**
Tudo vem de `frontend/lib/core/theme/`. Se um valor não existe lá, ele entra
lá primeiro — nunca direto no widget.

## Paleta

### Claro

| Token | Hex | Uso |
|---|---|---|
| `background` | `#FAF7F5` | fundo das telas |
| `surface` | `#FFFFFF` | cards, sheets |
| `primary` (lavanda) | `#B8AEE8` | ação principal, play |
| `secondary` (menta) | `#A8D8C8` | destaques, progresso |
| `accent` (pêssego) | `#F5C6AA` | badges, download |
| `textPrimary` | `#3A3542` | títulos |
| `textMuted` | `#6B6478` | metadados (era `#8B8493`, contraste 3.4:1 abaixo do mínimo 4.5:1 — escurecido mantendo o tom) |

### Escuro

Mesmos matizes dessaturados sobre `#1E1B24` (background) / `#282430` (surface).

## Forma e profundidade

- Raios: `radiusSm 16`, `radiusMd 24`, `radiusSurface 32`.
- Botões em `StadiumBorder` (raio total).
- Sem `Divider`, sem borda dura. Separação vem de sombra suave:
  `blurRadius 24`, `offset (0, 8)`, `color: black.withValues(alpha: 0.06)`.
- Tipografia: **Nunito** (terminais arredondados, combina com a forma),
  vendorizada em `assets/fonts/` (offline-first, não `google_fonts`). Pesos
  400/600/700; títulos com `letterSpacing` levemente negativo.

## Movimento

Fonte: `core/theme/motion.dart`.

- Durações: `fast 250ms`, `base 450ms`, `slow 700ms`, `page 550ms`.
- Curvas: `Curves.easeOutCubic` pra entrada, `Curves.easeInOutCubicEmphasized`
  pra transformação, `Curves.easeInOut` pro resto.
- **Proibido**: `Curves.linear`, qualquer curva de "bounce".
- Transição de rota: fade + slide vertical sutil (16px), duração `page`.
- `Hero` na capa do podcast entre lista → detalhe → player.
- Preferir widgets implícitos (`AnimatedContainer`, `AnimatedSwitcher`,
  `AnimatedOpacity`) com duração `base`.
- Mini-player → full player: `AnimatedSize` + `Hero`.
- Loading é shimmer pastel (`ShimmerBox`), nunca `CircularProgressIndicator`
  girando sozinho numa tela vazia.
- Respeitar `MediaQuery.of(context).disableAnimations` — quando true, cortar
  pra duração zero (acessibilidade).

## Checklist ao criar um widget novo

1. Cor vem de `Theme.of(context).colorScheme` ou de `AppColors`, nunca de um
   `Color(0xFF...)` solto no widget.
2. Raio vem de `AppRadii`, nunca `BorderRadius.circular(12)` com número cru.
3. Se anima, a duração vem de `AppMotion` e a curva é uma das permitidas acima.
4. Testar em claro e escuro antes de considerar pronto.

# Roadmap de qualidade pré-lançamento (Play Store + preparo iOS)

> Continuação do que foi achado na sessão de teste em device físico
> (`perf/device-profiling-and-concurrent-refresh`, branch já commitada e
> pushada — 8 bugs de travamento persistente corrigidos e verificados no
> device, ver commit `bdfa159`). Este documento cobre a segunda parte
> pedida: revisão de código (boas práticas Flutter, performance,
> Android/iOS) e o plano faseado do que falta.
>
> Tarefas pequenas de propósito — cada uma cabe numa sessão curta, pode
> pausar entre elas. Marcar `[x]` ao terminar e atualizar "Onde parei" no
> topo antes de fechar a sessão.

## Onde parei

**Fase A verificada (2026-09-13)** — 2 dos 3 achados eram falso positivo
(código já estava certo, ver tabela); sobrou só A2, opcional e sem
urgência, não feito. **Fase B iniciada**: B1/B2 feitos (só edição de
`Info.plist`, não precisa Xcode pra escrever) e validados com
`plutil -lint`. B3/B4 seguem bloqueados de verdade — precisam
device/simulador iOS rodando o app, que não existe nesta máquina. Próximo
passo: B3/B4 quando o ambiente permitir, ou A2 se algum dia importar.

## Método da revisão

3 revisões direcionadas (performance de renderização, lifecycle
Riverpod/vazamento de recurso, gaps Android/iOS) + verificação manual dos
achados mais fortes (leitura direta de `podcast_audio_handler.dart`,
`Info.plist`, `AndroidManifest.xml`). Achados triviais/sem consequência
prática foram descartados — só entram aqui itens com ação concreta.

**Veredito geral: arquitetura está sólida.** `StreamSubscription`/`Timer`
em todos os ViewModels são cancelados corretamente em `ref.onDispose`
(`player_view_model.dart`, `radio_view_model.dart`,
`discover_view_model.dart`, `library_search_view_model.dart`); guards de
`ref.mounted` existem nos pontos assíncronos certos; animações 100% via
`AppMotion` (nenhuma `Duration`/`Curves` literal fora do padrão). Não
achamos bug novo de travamento — os achados abaixo são de robustez e
prontidão multiplataforma, não de "app quebrado".

## Achados

| # | Achado | Severidade | Fase |
|---|---|---|---|
| 1 | iOS sem `UIBackgroundModes` no `Info.plist` — áudio para ao minimizar o app | Alta (bloqueia iOS) | B1 |
| 2 | Deep link `podcastapp://` só registrado no Android (`AndroidManifest.xml`); iOS sem `CFBundleURLTypes` | Alta (bloqueia iOS) | B2 |
| 3 | `ListView` com filhos literais (sem `.builder`) na aba "Baixados" (`podcast_detail_screen.dart`) e em `downloads_screen.dart` — só importa se a lista crescer muito (hoje limitada por espaço em disco, não é urgente) | Baixa, opcional | A2 |
| 4 | ~~5x `SizedBox` sem `const`~~ — **falso positivo**, verificado: todos estão dentro de `children: const [...]`, já são const por herança da lista. Nenhuma ação. | N/A | — |
| 5 | ~~`featured_view_model.dart` `keepAlive` desnecessário~~ — **falso positivo**, verificado: comentário no próprio arquivo (linha 11) já justifica a decisão ("ranking muda pouco; cachear pela sessão evita rede à toa"). Nenhuma ação. | N/A | — |
| 6 | `AndroidEqualizer`/`AndroidLoudnessEnhancer` instanciados sem guard de plataforma em `podcast_audio_handler.dart:29,34` | Verificar, não corrigir às cegas | B3 |

Item 6 — **não é bug confirmado**: o comentário no próprio código já
documenta a decisão ("no iOS o efeito fica no pipeline mas é ignorado"), o
que bate com o design do `just_audio` (`AndroidEqualizer`/
`AndroidLoudnessEnhancer` são no-op fora do Android, não lançam exceção).
Fica como item de **verificação manual em device iOS real** quando o
ambiente permitir buildar (`docs/roadmap_debito_tecnico.md` já lista iOS
como bloqueado por falta de Xcode/CocoaPods nesta máquina) — não uma
correção a fazer sem device pra testar.

Descartado por não ter consequência prática: inventário de `Opacity`/
`ClipRRect` (uso moderado, intencional, sem sinal de abuso); `ListView`
não-builder em telas com poucos itens fixos (Ajustes, Início, Descobrir —
não crescem, `.builder` não traria ganho).

## Fase A — Housekeeping de performance (Android, opcional/baixo impacto)

Dos 3 achados originais desta fase, 2 eram falso positivo (ver tabela
acima) — o código já estava certo. Sobrou só isto, e é opcional:

- [ ] **A2** (opcional) — `ListView.builder` na aba "Baixados" de
      `podcast_detail_screen.dart` e em `downloads_screen.dart` (mesmo
      padrão já usado na lista de episódios de `podcast_detail_screen.dart`
      linha ~417). Só vale a pena se algum usuário real acumular muitos
      downloads simultâneos — hoje o limite prático é espaço em disco.

## Fase B — Preparo iOS (fazer quando Xcode/CocoaPods estiverem disponíveis)

Bloqueado até o ambiente permitir (mesmo bloqueio já documentado em
`docs/roadmap_debito_tecnico.md` → "iOS (Fase 7 da v1)"). Preparar o código
agora custa pouco e evita re-trabalho depois.

- [x] **B1** — Adicionar `UIBackgroundModes` (`audio`) no
      `frontend/ios/Runner/Info.plist` — sem isso o áudio para assim que o
      app sai de foreground no iOS (achado #1). **Feito (2026-09-13)**: só
      edição de XML, não precisa Xcode pra escrever, só pra testar depois.
      Validado com `plutil -lint`.
- [x] **B2** — Registrar `CFBundleURLTypes` com o scheme `podcastapp` no
      `Info.plist` (paridade com o `intent-filter` do Android) — sem isso
      nenhum deep link customizado abre no iOS (achado #2). **Feito
      (2026-09-13)**, mesmo commit de B1.
- [ ] **B3** — Quando houver device/simulador iOS: testar manualmente
      volume/equalizer/reforço de volume — confirmar que
      `AndroidEqualizer`/`AndroidLoudnessEnhancer` realmente não quebram
      nada (achado #6) e que a UI já esconde os controles corretamente
      (já confirmado no código: `player_screen.dart` só mostra o botão de
      equalizer com `defaultTargetPlatform == TargetPlatform.android`).
- [ ] **B4** — Rodar a suíte completa num simulador iOS pela primeira vez;
      catalogar o que quebrar como itens novos (não adivinhar aqui).

## Fase C — Fechamento

- [ ] **C1** — Atualizar `docs/roadmap_debito_tecnico.md`: remover/ajustar
      a linha de iOS se a Fase B tiver sido concluída; ou manter como está
      se ainda bloqueado por ambiente.
- [ ] **C2** — Commit + push das Fases A (e B, se feita) numa branch
      própria (ex. `chore/qualidade-pre-launch`), seguindo o mesmo padrão
      do commit `bdfa159`.

## Verificação (repetir a cada fase)

```bash
cd frontend
dart analyze                # limpo, sem exceção
flutter test                 # 245+ testes, 0 falha
```

Fase A: sem device necessário (mudança de código puro Dart, cobertura já
existente nos testes de widget/repo). Fase B: precisa Xcode + CocoaPods
(ambiente que hoje não existe nesta máquina) — não iniciar sem isso.

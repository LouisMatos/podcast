# Roadmap v3 — correções e robustez (Android)

> **Continuação de `docs/ROADMAP.md` (v1, Fases 0–8) e `docs/ROADMAP_V2.md`
> (v2, Fases 9–18, FECHADA).** A v3 **não adiciona funcionalidade** — as que
> existem continuam idênticas. Cada fase pega uma coisa que hoje funciona mal
> (jank, metadado errado, aviso faltando, número sem sentido, build com
> warning) e faz voltar a funcionar direito.
>
> O que exigir rework grande ou decisão de arquitetura **não entra aqui** — vai
> pra `docs/roadmap_debito_tecnico.md` e é feito depois, com calma.

## Como a v3 nasceu

Sessão de 2026-09-08: app rodado no emulador (Pixel_6, API 31) + `flutter test`.
**212/212 testes verdes, `dart analyze` limpo, zero crash / ANR / exceção
Flutter / RenderFlex overflow.** Exercitado: 4 abas, detalhe de podcast, player
cheio, mini-player, fila, busca de podcast e de episódio, pull-to-refresh,
offline, rotação landscape, áudio em background, media session, restauração de
estado no relaunch. Banco íntegro (schema v7, 6 assinaturas, 5369 episódios em
cache, fila 4).

Conclusão: **o app não está quebrado.** Os achados abaixo são de polimento,
robustez e prontidão de publicação.

| # | Achado | Vira |
|---|---|---|
| 1 | Cold start "Skipped 117 frames" — trabalho pesado no primeiro frame | Fase 19 |
| 2 | `AudioMediaPlayerWrapper: Timeout while waiting for metadata to sync` repetindo; media session com `duration=0` / `image=null` nos itens da fila | Fase 20 |
| 3 | Duração inconsistente: detalhe do episódio "6min" (`itunes:duration`) vs player "07:11" (real do `just_audio`) | Fase 21 |
| 4 | Deep link com URI malformada → volta pra Home sem nenhum aviso | Fase 22 |
| 5 | IME `InputConnectionWrapper` TimeoutException nos campos de busca (provável ruído de emulador) | Fase 20 (verificação) |
| 6 | Badge "não-ouvidos" = catálogo inteiro em cache (O Assunto 1836, NerdCast 1730) — número real, inútil como sinal de novidade | Fase 23 |
| 7 | Warnings KGP em 5 plugins (`file_picker`, `flutter_downloader`, `sensors_plus`, `share_plus`, `workmanager_android`) | Fase 24 |
| 8 | `permission_handler` fixado em `^12` (o `^13` exige compileSdk 37) | Fase 24 |
| 9 | Emulador é API 31 — caminhos Android 13+ não exercitados | Fase 24 |
| 10 | Ícone/splash default do Flutter, sem screenshots de loja | Fase 26 |
| 11 | Senha placeholder da keystore (`podcast-changeme`) | Fase 26 |
| 12 | Android Auto implementado, nunca testado (sem DHU / carro) | Fase 26 |
| 13 | `setVolume` / `setEqualizerBandGain` sem teste (platform channel) | débito técnico |
| 14 | Teste formal de schema com `drift_dev` schema tooling | Fase 25 ou débito |

## Onde parei

**Fases 19, 21, 22, 23 concluídas** (2026-09-08) — `dart analyze` limpo, 215
testes verdes (era 212), verificado no emulador: log de erro + tela amigável,
deep link inválido mostra "Link inválido", badge de não-ouvidos caiu de
1836/1730 pra 61/20/4.

**Fase 26a e 26b concluídas** (2026-09-11, fora de ordem — puxadas pela
publicação): nome do app trocado pra "Ecoo", ícone adaptativo + splash
gerados (`flutter_launcher_icons`/`flutter_native_splash`, arte própria em
`frontend/assets/branding/`), senha da keystore trocada (placeholder
`podcast-changeme` não existe mais), `.apk`/`.aab` de release validados.
Detalhe completo em `~/.claude/plans/deve-ler-o-arquivo-synchronous-quail.md`.

**Fase 20 e parte de 26c validadas em device físico** (SM-G570M, 2026-09-13):
metadados de mídia (notificação com artwork/título corretos, `duration=0`/
`image=null` não reproduz fora do emulador), app shortcuts, share de
episódio e deep link `https://` — todos sem bug. Falta só a parte AVRCP
real (fone/carro Bluetooth pareado, sem periférico disponível nesta sessão)
e o Desktop Head Unit do Android Auto.

**Fase 20 e Fase 25 fechadas** (2026-09-15, ver
`docs/roadmap_pendencias_implementacoes.md` Fases 2-3): testes de
`_toMediaItem`/deep link/duração adicionados, badge de não-ouvidos já
tinha cobertura, IME timeout confirmado ruído de emulador no SM-G570M.

**Falta:** 24 (precisa AVD/device API 34+ — SM-G570M é API 26, não
resolve), 26c Android Auto/DHU (precisa Desktop Head Unit ou carro real) e
AVRCP Bluetooth real (precisa periférico pareado). Schema test formal
`drift_dev` avaliado na Fase 25 e não coube — segue registrado em
`docs/roadmap_debito_tecnico.md`.

**Perf em device físico + componentes independentes concluído** (2026-09-
12/13, fora da numeração de fases desta v3 — branch
`perf/device-profiling-and-concurrent-refresh`): detalhe completo em
`docs/roadmap_perf_device.md`. Ver também `docs/roadmap_ponytail_perf.md`
(otimização de APK/device fraco, sessão anterior).

**Cache offline de busca/listagem concluído** (2026-09-14, capacidade
nova — não é polimento da v3, numerada Fase 27 em `docs/roadmap_cache_offline.md`,
branch `feature/cache-offline-fase27-1-schema` a partir de
`feature/ui-density-fase4-unify-episode-row`): Fases 27.1–27.6, cache-aside
em `PodcastRepository`/`RadioRepository` + stale-while-revalidate em
Discover/Featured/Rádio/Detail, validado em device físico (SM-G570M).
Mergeado em `feat/fase-9` via PR #3 (2026-09-14), junto da Fase 28.

**Polimento UI/UX concluído** (2026-09-14, fora da numeração original da v3
— capacidade de polimento pontual, não correção de robustez — numerada
Fase 28, detalhe em `docs/roadmap_ui_review.md`, branch
`feature/ui-review-fase28` a partir de
`feature/cache-offline-fase27-pr-ready`): Fases 28.1–28.8, validado em
device físico (SM-G570M). Um bug extra achado só no device (bottom sheet do
temporizador do player estourando 8px) foi corrigido junto do item 28.4.

## Regra de ouro (por fase) — igual v1/v2

- `dart analyze` limpo (roda `riverpod_lint`; `flutter analyze` **não** roda o
  plugin — usar `dart analyze`).
- `flutter test` verde — **todos os testes das Fases 0–18 continuam passando**;
  zero regressão é requisito.
- App rodando via `./scripts/run_android.sh`.
- Commit `fix:` / `chore: fase N — ...`.
- `docs/roadmap_v3.md` (checkbox + "Onde parei") e `CLAUDE.md` (se mudou
  mapa/nota) atualizados.
- **Invariante da v3**: nenhuma fase altera o que o usuário consegue fazer. Se
  a mudança para fazer a coisa funcionar direito exigir muito, ela para e o
  item vai pro `roadmap_debito_tecnico.md`.

Regras que não mudam: MVVM (`docs/ARCHITECTURE.md`), design system
(`docs/DESIGN_SYSTEM.md` — cor/raio/sombra/duração só de `core/theme/`).
Migração drift: bloco `if (from < N)` sequencial, bump `schemaVersion`, schema
test. Dep nova: `flutter pub get` + `dart analyze` logo depois.

---

## Fase 19 — Arranque e captura de erro · esforço S ✅

**Concluída (commit `fix: fase 19 v3`).** Entregue: `runZonedGuarded` +
`FlutterError.onError` + `PlatformDispatcher.onError` → `ErrorLog` (arquivo
local rotativo em `core/diagnostics/error_log.dart`, local-only);
`ErrorWidget.builder` → `ErrorScreen` autossuficiente no lugar da tela cinza;
`FeedSyncScheduler.apply` movido pra `addPostFrameCallback` (fora do caminho
crítico do `runApp`). Cold start no emulador caiu de "Skipped 117 frames" pra
~66. **Profiling fino com devtools timeline em device físico**: feito em
2026-09-12/13, ver `docs/roadmap_perf_device.md` (cold start ~1.37s no J5,
refresh de feeds paralelizado, prazo total por requisição HTTP, componentes
de tela independentes de loading).

**Problema:** cold start pinta "Skipped 117 frames" / "42 frames" no logcat —
o primeiro frame carrega trabalho que podia esperar. E se o `runApp` explode
hoje, o usuário vê tela cinza sem nenhuma pista.

- [ ] Instrumentar o cold start (`--profile` + devtools timeline). Mover do
      caminho do primeiro frame: warm-up de providers `keepAlive` não-visuais,
      `precacheImage` só do que está na viewport, adiar
      `startupFeedRefreshProvider` + `AutoDownloadService` pra
      `addPostFrameCallback` (já são pós-frame? confirmar e empurrar mais).
- [ ] Error boundary global: `FlutterError.onError` +
      `PlatformDispatcher.onError` → log local rotativo (novo
      `lib/core/diagnostics/error_log.dart`, **sem serviço externo** —
      local-only). `ErrorWidget.builder` e um `runZonedGuarded` com tela de
      erro amigável ("algo deu errado, reabra o app") no lugar da tela cinza.
- [ ] Teste: `error_log` grava e rotaciona; smoke de que a tela de erro monta.

**Arquivos:** `frontend/lib/main.dart`, `frontend/lib/app/app_shell.dart`,
`frontend/lib/features/library/view_model/startup_feed_refresh_provider.dart`,
novo `frontend/lib/core/diagnostics/error_log.dart`.

**Não muda comportamento:** mesmas telas, mesmo fluxo — só timing de startup e
um fallback de erro que hoje não existe.

## Fase 20 — Metadados de mídia (lockscreen / Bluetooth / Android Auto) · esforço M · INVESTIGAÇÃO

**Problema:** no emulador, logcat repete
`E/AudioMediaPlayerWrapper: Timeout while waiting for metadata to sync` a cada
~10s durante a reprodução, e `dumpsys media_session` mostra `duration=0` e
`image=null` em **todos** os itens da fila (os dados no banco estão certos —
`episode_duration_seconds` e `episode_image_url` preenchidos). Pode ser
artefato da stack Bluetooth AVRCP do emulador **ou** bug real que deixa o
lockscreen sem barra de progresso e o display do carro sem capa.

- [x] Reproduzir em **device físico** (SM-G570M, 2026-09-13): tocando episódio
      real, `dumpsys media_session` mostra `metadata:size=12` preenchido
      (título/subtítulo/artista corretos) e a notificação de mídia expandida
      mostra artwork e texto certos — **`duration=0`/`image=null` não
      reproduz fora do emulador**, era mesmo artefato de stack. Sem fone/
      carro Bluetooth disponível nesta sessão — a parte AVRCP real segue não
      testada (falta o periférico, não é bloqueio de código).
- [x] Verificar também o item 5 (IME `InputConnectionWrapper` timeout nos
      campos de busca) — **confirmado ruído de emulador** (2026-09-15,
      SM-G570M): digitação normal e sob stress na busca de Descobrir,
      zero ocorrência no `logcat`, nenhuma tecla perdida.
- [x] "Se for real": N/A — `duration=0`/`image=null` (linha 161-167) e o
      timeout do IME (item 5) foram ambos confirmados artefato de
      emulador, não reproduzem em device físico. Sem correção necessária.
- [x] Teste: `_toMediaItem` produz `duration` + `artUri` corretos —
      `test/features/player/player_view_model_test.dart` (Fase 25 v3,
      2026-09-15).

**Arquivos:** `frontend/lib/services/audio/podcast_audio_handler.dart`,
`frontend/lib/features/player/view_model/player_view_model.dart` (`_toMediaItem`
~730, `_syncQueue` ~337, `_broadcastPlaybackState` ~207),
`frontend/lib/services/audio/media_browser_controller.dart`.

**Não muda comportamento:** a reprodução é a mesma; só os metadados nas
superfícies externas ficam certos.

## Fase 21 — Consistência de duração · esforço S ✅

**Concluída (commit `fix: fases 21 e 23 v3`).** `LibraryRepository.updateEpisodeDuration`
grava a duração real que o player descobre em `episode_cache.duration_seconds`
(sem migração — coluna já existe); `PlayerViewModel._onMediaItemChanged` chama
uma vez por episódio, só quando diverge > 2s. Depois de tocar um episódio, todas
as telas leem o valor corrigido do cache. Teste em `library_repository_test.dart`.

**Problema:** o detalhe do episódio mostra "6min" (arredondado do
`itunes:duration`), o player mostra "07:11" (real do `just_audio`). Números
diferentes pro mesmo episódio em telas diferentes.

- [ ] Uma fonte de verdade pra duração exibida: real do player quando
      conhecida, senão `itunes:duration`. Quando o player descobre a real,
      backfill `episode_cache.duration_seconds` (UPDATE simples, **sem
      migração** — coluna já existe).
- [ ] Detalhe do episódio, `EpisodeRow`, mini-player e player mostram o mesmo
      valor.
- [ ] Teste: função pura de "duração a exibir" (real > itunes > "—").

**Arquivos:** `frontend/lib/features/episode_detail/`,
`frontend/lib/core/widgets/episode_row.dart`,
`frontend/lib/features/player/view/`,
`frontend/lib/data/repositories/library_repository.dart`.

**Não muda comportamento:** mesma tela, mesma info — só sem divergência.

## Fase 22 — Deep link à prova de erro · esforço S ✅

**Concluída (commit `fix: fase 22 v3`).** `parseDeepLink` não lança mais quando
o guid decodifica pra um `%` solto; `DeepLinkUnknown` → nova rota
`/resolve/invalid` → `SnackBar` "Link inválido" (antes: mudo pra Home).
Verificado no emulador com `podcastapp://coisa/xyz`. Testes novos em
`deep_link_service_test.dart`. **Não feito:** timeout/retry explícito na
resolução — o `RetryInterceptor` + timeouts do Dio (Fase 18) já cobrem, o
`_consume` do resolver trata `error`.

**Problema:** `DeepLinkResolverScreen` já mostra SnackBar quando o id não
existe ("Podcast não encontrado"), mas uma **URI malformada** cai em
`DeepLinkUnknown` → `_leave()` → volta pra Home **mudo**.

- [ ] `DeepLinkUnknown` (e falha de `parseDeepLink`) mostram SnackBar "Link
      inválido" antes de sair.
- [ ] Timeout explícito + retry na resolução
      (`resolvedDeepLinkEpisodeProvider`, `podcastByIdProvider`) — hoje um feed
      lento trava a tela-ponte no spinner.
- [ ] Teste: `parseDeepLink` com lixo → `Unknown`; resolver mostra aviso e sai
      em vez de navegar.

**Arquivos:**
`frontend/lib/features/deeplink/view/deep_link_resolver_screen.dart`,
`frontend/lib/services/deeplinks/deep_link_service.dart`.

**Não muda comportamento:** deep link válido resolve igual; inválido agora
avisa em vez de sumir.

## Fase 23 — Badge de não-ouvidos com significado · esforço S ✅

**Concluída (commit `fix: fases 21 e 23 v3`).** Métrica escolhida: **episódios
publicados nos últimos 30 dias** (`LibraryRepository.unplayedWindow`), não
arquivados, não completados — `customSelect` ganhou `e.published_at >= ?` via
`Variable.withDateTime`. Cap "99+" no `_UnplayedBadge`. A ordenação "Mais
não-ouvidos" acompanha sozinha (mesma função pura). No emulador o badge caiu de
1836/1730 pra 61/20/4/4. Testes em `library_repository_test.dart`.

**Problema:** o badge na Biblioteca conta **todo** episódio em cache sem
`playback_progress.completed = 1` — pra O Assunto isso é 1836, pra NerdCast
1730. Número real, mas não diz "tem coisa nova pra ouvir".

- [ ] Redefinir a métrica no `customSelect` de `watchSubscriptionsWithMeta`
      (`library_repository.dart` ~547): contar só episódios **desde a
      assinatura** (`episode_cache.added_at` / `subscriptions.last_refreshed_at`)
      ou "não-iniciados dos últimos N". Escolher no início da fase e registrar
      o porquê numa frase.
- [ ] Cap visual "99+" no `_UnplayedBadge` (`library_screen.dart` ~183).
- [ ] A ordenação "Mais não-ouvidos" (`library_controls.dart:86`) usa a nova
      métrica; segue **função pura**.
- [ ] Teste: `applyLibraryControls` com a nova contagem; query devolve o
      esperado num banco montado à mão.

**Arquivos:** `frontend/lib/data/repositories/library_repository.dart`,
`frontend/lib/features/library/view/library_screen.dart`,
`frontend/lib/features/library/view_model/library_controls.dart`.

**Muda o número exibido** (é o objetivo). A funcionalidade — badge + ordenar
por não-ouvidos — continua.

## Fase 24 — Toolchain e SDK · esforço M

**Problema:** 5 plugins disparam warning KGP ("Future versions of Flutter will
fail to build"). `permission_handler` preso no `^12`. Nunca rodou em API 34+.

- [ ] Subir `compileSdk` / `targetSdk` pro que o Flutter atual pede; revalidar
      os 5 plugins; tentar `permission_handler ^13`.
- [ ] Rastrear upstream dos plugins KGP; migrar os que já têm release Built-in
      Kotlin; anotar issue nos que não têm. Manter `android.builtInKotlin=false`
      enquanto faltar algum (a migração completa é débito técnico).
- [ ] Smoke test num AVD API 34+: POST_NOTIFICATIONS runtime, predictive back,
      notificação de episódio novo, prompt de bateria.
- [ ] `flutter test` + `dart analyze` verdes depois de cada bump de dep.

**Arquivos:** `frontend/android/` (`build.gradle.kts`, `gradle.properties`),
`frontend/pubspec.yaml`.

**Não muda comportamento:** mesmo app, build mais são e testado em Android novo.

## Fase 25 — Fechar lacunas de teste · esforço S

- [ ] Testes que faltaram nas fases anteriores da v3: `_toMediaItem`, resolução
      de deep link (sucesso + `Unknown` + erro), badge novo, duração a exibir.
- [ ] Avaliar o schema test formal com `drift_dev` schema tooling (item 14):
      gerar snapshots de schema v2…v7 e `SchemaVerifier`. Se couber aqui,
      fecha a dívida da Fase 9; se for grande, vai pro débito técnico.

**Arquivos:** `frontend/test/`.

## Fase 26 — Prontidão de publicação · depende de arte / hardware / ação manual

Sub-fases porque cada parte depende de um input externo diferente:

- [x] **26a — Arte** ✅ (2026-09-11): ícone adaptativo + splash (Android 12
      splash screen API) gerados via `flutter_launcher_icons`/
      `flutter_native_splash`; arte própria (sem designer) em
      `frontend/assets/branding/source/`; screenshots de loja reais
      (emulador) em `frontend/assets/branding/screenshots/`.
- [x] **26b — Keystore** ✅ (2026-09-11): senha placeholder trocada (keystore
      é PKCS12 — só `storepasswd` existe pra esse formato, store/key
      compartilham senha). Senha real fora do repo em
      `~/podcast-keystore-secrets/`, detalhes em `docs/PLAY_STORE.md`.
- [ ] **26c — Carro**: testar Android Auto com o Desktop Head Unit (segue
      bloqueado — sem DHU/carro disponível).
  - [x] App shortcuts (long-press no ícone "Ecoo"): menu mostra "Fila" e
        "Continuar"; "Continuar" abre direto no episódio de "Continuar
        ouvindo" e já dispara o play — validado em device físico
        (SM-G570M, 2026-09-13).
  - [x] Share de episódio: share sheet do Android abre, texto compartilhado
        traz título + link real do episódio (ex.: link Spotify quando o
        feed expõe um) — validado, sem bug.
  - [x] Deep link `https://` num device real: `am start -a VIEW -d
        "https://..."` com feed RSS externo abre a tela "Assinar feed" e
        carrega corretamente (testado com feed de 2750 episódios) —
        validado, sem bug.

**Arquivos:** `frontend/android/app/src/main/res/`, `frontend/pubspec.yaml`,
`docs/PLAY_STORE.md`.

---

## Fase 28 — Polimento UI/UX · esforço S ✅ (2026-09-14)

Achados de revisão UI/UX pontual (skill `ui-ux-pro-max`, device físico),
detalhados em `docs/roadmap_ui_review.md`. Não é redesenho — polimento sobre
o design system existente. Branch `feature/ui-review-fase28`, a partir de
`feature/cache-offline-fase27-pr-ready`.

- [x] **28.1** Borda dura no `SegmentedButton` de tema (Ajustes) removida.
- [x] **28.2** `RefreshIndicator` tematizado em Início/Biblioteca/Detalhe do
      podcast (Descobrir/Rádio não usam pull-to-refresh).
- [x] **28.3** Título de rádio quebra em 2 linhas em vez de cortar.
- [x] **28.4** Barra superior do player: compartilhar e temporizador movidos
      pro menu de transbordo. Bug extra achado só no device (não em teste
      de widget): bottom sheet do temporizador estourava 8px em telas
      menores — `Column` trocado por `ListView` + `isScrollControlled`.
- [x] **28.5** Chips de filtro do detalhe do podcast — já tinham scroll
      horizontal de uma correção anterior; validado no device, sem mudança
      de código necessária.
- [x] **28.6** Gênero do podcast traduzido pt-BR (`podcast_genre_labels.dart`,
      mapa de nome iTunes → pt-BR com fallback pro original).
- [x] **28.7** Placeholder do filtro de assinaturas na Biblioteca encurtado
      (não corta mais em 360dp). Hierarquia entre os dois campos de busca
      fica pra `docs/roadmap_debito_tecnico.md` (decisão de produto).
- [x] **28.8** `docs/DESIGN_SYSTEM.md` atualizado (fontes vendorizadas,
      `textMuted #6B6478`).

Validado em device físico (SM-G570M): as 8 telas da revisão renavegadas
após os fixes. `dart analyze` limpo, `flutter test` 271/271.

**Arquivos:** `frontend/lib/features/{settings,home,library,radio,player,
podcast_detail,discover}/`, `docs/DESIGN_SYSTEM.md`.

---

## Fora da v3 — ver `docs/roadmap_debito_tecnico.md`

Migração completa Built-in Kotlin; poda de `episode_cache` pra feeds gigantes;
iOS (Fase 7 da v1); teste de `setVolume`/`setEqualizerBandGain`; cobertura
automatizada de Android Auto; sync/conta/backend; `podcast:transcript` e afins.

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

**Fase 9 concluída** (feeds vivos). Schema drift v3. 60 testes (era 55),
`dart analyze` limpo, app rodando. Próximo: **Fase 11** (aba Início) — já
tem `refreshAllSubscriptions()` pronto pra alimentar "Novos episódios", e
`EpisodeCache.addedAt` pra ordenar.
Sequência recomendada: **9 ✅ → 11 → 12 → 10 → 13 → 15 → 14 → 16 → 17 → 18**.

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

Dívida da fase: **teste formal de migração v2→v3 adiado pra Fase 18** (precisa
do schema tooling do `drift_dev`, que o projeto ainda não tem). A migração em
si é só dois `addColumn` de coluna com default/nullable.

## Fase 10 — Refresh em background + notificação de episódio novo · ALTO · M

- [ ] Dep `workmanager` — task headless periódica (default 6h, ~15min é o
      mínimo real no Android) chamando `refreshAllSubscriptions()`. Registrada
      em `main.dart`.
- [ ] Dep `flutter_local_notifications` — notificação agrupada "Podcast X: novo
      episódio", toca → abre `/library/podcast` (ou Início, se a Fase 11 já
      existir).
- [ ] Dep `permission_handler` — `POST_NOTIFICATIONS` runtime (Android 13+),
      pedido na 1ª vez que o usuário liga a notificação.
- [ ] Ajustes → nova seção "Atualização": refresh automático on/off,
      notificação on/off, "só no wifi". Persistido no `PreferencesStore`.
- [ ] Testes: task de sync (unit, repo fake); diff de "quais são novos".

**Não quebra:** permissão negada → refresh continua, só sem notificação.
`workmanager` respeita Doze.

## Fase 11 — Aba Início · CRÍTICO · M

**O payoff.** Abrir o app e já saber o que ouvir, sem caçar.

- [ ] `LibraryRepository`: `watchContinueListening()` (cross-assinatura —
      `PlaybackProgress` onde `!completed && positionSeconds > 0`, por
      `updatedAt` desc, join `episodeCache`) e `watchRecentEpisodes({int limit})`
      (episódios de todas as assinaturas por `publishedAt`/`addedAt` desc).
- [ ] `features/home/` — `HomeScreen` + `HomeViewModel`: "Continuar ouvindo"
      (carrossel), "Novos episódios" (lista), atalho "Fila" (aparece após a
      Fase 12). Pull-to-refresh → `refreshAllSubscriptions()`.
- [ ] `AppShell`: 4ª aba "Início" (`Icons.home_outlined`/`home`), vira
      `initialLocation`. `app_router.dart` ganha branch `/home`.
- [ ] Refatorar `PodcastListTile` + tiles de episódio pra navegação
      **path-agnostic** (hoje hardcodam `context.push('/discover/...')`).
      Destrava reuso na Início e em qualquer tela nova.
- [ ] Testes: as duas queries novas (drift in-memory); widget test da Início
      vazia e com dados.

**Não quebra:** Descobrir/Biblioteca/Ajustes intactos — entra 1 aba.
`IndexedStack` mantém estado das 4.

## Fase 12 — Fila de reprodução real · CRÍTICO · esforço G

**Problema:** a "fila" hoje é só a lista do podcast atual, recarregada inteira
a cada play, some ao fechar o app. `playNextInQueue` recarrega tudo. Sem
`skipToNext`/`prev` reais.

- [ ] Schema v4: tabela `QueueItems` (`position` int, `podcastId`,
      `episodeGuid`, `addedAt`) — fila persistente cross-podcast, sobrevive ao
      kill do app.
- [ ] `QueueRepository` + `queueProvider` (stream reativo do drift).
- [ ] `PodcastAudioHandler`: overrides reais `addQueueItem`, `removeQueueItem`,
      `insertQueueItem` (tocar a seguir), `moveQueueItem` (reordenar),
      `skipToNext`/`skipToPrevious`. Avaliar `ConcatenatingAudioSource` do
      just_audio vs. gestão manual (hoje é `setAudioSource` faixa a faixa).
- [ ] `PlayerViewModel`: `enqueue(episode)`, `playNext(episode)`,
      `removeFromQueue`, `reorderQueue`. `playEpisode` interage com a fila
      persistida, não com uma `List<Episode>` volátil. `_onEpisodeCompleted`
      consome a fila.
- [ ] UI: menu "Tocar a seguir" / "Adicionar à fila" nos tiles + `EpisodeDetailScreen`;
      sheet de fila reordenável no player (`ReorderableListView`); mini-player e
      full player mostram "A seguir: …".
- [ ] **Decisão de design:** tocar um episódio da lista do podcast = toca só
      ele + oferece "enfileirar os N seguintes" (opção b — mais previsível que
      substituir a fila).
- [ ] Testes: `QueueRepository` (add/remove/move/rehidratação); handler fake
      (ordem, skipToNext).

**Não quebra:** fila vazia + tocar 1 episódio = fila de 1 item. A
`List<Episode> queue` passada hoje pra `playEpisode` some — vira operação de fila.

## Fase 13 — Gestão de episódios · ALTO · M

- [ ] Marcar ouvido / não-ouvido manual (menu do tile + swipe na Fase 15) —
      escreve `PlaybackProgress.completed`.
- [ ] Arquivar episódio — schema v5: `EpisodeCache.archived` (`bool`, false).
      Some das listas, não desassina. Filtro "mostrar arquivados".
- [ ] Schema v5: config por assinatura (`SubscriptionSettings` ou colunas em
      `Subscriptions`): `autoDownload` (`nunca`/`wifi`/`sempre`),
      `autoDownloadLimit` (int), `autoDeletePlayedDays` (int, 0 = nunca),
      `playbackSpeedOverride` (double?).
- [ ] Auto-download: ao fim de `refreshAllSubscriptions()`, pra cada assinatura
      com `autoDownload != nunca`, baixa os N novos mais recentes via
      `DownloadService` (wifi via dep `connectivity_plus`).
- [ ] Limpeza automática: junto do refresh, remove downloads `complete` +
      ouvidos há mais de `autoDeletePlayedDays` dias.
- [ ] Config por podcast (engrenagem no detalhe) + defaults globais em Ajustes.
- [ ] Testes: política de auto-download (unit); limpeza (drift in-memory).

**Não quebra:** defaults = tudo desligado → comportamento atual idêntico.
Precisa da Fase 9 (gatilho no refresh).

## Fase 14 — Player avançado · ALTO · esforço G

- [ ] `RssFeedParser`: extrair `podcast:chapters` (URL → fetch JSON),
      `itunes:episode`/`season`/`episodeType`, `<link>`, `content:encoded`
      (descrição melhor). Capítulos embutidos no ID3 só se `just_audio` expuser.
- [ ] `Episode` + `EpisodeCache` ganham `seasonNumber?`, `episodeNumber?`,
      `episodeType?`, `link?`. Schema v6. Tabela `Chapters` (`podcastId`,
      `episodeGuid`, `startMs`, `title`, `imageUrl?`).
- [ ] Player: lista de capítulos + pular capítulo + capítulo atual destacado +
      no título da notificação.
- [ ] Pular silêncio: `_player.setSkipSilenceEnabled(true)` (ExoPlayer) —
      toggle no player, persistido.
- [ ] Normalização de volume: `AndroidLoudnessEnhancer` no `AudioPipeline`
      (junto do `AndroidEqualizer`, na construção do `_player`) — toggle + ganho.
- [ ] Velocidade por podcast — `SubscriptionSettings.playbackSpeedOverride`,
      cai pra global.
- [ ] Sleep timer: "fim do episódio" + "agitar pra estender 5min"
      (dep `sensors_plus`).
- [ ] Testes: parser de capítulos (fixtures); `player_state` com capítulos.

**Não quebra:** tudo opt-in; feed sem capítulo funciona igual. `AudioPipeline`
tem que ser montado na construção do `AudioPlayer` (ver `CLAUDE.md` → Notas de
plataforma) — o `AndroidLoudnessEnhancer` entra junto do equalizer.

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
| 16 | `share_plus` | compartilhar episódio |
| 16 | `quick_actions` | app shortcuts (ou `shortcuts.xml` nativo) |
| 17 | `xml` | OPML (talvez já transitivo via `rss_dart`) |

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

# Roadmap de débito técnico

> Itens que exigem rework grande, decisão de arquitetura ou infra que não
> existe hoje. **Não são bugs abertos** — o app funciona com eles. Ficam aqui
> pra serem feitos **bem** no futuro, não às pressas dentro de uma fase.
>
> Origem: diagnóstico da sessão de 2026-09-08 (ver `docs/roadmap_v3.md` → "Como
> a v3 nasceu") + dívidas herdadas do v1/v2.

| Item | Bloqueio | Ação futura |
|---|---|---|
| Migração completa Built-in Kotlin | Depende de release upstream dos 5 plugins KGP (ou troca de plugin) | Reavaliar a cada bump de Flutter |
| `episode_cache` sem poda | Feeds gigantes (O Assunto 1837, NerdCast 1730; 5369 linhas totais) carregados inteiros | Paginação / poda por idade ou limite por podcast |
| iOS (Fase 7 da v1) | Sem Xcode + CocoaPods nesta máquina | Reativar quando o ambiente permitir |
| Teste `setVolume` / `setEqualizerBandGain` | Platform channel — não roda em `flutter test` | Integration test em device/CI |
| Cobertura automatizada de Android Auto | Precisa de infra (DHU headless / Robolectric do MediaBrowserService) | Avaliar `androidx.media-testing` |
| Schema test formal `drift_dev` | Só se não fechar na Fase 25 do v3 | Snapshots de schema + `SchemaVerifier` |
| Sync / conta / backend | Contradiz a premissa local-only | Fora de escopo até rever a premissa |
| `podcast:transcript`, soundbite, `podcast:person` | Feature nova grande, não é correção | Roadmap v4, se houver |
| Riverpod 3 `defaultRetry` mascara erro de rede real (~40s+) | Comportamento default do `ProviderContainer` (10 tentativas, backoff 200ms→6.4s) | Avaliar override de retry policy pra providers de rede (ex. `PodcastDetailViewModel`) |
| Impeller desativado (`--no-enable-impeller`) | Flag será removida em versão futura do Flutter; reabilitar exige revalidar perf em device fraco | Reavaliar quando decisão de engine for tratada como fase própria |
| Tooltip/acessibilidade ausente em ícones do player (share/equalizer/sleep timer) | Passe de acessibilidade separado, fora do polimento pontual da Fase 28 | Fase própria de acessibilidade |

---

## Migração completa Built-in Kotlin

**Hoje:** `file_picker`, `flutter_downloader`, `sensors_plus`, `share_plus` e
`workmanager_android` aplicam o Kotlin Gradle Plugin; o Flutter avisa que
versões futuras vão falhar o build. Mitigado com `android.builtInKotlin=false`
no `gradle.properties`. A Fase 24 do v3 só migra os que já tiverem release
compatível e rastreia os outros.

**Por que não dá pra fazer rápido:** o fix real depende de cada um dos 5
plugins publicar uma versão Built-in Kotlin — não está na nossa mão. Trocar de
plugin (ex.: sair do `flutter_downloader`) é reescrever a camada de download.

**Como fazer bem:** manter uma nota do estado de cada plugin; quando todos
tiverem release, remover o `builtInKotlin=false` e revalidar o build num
Flutter novo. Se um plugin morrer, aí sim avaliar a troca como fase própria.

## Poda de `episode_cache` pra feeds gigantes

**Hoje:** `cacheEpisodesIfSubscribed` guarda **todos** os episódios do feed. O
Assunto tem 1837 linhas, NerdCast 1730, total 5369. Várias queries
(`watchEpisodes`, `watchRecentEpisodes`, `watchContinueListening`,
`searchLibraryEpisodes`, o `customSelect` de `watchSubscriptionsWithMeta`)
varrem essa tabela inteira.

**Por que não dá pra fazer rápido:** mexe no `LibraryRepository` inteiro, nas
queries reativas, possivelmente em schema (marcar "podável"), e precisa de uma
política clara — podar por idade? por limite por podcast? preservar o que está
na fila / baixado / com progresso? — que afeta a aba Início e a busca.

**Como fazer bem:** definir a política primeiro (provável: manter os últimos N
+ tudo com progresso/fila/download, podar o resto por idade), depois um job de
poda no `startupFeedRefreshProvider` + índice em `(podcast_id, published_at)`.
Fase própria, com schema test.

## iOS (Fase 7 da v1)

**Hoje:** pausado de propósito desde a v1 — a máquina não tem Xcode +
CocoaPods. `sensors_plus` e outros já têm o guard `Platform.isAndroid ||
Platform.isIOS`, então o código não impede.

**Como fazer bem:** quando houver ambiente iOS, retomar a Fase 7 do
`docs/ROADMAP.md` — build, assinatura, revisão das libs nativas (audio_service,
just_audio, flutter_downloader, workmanager) no iOS.

## Teste de `setVolume` / `setEqualizerBandGain`

**Hoje:** o `equalizer_sheet_test` (Fase 18) cobre a UI, mas as chamadas de
platform channel (`AndroidEqualizer`, `setVolume` do `just_audio`) não rodam em
`flutter test` — não há engine nativa.

**Como fazer bem:** integration test (`integration_test/`) rodando num
emulador/device real no CI, tocando um áudio de fixture e conferindo que o
ganho aplica. Precisa de CI com device.

## Cobertura automatizada de Android Auto

**Hoje:** a árvore do `MediaBrowserService` (Fase 16) tem testes de unidade dos
helpers de `mediaId`, mas o fluxo real (Auto conecta → `getChildren` →
`playFromMediaId`) nunca foi exercitado — falta Desktop Head Unit.

**Como fazer bem:** avaliar `androidx.media-testing` (`MediaControllerTestRule`)
num instrumented test, ou um smoke manual documentado com o DHU a cada release.

## Schema test formal com `drift_dev`

**Hoje:** as migrações v2→v7 têm testes que montam o banco antigo à mão e
conferem colunas/dados. O tooling oficial do `drift_dev` (snapshots de schema +
`SchemaVerifier`) foi adiado desde a Fase 9.

**Como fazer bem:** `drift_dev schema dump` pra cada versão, `drift_dev schema
generate`, testes de verificação. Se a Fase 25 do v3 não absorver, fica aqui.

## Sync / conta / backend

Contradiz a premissa **local-only** (sem backend, sem login, tudo em SQLite +
`shared_preferences`), firme desde a v1. `backend/` segue placeholder. Só sai
do débito se a premissa do projeto mudar.

## `podcast:transcript`, soundbite, `podcast:person`

Namespace estendido do Podcasting 2.0. É feature nova, não correção — entra num
eventual roadmap v4, não aqui.

## Biblioteca: hierarquia entre os dois campos de busca

**Hoje:** "Filtrar" (assinaturas, inline) e "Buscar episódios na biblioteca"
(card, abre `/library/search`) ficam empilhados sem diferenciação visual
clara de escopo — Fase 28.7 só encurtou o placeholder que cortava, não
mudou a estrutura.

**Como fazer bem:** decisão de produto sobre esconder o segundo campo até
o usuário expandir "Buscar episódios", ou dar hierarquia visual mais forte
entre os dois. Fora do polimento pontual da Fase 28 — pedir direção antes
de mexer.

## Riverpod 3 `defaultRetry` mascara erro de rede real

**Hoje:** `ProviderContainer.defaultRetry` reretenta automaticamente
qualquer `@riverpod` que lance erro — até 10 tentativas, backoff
exponencial 200ms→6.4s, ~40s+ de retry cumulativo. `PodcastDetailViewModel`
cai nesse comportamento: um erro de rede real pode levar dezenas de
segundos pra aparecer como erro na tela, em vez de falhar rápido.
Achado em `docs/roadmap_perf_device.md`, fora do escopo daquela sessão.

**Como fazer bem:** avaliar override de retry policy nos providers de rede
(menos tentativas ou backoff mais curto), balanceando com o cache
stale-while-revalidate da Fase 27 (que já reduz a frequência de erro
visível).

## Impeller desativado

**Hoje:** app roda com `--no-enable-impeller` (decisão da sessão de perf em
device físico, Galaxy J5 Prime com pouca RAM). Flutter avisa que a flag
será removida em versão futura. Achado em `docs/roadmap_perf_device.md`,
não corrigido por ser decisão de engine maior que o escopo daquela sessão.

**Como fazer bem:** reavaliar quando o Flutter remover a flag —
provavelmente vai exigir revalidar perf em device fraco com Impeller
habilitado, fase própria.

## Tooltip/acessibilidade em ícones do player

**Hoje:** ícones de ação sem `tooltip` explícito no player (share/
equalizer/sleep timer, hoje agrupados no `_PlayerOverflowMenu` da Fase
28.4). Achado em `docs/roadmap_ui_review.md`, fora de escopo do polimento
pontual da Fase 28.

**Como fazer bem:** passe de acessibilidade dedicado — `tooltip` em todo
ícone de ação sem texto visível, não só no player.

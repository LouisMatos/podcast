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

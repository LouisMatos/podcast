# Perf em device físico + componentes independentes

Sessão de 2026-09-12/13, branch `perf/device-profiling-and-concurrent-refresh`
(a partir de `feat/radio-ui-parity`). Device: Samsung Galaxy J5 Prime
(SM-G570M, Android 8.0/API 26, serial `42002b900177452d`) via USB.

Objetivo original: bateria de testes de perf no device físico + tela que
busca dado da internet não pode travar outros componentes até carregar.

## Baseline (Fase 1, antes de qualquer mudança)

- **Cold start**: `am start-activity -W`, 3 execuções — 1367ms / 1340ms /
  1441ms (mediana 1367ms). Sem "Skipped N frames" no logcat nesse boot.
- **Jank de scroll**: testado em Discover (categorias estáticas + busca com
  thumbnails de rede) — nenhum "Skipped N frames" durante scroll rápido.
- **`adb shell dumpsys gfxinfo` não serve pra medir jank de app Flutter**
  neste device/API: `Total frames rendered: 0` mesmo após scroll pesado —
  Flutter renderiza pela própria `SurfaceView`/pipeline Skia/Impeller, fora
  do que o HWUI profiling clássico do Android instrumenta em API 26. Método
  usado em vez disso: warnings automáticos do próprio Flutter ("Skipped N
  frames") no console do `flutter run --profile`.
- **Achado incidental**: app roda com Impeller desativado (`--no-enable-impeller`
  / `EnableImpeller` no manifest), usa Skia. Flutter avisa que essa opção
  será removida em versão futura. Não corrigido nesta sessão (fora do
  escopo do pedido, decisão de engine é maior) — candidato a fase futura.

## Fase 2 — refresh concorrente

**Causa raiz do "trava tudo" identificada**: `LibraryRepository.
refreshAllSubscriptions` iterava assinaturas sequencialmente — um feed
lento/morto (timeout 10s + até 3 retries) segurava o pull-to-refresh
inteiro atrás dele.

**Fix**: `Future.wait` em lotes (`frontend/lib/data/repositories/
library_repository.dart`), `concurrency` parametrizável (default 4 pro
pull-to-refresh, 2 no `startupFeedRefreshProvider` pra não competir com o
primeiro frame). `Future.wait` em vez de `package:pool` — sem dependência
nova, mesmo espírito do `RetryInterceptor` (feito na mão). Try/catch por
assinatura preservado dentro do lote; throttle 1h e upsert de
`episodeCache` inalterados.

## Fase 2b (não planejada) — prazo total por requisição HTTP

Achado durante a Fase 1: aba Rádio travou **70s+ sem erro nenhum** no
device físico, CPU do processo em 0% (bloqueada em I/O), WiFi saudável
(RSSI -41, 72Mbps). Testada a API (`de1.api.radio-browser.info`) direto da
máquina: responde em 2.3s, sem problema no servidor.

**Causa**: `connectTimeout`/`receiveTimeout` do Dio medem intervalo *entre
pacotes*, não tempo total da requisição — uma rota ruim que entrega dados
aos poucos nunca estoura nenhum dos dois, trava pra sempre sem lançar erro
(sem retry, sem estado de erro pra UI mostrar).

**Fix**: `DioDeadline.getWithDeadline` (`frontend/lib/core/network/
dio_client.dart`) — `CancelToken` + `Timer` (20s default), aplicado nos 4
sources que fazem GET (`radio_browser_api`, `rss_feed_parser`,
`itunes_search_api`, `apple_charts_api`). Testado com adapter que nunca
resolve (`test/core/network/dio_client_test.dart`) — cancela e vira
`DioException(type: cancel)` em vez de travar pra sempre.

## Fase 3 — pulada

Nenhum jank adicional encontrado na Fase 1 além do refresh sequencial já
corrigido na Fase 2. Sem achado extra, sem trabalho extra (CLAUDE.md: não
adicionar mudança além do necessário).

## Fase 4 — componentes independentes

Pedido explícito do usuário: seção em loading não pode esconder/travar
componente independente na mesma tela.

- **Rádio** (`radio_screen.dart`): `_Body.build` trocava `TabBar` +
  `TabBarView` inteiros por skeleton durante `state.isLoading`, escondendo
  as abas "Todas"/"Favoritas". Fix: `TabBar` sempre renderiza; só o
  conteúdo de cada aba (skeleton/erro/lista) muda independente. Busca
  continua editável durante o load.
- **Detalhe do podcast** (`podcast_detail_screen.dart`): erro de rede
  trocava o corpo inteiro por `EmptyState`, perdendo header/artwork/
  subscribe/tabs que a branch de *loading* já preservava. Fix: erro vira
  estado só da aba Episódios (`episodesError`/`onEpisodesRetry`), header
  sempre visível.

**Achado de processo (documentado, não corrigido — fora de escopo)**:
Riverpod 3 reretenta automaticamente qualquer `@riverpod` que lance erro
(`ProviderContainer.defaultRetry` — até 10 tentativas, backoff exponencial
200ms→6.4s, ~40s+ de retry cumulativo) antes de assentar em `AsyncError`.
`PodcastDetailViewModel` é um `AsyncNotifier` (`build()` assíncrono) e cai
nesse comportamento: um erro de rede real pode levar dezenas de segundos
pra aparecer como erro pro usuário, mostrando skeleton o tempo todo antes
disso. `RadioViewModel`/`LibraryViewModel` não são afetados (tratam erro
manualmente em `try/catch`, não deixam o `build()` lançar). Decisão de
política de retry afeta todo `@riverpod` com `build()` assíncrono do app —
maior que o escopo desta sessão; candidato a `roadmap_debito_tecnico.md`
ou fase própria.

## Fase 5 — regressão

- `dart analyze` limpo (riverpod_lint)
- `flutter analyze` limpo
- `flutter test`: 245/245 (238 baseline + 2 `library_repository` + 2
  `dio_client` + 2 `radio_screen` + 1 `podcast_detail_screen`)
- `flutter build apk --release` (73.1MB) instalado no device físico
  (precisou `adb uninstall` — assinatura de release diverge da de debug/
  profile já instalada)
- Smoke test manual no device: assinar podcast (1358 episódios, feed
  grande), download de episódio, pull-to-refresh em biblioteca com
  múltiplas assinaturas reais (sem crash, completou), abrir Rádio (abas
  visíveis, tocar estação)

## Decisões

- `Future.wait` em chunks, não `package:pool` — zero dependência nova.
- `CancelToken` + `Timer` pro prazo total, não `.timeout()` direto no
  Future — cancela a requisição de verdade (evita socket/isolate
  trabalhando à toa em segundo plano).
- Profiling manual via `flutter run --profile` + console + `adb shell
  dumpsys` (memória/cold start), não `integration_test` — `dumpsys
  gfxinfo` não serve pra jank de Flutter neste device/API, e medição
  manual cobriu tudo que era preciso sem infra nova.
- Retry automático do Riverpod 3 e Impeller desativado: documentados como
  achados, não corrigidos — mudança de escopo maior que "perf desta
  sessão + componentes independentes".

## Órfãos de documentação corrigidos

`docs/roadmap_ponytail_perf.md` (fases de otimização de APK/device fraco,
sessão anterior) não estava referenciado em nenhum mapa — linkado a partir
daqui.

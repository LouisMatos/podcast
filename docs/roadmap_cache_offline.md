# Cache offline — busca/listagem (Fase 27)

**Concluída** (2026-09-14) — Fases 27.1–27.6, branch
`feature/cache-offline-fase27-1-schema`. `dart analyze` limpo, `flutter
test` 271/271, validada em device físico (SM-G570M).

Discover, Featured, Rádio e detalhe de podcast não-assinado buscam da rede
toda visita, sem guardar nada localmente — em conexão ruim/lenta a tela
trava (skeleton infinito) ou falha completo, mesmo pra conteúdo já visto
antes. Objetivo: cache local (drift) escrito a cada busca/abertura
bem-sucedida, lido primeiro pra pintar a tela na hora
(stale-while-revalidate), com refresh de rede rodando por trás.

Fora de escopo por natureza: Library/Home (já 100% drift, sem rede no
caminho) e refresh de assinatura via RSS (`LibraryRepository.refreshFeed`,
já tem cache-fallback próprio).

Branch base: `feature/ui-density-fase4-unify-episode-row` (schema v8) —
mergeado em `feat/fase-9` via PR #3 (2026-09-14), junto da Fase 28. `feat/
fase-9` já está em v8. Nota antiga de "falta mergear com PR #1" ficou
stale — PR #1 foi superado pelo PR #3, que já trouxe tudo.

## Design: tabela única `QueryCache` (blob JSON)

Resultado de busca/ranking/rádio/episódio-avulso é opaco, substituído por
inteiro a cada fetch, nunca filtrado por campo individual, e cobre 4
formatos de modelo diferentes — normalizar em tabela por tipo seria
desproporcional. Uma tabela genérica tipo "cache de resposta HTTP" resolve
com 1 migração só, e também cobre episódio de podcast **não-assinado**
sem precisar de FK (`EpisodeCache` exige `Subscriptions`).

```dart
@DataClassName('QueryCacheRow')
class QueryCache extends Table {
  TextColumn get cacheKey => text()();     // "podcast_search:cafe", "radio_stations:br", "podcast_episodes:123"
  TextColumn get category => text()();     // podcast_search|episode_search|top_podcasts|genre_podcasts|radio_stations|podcast_episodes
  TextColumn get payloadJson => text()();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {cacheKey};
}
```

## Fase 27.1 — Schema (aditivo, zero mudança de comportamento)
- [x] `tables.dart`: tabela `QueryCache`
- [x] `app_database.dart`: schemaVersion 8→9, `if (from < 9) { await m.createTable(queryCache); }`
- [x] `migration_chain_test.dart` estendido pra v2→v9 + tabela/escrita `query_cache`
- [x] `query_cache_migration_test.dart` novo — onCreate cria `queryCache` utilizável
- [x] `sqlite3` promovido a dev_dependency direta (removeu `ignore: depend_on_referenced_packages`)
- [x] `dart analyze` limpo, `flutter test` 247/247
- [x] Device físico (SM-G570M): `flutter build apk --release` + reinstalado
      (assinatura debug local diferia da release já instalada — reinstalo
      exigiu uninstall, então validou fresh-install/`onCreate`, não o
      upgrade real sobre dado existente; esse caminho já está coberto pelo
      `migration_chain_test.dart`). App abre sem crash, sem erro
      drift/sqlite no logcat.

## Fase 27.2 — `PodcastRepository` cache-aside
- [x] Construtor ganha `required AppDatabase db`
- [x] `search`, `searchEpisodes`, `topPodcasts`, `podcastsByGenre`, `episodesFor` — cache-aside (assinatura de retorno inalterada)
- [x] `cachedSearchResults`, `cachedEpisodeSearchResults`, `cachedTopPodcasts`, `cachedPodcastsByGenre`, `cachedEpisodesFor(Podcast)` — leitura pura
- [x] Testes: sucesso escreve cache; falha com cache prévio não relança; falha sem cache relança; `cachedX` null antes do 1º fetch
- [x] `dart analyze` limpo, `flutter test` 253/253

## Fase 27.3 — `RadioRepository` cache-aside
- [x] Mesmo padrão: `brStations()` cache-aside, `cachedBrStations()` novo
- [x] Teste novo, mesmo padrão de 3 casos
- [x] `dart analyze` limpo, `flutter test` 256/256

## Fase 27.4 — Stale-while-revalidate nos ViewModels (fix real de "trava")
- [x] `DiscoverViewModel`/`FeaturedViewModel`/`RadioViewModel`: pintar cache na hora, revalidar em segundo plano
- [x] `PodcastDetailViewModel.build()`: lê cache **antes** do fetch (hoje só no `catch`), assinado via `LibraryRepository.cachedEpisodes`, não-assinado via `PodcastRepository.cachedEpisodesFor`
- [x] Testes com `Completer` gate no fetch de rede (cache antes, fresco depois, falha-após-seed mantém cache) — achado real no processo: `FeaturedViewModel._revalidate` sem try/catch deixava exceção de rede escapar como erro não tratado; corrigido
- [x] `dart analyze` limpo, `flutter test` 266/266
- [x] Device físico (SM-G570M): reinstalado, sem crash, Featured carregou e escreveu no `QueryCache` (screenshot confirmado)
- [~] Roteiro offline manual no device: **bloqueado** — `svc wifi disable`/broadcast de airplane mode falham nesse aparelho (Knox/ROM travada, sem permissão pro shell adb). Comportamento offline coberto de forma determinística pelos testes com `Completer` (mais confiável que depender de timing de rede real); usuário pode desligar wifi manualmente depois se quiser confirmação visual adicional

## Fase 27.5 — Subscribe Feed: polish de UX (sem cache real)
- [x] `_LoadingCard` — **já era** shimmer no formato do card final (`ShimmerBox`), não skeleton genérico; nenhuma mudança necessária
- [x] Deadline de 20s (`getWithDeadline`) — **já existia** em `_load()` (feed) e `_resolvePodcast` (busca iTunes), ambos com prazo próprio; erro cai no `catch` genérico e vira mensagem clara, sem loading preso. Confirmado com teste novo (zero teste existia pra este ViewModel)
- [x] `subscribe_feed_view_model_test.dart` novo: erro de rede → estado de erro claro; sucesso → podcast/episódios populados; `subscribe()` idempotente
- [x] `dart analyze` limpo, `flutter test` 269/269
- [x] Nenhuma mudança de código de produção nesta fase — investigação confirmou que a fase já estava resolvida por trabalho anterior (ponytail perf); só faltava cobertura de teste

## Fase 27.6 — Cleanup, pruning, polish final
- [x] `pruneStaleQueryCache({maxAge: 30 dias})` novo (`core/database/query_cache_maintenance.dart`), disparado fire-and-forget em `startupFeedRefreshProvider` (`.catchError` — nunca derruba o boot)
- [x] Teste novo `query_cache_maintenance_test.dart`: remove só entrada velha, preserva recente, cache vazio não lança
- [ ] Indicador sutil "mostrando resultados salvos" quando revalidando offline — **pulado de propósito** (opcional no plano original, escopo extra sem necessidade real agora)
- [x] `dart analyze` limpo, `flutter test` 271/271
- [x] Regressão completa em device físico (SM-G570M): instalação sobre dado existente (migração v9 ok), Início vazio ok, Descobrir→Featured carregou e pintou do cache, busca+detalhe de podcast não-assinado carregou episódios (cache genérico gravado), assinatura funcionou, Biblioteca mostra assinatura, Rádio carregou lista — zero crash/exceção fatal/erro sqlite-drift no logcat da sessão inteira

## Riscos / avisos
- `podcastRepositoryProvider`/`radioRepositoryProvider` ganhando `AppDatabase` é plumbing — testes que constroem repositório direto precisam de update nas Fases 27.2/27.3
- `state =` intermediário em `AsyncNotifier.build()` é padrão válido no Riverpod 3, mas sensível a `ref.mounted` — replicar guard já usado em `RadioViewModel._load()`
- Cache de episódio não-assinado é só pintura imediata — não sincroniza com `EpisodeCache` se o usuário assinar depois (1ª visita pós-assinatura ainda faz fetch normal)

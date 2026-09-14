# Cache offline — busca/listagem (Fase 27)

Discover, Featured, Rádio e detalhe de podcast não-assinado buscam da rede
toda visita, sem guardar nada localmente — em conexão ruim/lenta a tela
trava (skeleton infinito) ou falha completo, mesmo pra conteúdo já visto
antes. Objetivo: cache local (drift) escrito a cada busca/abertura
bem-sucedida, lido primeiro pra pintar a tela na hora
(stale-while-revalidate), com refresh de rede rodando por trás.

Fora de escopo por natureza: Library/Home (já 100% drift, sem rede no
caminho) e refresh de assinatura via RSS (`LibraryRepository.refreshFeed`,
já tem cache-fallback próprio).

Branch base: `feature/ui-density-fase4-unify-episode-row` (PR #1 ainda
aberto) — schema já em v8 lá; `feat/fase-9` (main) ainda está em v7.
Rebasear quando o PR #1 mergear.

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
- [ ] `DiscoverViewModel`/`FeaturedViewModel`/`RadioViewModel`: pintar cache na hora, revalidar em segundo plano
- [ ] `PodcastDetailViewModel.build()`: lê cache **antes** do fetch (hoje só no `catch`), assinado via `LibraryRepository.cachedEpisodes`, não-assinado via `PodcastRepository.cachedEpisodesFor`
- [ ] Testes com `Completer` gate no fetch de rede (cache antes, fresco depois, falha-após-seed mantém cache)
- [ ] Roteiro manual device físico (busca offline, Featured offline, Rádio offline, detail assinado/não-assinado offline, revalidação ao voltar internet)

## Fase 27.5 — Subscribe Feed: polish de UX (sem cache real)
- [ ] Trocar `_LoadingCard` full-block por skeleton consistente com o resto do app
- [ ] Confirmar que o deadline de 20s (`getWithDeadline`) já existente mostra erro claro em vez de loading preso

## Fase 27.6 — Cleanup, pruning, polish final
- [ ] `pruneStaleQueryCache({maxAge: 30 dias})`, disparado fire-and-forget perto do `startupFeedRefreshProvider`
- [ ] Indicador sutil "mostrando resultados salvos" quando revalidando offline (opcional, tokens de tema existentes)
- [ ] Regressão completa das 4 abas + roteiros 27.4/27.5 em device físico

## Riscos / avisos
- `podcastRepositoryProvider`/`radioRepositoryProvider` ganhando `AppDatabase` é plumbing — testes que constroem repositório direto precisam de update nas Fases 27.2/27.3
- `state =` intermediário em `AsyncNotifier.build()` é padrão válido no Riverpod 3, mas sensível a `ref.mounted` — replicar guard já usado em `RadioViewModel._load()`
- Cache de episódio não-assinado é só pintura imediata — não sincroniza com `EpisodeCache` se o usuário assinar depois (1ª visita pós-assinatura ainda faz fetch normal)

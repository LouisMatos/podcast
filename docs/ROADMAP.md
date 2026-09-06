# Roadmap — estado do projeto

> **Este arquivo é a fonte de verdade para retomar o trabalho.**
> Ao terminar uma fase: marque os checkboxes, atualize "Onde parei" e faça commit.
> Ao voltar depois de dias: leia "Onde parei", depois `docs/ARCHITECTURE.md`, depois a fase atual.

## Onde parei

**Fase atual:** 4 — Player
**Última coisa concluída:** Fase 3 (persistência local) — assinar/desassinar com SQLite via drift, sobrevive ao restart do app, biblioteca 100% reativa
**Próximo passo concreto:** `services/audio/podcast_audio_handler.dart` (`BaseAudioHandler` + `just_audio`) e config do manifesto Android pra player em background

## Regra de ouro

Toda fase termina com o app **rodando** via `./scripts/run_android.sh` e um commit.
Nunca deixe uma fase pela metade sem anotar acima o que falta.

---

## Fase 0 — Fundação e script de execução ✅

- [x] `git init` na raiz
- [x] `flutter create` em `frontend/` (org `com.luismatos`, projeto `podcast_app`)
- [x] `backend/README.md` como placeholder
- [x] `pubspec.yaml` com a stack completa
- [x] `analysis_options.yaml` com lints e exclusão dos arquivos gerados
- [x] `scripts/run_android.sh` e `scripts/gen.sh`
- [x] `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN_SYSTEM.md`
- [x] App padrão abre no emulador pelo script

## Fase 1 — Design system e casca de navegação ✅

- [x] `core/theme/app_colors.dart` — paleta pastel, claro e escuro
- [x] `core/theme/app_typography.dart` — Nunito via `google_fonts`
- [x] `core/theme/app_radii.dart` e `app_shadows.dart`
- [x] `core/theme/motion.dart` — durações e curvas
- [x] `core/theme/app_theme.dart` — monta o `ThemeData` a partir dos tokens
- [x] `core/widgets/`: `SoftCard`, `PillButton`, `PastelChip`, `ShimmerBox`, `SectionHeader`, `EmptyState`
- [x] `core/router/app_router.dart` + `app_shell.dart` — `go_router` com `StatefulShellRoute` de 3 abas e transição fade+slide
- [x] Telas Descobrir / Biblioteca / Ajustes com dados mockados
- [x] `app.dart` com `ProviderScope` + `MaterialApp.router`
- [x] **Pronto quando:** navegação funciona, tema claro/escuro alterna, animações no tempo definido

Nota: `themeModeProvider` usa `Notifier`/`NotifierProvider`, não `StateProvider` —
Riverpod 3 moveu `StateProvider` pra `package:flutter_riverpod/legacy.dart`.
Ficou mais alinhado ao resto do projeto (que já usa `@riverpod`/codegen).

## Fase 2 — Descoberta e detalhe do podcast ✅

- [x] `core/network/dio_client.dart`
- [x] `data/models/podcast.dart` e `episode.dart` (Freezed — sem JSON codegen; a tradução do JSON/XML bruto é manual dentro dos data sources, ver ARCHITECTURE.md)
- [x] `data/sources/itunes_search_api.dart`
- [x] `data/sources/rss_feed_parser.dart` (`rss_dart`, lendo `itunes:duration`, `itunes:image`, `enclosure`)
- [x] `data/repositories/podcast_repository.dart`
- [x] `DiscoverViewModel` com debounce de busca (400ms)
- [x] `PodcastDetailViewModel` (`AsyncNotifier.family` pelo próprio `Podcast`)
- [x] `PodcastDetailScreen` com `Hero` na capa vindo da lista
- [x] **Pronto quando:** busca real retorna podcasts e o detalhe lista episódios reais

Notas:

- Freezed 4 exige `abstract class Foo with _$Foo` (não mais `class Foo with _$Foo`)
  — sem o `abstract`, dá erro "Missing concrete implementations" no analyze.
- A iTunes Search API devolve `Content-Type: text/javascript`, não
  `application/json`. O parser automático do Dio (`Dio.get<Map<...>>`) não
  decodifica isso — vinha um `DioException`/`type 'String' is not a subtype
  of Map` silencioso. Corrigido pedindo `ResponseType.plain` e decodificando
  com `jsonDecode` na mão (ver `ItunesSearchApi.search`).
- Datas de `pubDate` do RSS são parseadas com `intl`'s `DateFormat('EEE, dd
  MMM yyyy HH:mm:ss Z', 'en_US')`; falha vira `null` (episódio sem data),
  não trava a tela.

## Fase 3 — Persistência local ✅

- [x] Schema drift: `Subscriptions`, `EpisodeCache`, `PlaybackProgress`, `Downloads`
      (`core/database/tables.dart` + `app_database.dart`)
- [x] `LibraryRepository` (só usa `SubscriptionRow`/`EpisodeCacheRow` — nunca
      vaza tipo do drift pra fora; devolve/recebe `Podcast`/`Episode`)
- [x] Assinar / desassinar, com cache dos episódios na assinatura
- [x] Biblioteca reativa (`LibraryViewModel`, `Stream` do drift → `StreamNotifier`)
- [x] Botão assinar/desassinar no detalhe do podcast (`isSubscribedProvider`,
      reativo entre telas — desassinar pela Biblioteca atualiza o detalhe sozinho)
- [x] **Pronto quando:** assinatura sobrevive ao fechar o app

Notas:

- `playback_progress` e `downloads` só têm o schema pronto — ninguém
  escreve neles ainda. Ficam pra Fase 4 (player) e Fase 5 (download).
  "Posição de escuta sobrevive ao restart" do critério original fica
  adiado pra Fase 4, quando existir um player que gere essa posição.
- Tabelas com FK em `Subscriptions.id` (`EpisodeCache`, `PlaybackProgress`,
  `Downloads`) usam `onDelete: KeyAction.cascade` — desassinar já limpa o
  cache de episódios sozinho, sem `DELETE` manual em cada tabela.
- Toda classe gerada pelo drift termina em `Row` (`SubscriptionRow`,
  `EpisodeCacheRow`) de propósito — sem isso, o nome gerado da tabela
  `EpisodeCache` colidiria com o modelo de domínio `Episode`.
- Coluna `id` de `Subscriptions` não é `autoIncrement()`, mas o
  `.insert()` gerado ainda trata como opcional (`Value.absent()` por
  padrão) — sempre passar `Value(podcast.id)` explícito.

## Fase 4 — Player

- [ ] `services/audio/podcast_audio_handler.dart` (`BaseAudioHandler` + `QueueHandler` + `SeekHandler`)
- [ ] Config Android: `AudioServiceActivity`, `<service>` e `<receiver>` no manifesto, permissões, `minSdk` ≥ 23, `launchMode="singleTop"`
- [ ] Mini-player sobre o bottom nav
- [ ] Full player com `Hero` na capa
- [ ] Velocidade 0.5×–3.0×
- [ ] Skip ±15s / ±30s
- [ ] Sleep timer (X min ou fim do episódio)
- [ ] Salvar progresso a cada ~5s
- [ ] **Pronto quando:** toca com a tela apagada e os controles aparecem na lockscreen

## Fase 5 — Download offline

- [ ] `services/download/download_service.dart` com `flutter_downloader`
- [ ] Fila e progresso persistidos em drift
- [ ] Player prefere o arquivo local quando existe
- [ ] Tela de downloads com uso de espaço e remoção
- [ ] Permissão `POST_NOTIFICATIONS` (Android 13+)
- [ ] **Pronto quando:** episódio baixado toca em modo avião

## Fase 6 — Polimento e testes

- [ ] Estados vazios e de erro ilustrados, com retry
- [ ] Shimmer em todo carregamento
- [ ] Testes unitários dos ViewModels e do parser de RSS (`mocktail`)
- [ ] Widget test do player
- [ ] Acessibilidade: contraste ≥ 4.5:1 no texto, semantics nos controles

## Fase 7 — iOS e evolução

- [ ] Instalar Xcode + CocoaPods
- [ ] `UIBackgroundModes: audio` no `Info.plist`
- [ ] Testar no simulador iOS
- [ ] `scripts/run_ios.sh`
- [ ] Backlog: OPML import/export, fila de reprodução, busca por categoria, sync entre aparelhos

---

## Dívidas técnicas conhecidas

| Item | Detalhe |
|---|---|
| `custom_lint` / `riverpod_lint` | Fora do `pubspec.yaml`: `custom_lint` 0.8.x fixa `analyzer ^8.0.0`, `drift_dev` 2.34.x exige `analyzer >=13.0.0`. Reincluir quando `custom_lint` subir o analyzer. |
| `webfeed_plus` | Descartado por fixar `intl ^0.19.0`, incompatível com `go_router` 18. Usamos `rss_dart`. |
| `sqlite3_flutter_libs` | Publicado como `0.6.0+eol`. Não declarar direto — `drift_flutter` resolve o sqlite nativo. |
| Android `cmdline-tools` | Ausente no SDK; `flutter doctor` reclama e as licenças ficam "unknown". Não bloqueou o build até agora. Se travar: instalar via Android Studio e rodar `flutter doctor --android-licenses`. |
| Xcode / CocoaPods | Ausentes. Build iOS só na Fase 7. |

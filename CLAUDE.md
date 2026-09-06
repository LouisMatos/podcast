# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

App de escuta de podcasts para Android e iOS. Monorepo com duas pastas de topo:

- `frontend/` — o app Flutter inteiro (única coisa que existe hoje).
- `backend/` — reservada para um servidor futuro (sync entre aparelhos, conta,
  recomendação). Vazia de propósito na v1: o app é local-only, sem login, sem
  sync, tudo em SQLite embutido via `drift`.

**Antes de qualquer trabalho, leia `docs/ROADMAP.md`** — é a fonte de verdade
do estado do projeto (fase atual, o que já foi feito, próximo passo concreto)
e deve ser atualizado ao fim de cada fase.

## Estilo de resposta

- Sempre em pt-BR.
- Respostas objetivas, claras, o mais curtas possível sem perder entendimento.
  Sem enrolação, sem repetir o que o código já diz, sem narrar passo a passo
  óbvio.
- Não reler/recolar arquivo inteiro já mostrado na conversa — referenciar por
  caminho e linha.
- Preferir Grep/Glob a varrer diretório inteiro; ler só o trecho necessário do
  arquivo, não o arquivo inteiro quando evitável.
- Ao explicar decisão técnica, uma frase de porquê basta — sem lista de
  alternativas descartadas a menos que perguntado.

## Mapa do repositório

Estado atual (Fase 6 concluída — ver `docs/ROADMAP.md` pra fase corrente):

```text
podcast/
  CLAUDE.md                  este arquivo
  docs/
    ROADMAP.md                estado do projeto, fase atual, dívidas técnicas
    ARCHITECTURE.md           contrato MVVM entre camadas
    DESIGN_SYSTEM.md          paleta, raios, sombras, regras de animação
  backend/
    README.md                  placeholder — nada implementado ainda
  frontend/                    projeto Flutter (único código do app)
    pubspec.yaml                dependências — ver seção abaixo
    analysis_options.yaml       lints; exclui *.g.dart e *.freezed.dart
    scripts/
      run_android.sh            build + emulador + run (ver Comandos)
      gen.sh                     atalho pro build_runner
    lib/
      main.dart                  async — inicializa AudioService e FlutterDownloader
                                  antes do runApp
      app.dart                   ProviderScope/MaterialApp.router
      core/                      theme/, router/ (+ /player e /settings/downloads
                                  fora/dentro das abas conforme o caso), network/,
                                  database/ (drift, schemaVersion 2), widgets/
      data/                      models/, sources/, repositories/ (Podcast, Library,
                                  Download)
      features/                  discover/, library/, podcast_detail/, settings/,
                                  player/ (mini-player + tela cheia), downloads/
                                  — layout completo descrito em "Arquitetura" abaixo
      services/audio/            PodcastAudioHandler (just_audio + audio_service)
      services/download/         DownloadService (flutter_downloader)
    test/                        25 testes — data/sources/, features/discover/,
                                  features/player/, widget_test.dart
    android/                     projeto nativo Android (manifests, gradle)
                                  MainActivity estende AudioServiceActivity (Fase 4)
    ios/                         projeto nativo iOS (build só na Fase 7)
```

Ao entrar em fase nova que cria pastas em `lib/` (`core/`, `data/`,
`features/`, `services/`), não é preciso atualizar este mapa a cada arquivo —
a árvore alvo já está descrita em "Arquitetura" logo abaixo. Só atualizar
aqui se a divisão de pastas de topo (`frontend/`, `backend/`, `docs/`) mudar.

## Comandos

Todos rodam de dentro de `frontend/`.

```bash
flutter pub get                 # resolver dependências
flutter analyze                 # lint/analyze — deve ficar sempre limpo
flutter test                    # todos os testes
flutter test test/caminho_test.dart                      # um arquivo
flutter test test/caminho_test.dart --plain-name "nome"  # um teste

dart run build_runner build --delete-conflicting-outputs  # codegen (uma vez)
./scripts/gen.sh watch          # codegen observando mudanças

./scripts/run_android.sh        # liga o AVD Pixel_6 se preciso, espera boot,
                                 # roda codegen se houver algo pra gerar, `flutter run`
```

`run_android.sh` aceita `AVD_NAME=` e `BOOT_TIMEOUT=` como variáveis de
ambiente, e repassa qualquer argumento extra pro `flutter run` (ex:
`./scripts/run_android.sh --release`).

Build iOS não funciona nesta máquina até instalar Xcode + CocoaPods (ver
Fase 7 no ROADMAP) — só o build Android é suportado por enquanto.

## Arquitetura — MVVM

```text
View  →  ViewModel  →  Repository  →  Source (API / RSS / SQLite)
```

A dependência só aponta pra baixo. Regras (detalhadas em `docs/ARCHITECTURE.md`):

- **View** (`lib/features/*/view/`): só widgets. Lê estado com
  `ref.watch(xViewModelProvider)`, dispara ações com
  `ref.read(xViewModelProvider.notifier).metodo()`. Nunca chama repositório
  ou API direto.
- **ViewModel** (`lib/features/*/view_model/`): um `Notifier<XState>` (ou
  `AsyncNotifier`) por tela, gerado com `@riverpod`. Estado imutável em
  Freezed (`isLoading` / `data` / `error`). **Nunca importa
  `package:flutter/material.dart`** — é isso que garante testar sem widget.
- **Model** (`lib/data/repositories/` + `lib/data/sources/`): repositórios
  expõem entidades de domínio e escondem se o dado veio da API, do RSS ou do
  SQLite local. Data sources (`ItunesSearchApi`, `RssFeedParser`, DAOs do
  drift) são burros e substituíveis, sem lógica de negócio.

Estrutura de pastas em `lib/`:

```text
core/theme/       tokens de design (cor, tipografia, raio, sombra, motion)
core/router/      go_router
core/network/     cliente Dio
core/database/    schema e DAOs do drift
core/widgets/     componentes compartilhados (SoftCard, PillButton, ...)
data/models/      Freezed + json_serializable
data/sources/     itunes_search_api, rss_feed_parser, DAOs
data/repositories/
features/<nome>/{view,view_model}/   uma pasta por tela
services/audio/   PodcastAudioHandler (audio_service + just_audio)
services/download/  DownloadService (flutter_downloader)
```

## Design system

Regra de ouro: **nenhum widget escreve cor, raio, sombra ou duração
literal** — tudo vem de `lib/core/theme/`. Detalhes completos (paleta pastel
exata, valores de raio/sombra, durações e curvas de animação permitidas) em
`docs/DESIGN_SYSTEM.md`. Resumo:

- Paleta pastel (lavanda/menta/pêssego), tons claro e escuro.
- Sem `Divider`/borda dura — separação por sombra suave.
- Tipografia Nunito via `google_fonts`.
- Animações lentas e suaves: `Curves.easeOutCubic`/`easeInOutCubicEmphasized`,
  nunca `Curves.linear` ou "bounce". Loading é shimmer, não spinner girando.

## Stack e armadilhas de dependência conhecidas

Ver `frontend/pubspec.yaml` para a lista completa (Riverpod 3 + Freezed para
estado/MVVM, go_router, dio + rss_dart para busca/RSS, drift para
persistência local, just_audio + audio_service para player em
background/lockscreen, flutter_downloader). Pontos que já causaram conflito
de versão e por quê (mais detalhes em "Dívidas técnicas" no ROADMAP):

- **`custom_lint`/`riverpod_lint` estão fora do projeto**: `custom_lint`
  0.8.x fixa `analyzer ^8.0.0`, `drift_dev` 2.34.x exige `analyzer
  >=13.0.0`. Não adicionar de volta sem checar essa compatibilidade primeiro.
- **Use `rss_dart`, não `webfeed_plus`**: `webfeed_plus` fixa `intl
  ^0.19.0`, incompatível com `go_router` 18.
- **Não declarar `sqlite3_flutter_libs` direto** — está publicado como
  `0.6.0+eol`. `drift_flutter` já resolve o sqlite nativo.
- Projeto requer Flutter stable atual (3.47.2+ / Dart 3.13.2+) — versões
  mais antigas não resolvem freezed 4 + riverpod_generator 4 + drift_dev
  2.34 juntos.
- **`StateProvider` não vem mais de `flutter_riverpod.dart`**: Riverpod 3
  moveu pra `package:flutter_riverpod/legacy.dart`. Preferir `Notifier`/
  `NotifierProvider` (ver `lib/features/settings/view_model/theme_mode_provider.dart`).
- **Freezed 4 exige `abstract class Foo with _$Foo`** — sem `abstract` dá
  erro "Missing concrete implementations" no analyze. Todo modelo Freezed
  do projeto segue esse padrão (`lib/data/models/`, estados de ViewModel).
- **A iTunes Search API devolve `Content-Type: text/javascript`**, não
  `application/json` — o parser automático do Dio (`Dio.get<Map<...>>`) não
  decodifica isso. `ItunesSearchApi` pede `ResponseType.plain` e decodifica
  com `jsonDecode` na mão; seguir esse padrão pra qualquer API nova que não
  declare `application/json` corretamente.
- **Toda classe gerada pelo drift (`core/database/tables.dart`) termina em
  `Row`** (`SubscriptionRow`, `EpisodeCacheRow`, ...) via `@DataClassName`.
  Não tirar esse sufixo — sem ele, uma tabela como `EpisodeCache` geraria a
  classe `Episode`, colidindo com o modelo de domínio `Episode` em
  `data/models/`. Repositórios (`LibraryRepository`) só devolvem/recebem os
  modelos de domínio, nunca essas `*Row`.
- **Coluna primária int sem `.autoIncrement()` ainda é opcional no
  `.insert()` gerado pelo drift** (`Value.absent()` por padrão) — para
  `Subscriptions.id` (o `collectionId` da iTunes, não autogerado), sempre
  passar `Value(podcast.id)` explícito, não o `int` cru.
- **`AsyncValue.valueOrNull` não existe no Riverpod 3.4.3** — `value` já é
  nullable (`ValueT? get value`). Usar `state.value`.
- **Testes que montam `PodcastApp`/`MiniPlayer` precisam sobrescrever
  `audioHandlerProvider`** (`overrideWithValue(PodcastAudioHandler())`) —
  sem isso o provider lança `UnimplementedError` e todo o widget tree
  quebra (aparece como "RenderFlex overflow" gigante, não como o erro
  real — ver `test/widget_test.dart`).
- **Navegar pro `/player` sem esperar `playEpisode` terminar**: dispara a
  Future sem `await` e chama `context.push` na sequência. Esperar primeiro
  deixa o toque no episódio parecendo sem resposta enquanto o áudio
  buffereia — a tela do player já mostra `isBuffering`.
- Emulador Android mata o `AudioService` por "app idle" depois de ~2m30s
  de tela apagada, mesmo com foreground service + notificação ativos —
  comportamento de energia do emulador, não bug do app (ver ROADMAP Fase 4).
- **`PodcastDetailViewModel` cai pro cache local (`LibraryRepository.
  cachedEpisodes`) se o fetch do RSS falhar** — é o que faz um episódio
  baixado continuar acessível em modo avião. Sem esse fallback a tela de
  detalhe trava no erro de rede antes de sequer mostrar a lista, mesmo
  com o episódio já baixado no disco. Qualquer novo fetch de rede numa
  tela que possa ter cache local deveria seguir esse padrão.
- **Botão de download só aparece com o podcast assinado**: `Downloads` e
  `EpisodeCache` têm FK em `Subscriptions.id` — baixar sem assinar não
  teria onde guardar o episódio.
- **`flutter_downloader` roda num isolate de background à parte** — a
  comunicação de volta pro isolate principal é `IsolateNameServer`/
  `ReceivePort` (não dá pra usar Riverpod ali dentro). O callback
  top-level (`downloadCallback` em `services/download/download_service.dart`)
  só repassa a mensagem; quem trata de verdade é `DownloadService`, do
  lado de cá.
- **`AppColors.onAccent`** é a cor certa pra texto/ícone sobre um
  preenchimento sólido de `primary`/`secondary` (ex: `PillButton`
  primário/secundário) — nunca `textPrimary` ali. `textPrimary` funciona
  em cima do `background`/`surface`, mas no tema escuro ele é claro, e
  claro sobre um pastel também claro não passa em contraste nenhum
  (medido: 2.5:1, WCAG pede 4.5:1 pra texto normal). Achado testando de
  verdade, não teórico — ver ROADMAP Fase 6.
- **Provider `autoDispose` em teste precisa de um listener permanente**:
  `container.listen(provider, (_, _) {})` no `setUp`. Sem isso, um
  `container.read(x.notifier)` sozinho não segura o provider vivo — ele é
  derrubado (e qualquer `Timer` interno, tipo o debounce do
  `DiscoverViewModel`, cancelado) antes do teste conseguir `await` o
  efeito. Ver `test/features/discover/discover_view_model_test.dart`.
- **Widget test de tela real precisa de `MaterialApp(theme:
  AppTheme.light(), ...)`** — sem isso `Theme.of(context).
  extension<AppColors>()!` estoura null-check (o `ThemeData()` default do
  Flutter não carrega nossa extensão).

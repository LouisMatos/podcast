# Roadmap de pendências — gap-analysis docs vs. implementação

> Consolidação de tudo que ficou pendente/aberto/contraditório em
> `docs/*.md` (roadmaps v1/v2/v3 + débito técnico + 9 docs extras não
> listados no índice) comparado com o estado real de `frontend/lib/`.
> Levantamento de 2026-09-15. Fora de escopo aqui: os 9 itens de
> `docs/roadmap_debito_tecnico.md` (rework grande/decisão de arquitetura,
> "não mexer sem pedir" por instrução do usuário) — ficam só registrados/
> atualizados, não implementados nesta roadmap.

## Onde parei

**Fase 1 concluída** (2026-09-15) — consolidação de documentação: `INDEX.md`
atualizado com os 9 docs que faltavam, nota stale de "falta mergear PR#1"
corrigida em `roadmap_cache_offline.md`/`roadmap_v3.md` (já resolvido via
PR#3), contradição `PLAY_STORE.md` vs `GUIA_APK_E_PLAYSTORE.md` resolvida
(textos de loja e testes de device já feitos, só Android Auto DHU
pendente), `roadmap_ponytail_perf.md` corrigido (Fases 1-4 estavam
commitadas, não "no working tree" como a nota antiga dizia), C1 de
`roadmap_qualidade_pre_launch.md` fechado (critério já satisfeito), 3
achados órfãos registrados em `roadmap_debito_tecnico.md` (Riverpod
`defaultRetry` mascarando erro de rede, Impeller desativado, tooltip
ausente no player).

**Fase 2 concluída** (2026-09-15) — 7 testes novos (`_toMediaItem`
duration/artUri, reconciliação de duração Fase 21, 4 testes de resolução
de deep link em `test/features/deeplink/view_model/` que não existia),
`dart analyze` limpo, `flutter test` 278/278, build debug instalado e
aberto no SM-G570M sem crash (MediaSession ativo). Schema test formal
`drift_dev` deixado registrado em `roadmap_debito_tecnico.md` como estava
— trabalho grande, sessão própria.

**Fase 3 concluída** (2026-09-15) — verificado no SM-G570M: digitação
normal e sob stress (backspace repetido) no campo de busca de Descobrir,
zero ocorrência de `InputConnectionWrapper`/`TimeoutException` no
`logcat`. Confirma a suspeita original: item 5 era ruído específico de
emulador, não reproduz em device físico. Sem mudança de código — só
verificação.

**Falta:** Fase 4 e 5, bloqueadas por hardware (device API 34+ novo /
Desktop Head Unit) — aguardando usuário arranjar o aparelho/DHU. AVRCP
Bluetooth real (item da Fase 20) segue bloqueado por falta de periférico
pareado, independente do device novo.

## Fase 1 — Consolidação de documentação ✅

- [x] `INDEX.md`: listar os 9 arquivos criados após 2026-09-08.
- [x] Corrigir nota stale "falta mergear com PR#1" em
      `roadmap_cache_offline.md` e `roadmap_v3.md` — já resolvido via PR#3
      (2026-09-14), `feat/fase-9` já em schema v8.
- [x] Resolver contradição `PLAY_STORE.md` vs `GUIA_APK_E_PLAYSTORE.md` —
      GUIA atualizado (textos de loja + testes de device marcados feitos,
      só Android Auto DHU genuinamente pendente).
- [x] `PLAY_STORE.md`: corrigir nota de ícone/splash — já resolvido na
      Fase 26a.
- [x] `roadmap_ponytail_perf.md`: confirmado via `git log`/`git branch
      --contains` que Fases 1-4 (`ab2bd82`) estão commitadas — nota
      "nada commitado" era stale. Fases 5-8 seguem indefinidas (decisão
      de produto: fechar aqui ou retomar — ver "Decisões em aberto"
      abaixo).
- [x] `roadmap_qualidade_pre_launch.md` C1: confirmado que critério já
      estava satisfeito (Fase B bloqueada por ambiente, linha de iOS em
      débito técnico mantida como está) — só faltava marcar `[x]`.
- [x] Registrados em `roadmap_debito_tecnico.md` (só registro, sem
      implementar): Riverpod `defaultRetry` mascarando erro de rede real
      (~40s+), Impeller desativado (`--no-enable-impeller`), tooltip/
      acessibilidade ausente em ícones do player.

## Fase 2 — v3 Fase 25: fechar lacunas de teste ✅

Sem bloqueio de hardware — trabalho de código puro. Precisa device físico
conectado só pro smoke test final.

- [x] Teste: `_toMediaItem` produz `duration`/`artUri` corretos
      (`test/features/player/player_view_model_test.dart`).
- [x] Teste: resolução de deep link — 4 testes novos em
      `test/features/deeplink/view_model/deep_link_resolution_test.dart`
      (pasta não existia).
- [x] Badge de não-ouvidos — já tinha cobertura da Fase 23 em
      `test/data/repositories/library_repository_test.dart` (linha 488),
      confirmado ao investigar, nenhuma ação necessária.
- [x] Teste: reconciliação de duração exibida (Fase 21) — 2 testes novos
      cobrindo divergência > 2s (corrige uma vez por guid) e ≤ 2s (não
      corrige).
- [x] Schema test formal `drift_dev` avaliado — não coube nesta fase
      (trabalho grande, precisa de sessão própria), mantido registrado em
      `roadmap_debito_tecnico.md` como já estava.
- [x] Fim de fase: `dart analyze` limpo, `flutter test` 278/278 verde,
      build debug + `adb install` no SM-G570M, app abre sem crash
      (MediaSession ativo, confirmado via `logcat`).

## Fase 3 — v3 Fase 20: fechar investigação de metadados de mídia ✅

- [x] Verificar item 5 do achado original: IME `InputConnectionWrapper`
      `TimeoutException` nos campos de busca — testado no SM-G570M
      (digitação normal + stress com backspace repetido na busca de
      Descobrir), zero ocorrência no `logcat`. Confirmado: ruído de
      emulador, não reproduz em device físico.
- [x] AVRCP Bluetooth real: continua bloqueado por falta de periférico
      pareado (fone/carro Bluetooth) — registrado como bloqueio
      independente do device novo, não fecha sozinho.
- [x] Fim de fase: sem mudança de código (só verificação), app já
      instalado no device físico nesta sessão (Fase 2), smoke test feito
      ao exercitar a busca.

## Fase 4 — v3 Fase 24: toolchain e SDK — BLOQUEADA

Aguarda device/AVD Android API 34+ (SM-G570M é API 26, insuficiente).
Usuário vai arranjar aparelho mais recente.

- [ ] Subir `compileSdk`/`targetSdk`; revalidar os 5 plugins com warning
      KGP (`file_picker`, `flutter_downloader`, `sensors_plus`,
      `share_plus`, `workmanager_android`); tentar `permission_handler
      ^13`.
- [ ] Rastrear upstream dos plugins pra Built-in Kotlin.
- [ ] Smoke test em device físico novo (API 34+).
- [ ] `flutter test` + `dart analyze` depois de cada bump.

## Fase 5 — v3 Fase 26c: Android Auto DHU — BLOQUEADA

Aguarda Desktop Head Unit ou carro real com Android Auto.

- [ ] Testar Android Auto real: conectar → listar mídia → tocar.

## Fora do roadmap (ações manuais, não código)

- Backup da keystore fora desta máquina (nuvem/HD externo) —
  `docs/PLAY_STORE.md`.
- Definir país-alvo e preço no Play Console — só no momento do envio.
- Submissão final: `flutter build appbundle --release` → criar app no Play
  Console → faixa de teste interno → preencher ficha da loja → revisar e
  enviar — `docs/GUIA_APK_E_PLAYSTORE.md`.

## Decisões em aberto (perguntar ao usuário quando chegar a hora)

- `roadmap_ponytail_perf.md`: fechar em Fase 1-4 (já commitadas) ou
  definir Fases 5-8 do plano original de otimização de APK/device fraco?
- Medir APK size pós Fase 1-4 do ponytail (não feito ainda).
- Verificação manual visual da fonte Nunito vendorizada (Fase 2 do
  ponytail, pendente).

## Regra de ouro (por fase)

- `dart analyze` limpo (roda `riverpod_lint`).
- `flutter test` verde — zero regressão nos testes das fases anteriores.
- Fim de fase de implementação (código, não só doc): build +
  `flutter install` no device físico conectado, smoke test manual das
  telas tocadas na fase.
- Atualizar "Onde parei" aqui a cada fase fechada.

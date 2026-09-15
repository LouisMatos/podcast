# Ponytail — otimização (APK size / low-end device)

Plano de sessão anterior perdido (scratchpad, não commitado). Recriado enxuto
pra rastrear fases já aplicadas no working tree (branch `feat/radio`, ainda
sem commit).

## Baseline (Sep 12, 8:46–8:48)
- `dart analyze`: limpo
- `flutter test`: 236/236
- Release APK: 72.9 MB

## Fase 0 — baseline
- [x] medido acima

## Fase 1 — dependências não usadas
- [x] Removido `audio_session` (não importado em lugar nenhum)
- [x] Removido `cupertino_icons` (não usado)
- [x] `flutter pub get` + `dart analyze` limpos, 236/236 testes

## Fase 2 — vendorizar fonte (sem fetch em runtime)
- [x] Baixado Nunito TTF (400/600/700) → `frontend/assets/fonts/`
- [x] `pubspec.yaml`: family `Nunito` declarada localmente
- [x] `app_typography.dart`: troca `GoogleFonts.nunitoTextTheme()` por
      `fontFamily: 'Nunito'` local
- [x] Removido `google_fonts` do pubspec
- [x] 236/236 testes passando
- [ ] Verificação manual visual pendente (rodar app, conferir fonte)

## Fase 3 — índices de banco (schema v7 → v8)
- [x] `idx_episode_cache_recent` em `(archived, published_at)` —
      `watchRecentEpisodes` cruza podcasts sem prefixo de PK
- [x] `idx_playback_progress_continue` em `(completed, updated_at)` —
      `watchContinueListening`
- [x] `idx_downloads_task_id` em `taskId` — lookup por evento do
      `flutter_downloader`
- [x] Migração v7→v8 em `app_database.dart` (`CREATE INDEX IF NOT EXISTS`)
- [x] `migration_chain_test.dart` cobre v2→v8 + índices presentes
- [x] `dart analyze` limpo, 236/236 testes

## Fase 4 — achados de sessão anterior aplicados
- [x] `memCacheWidth`/`memCacheHeight` (via `devicePixelRatioOf`) em todas as
      16 chamadas de `CachedNetworkImage` — imagem decodificada só no tamanho
      exibido, não no tamanho original da rede (Galaxy J5 Prime = pouca RAM)
- [x] `itunes_search_api.dart`: `jsonDecode`+mapeamento movidos pra
      `Isolate.run` em `search`/`searchEpisodes`/`lookup` (métodos auxiliares
      viraram `static` pra serem enviáveis ao isolate)
- [x] `apple_charts_api.dart`: mesmo tratamento em `topPodcastIds`
- [x] `dart analyze` limpo, 236/236 testes

## Pendente
- Fases 1-4 commitadas (`ab2bd82`, branch `feat/radio` → herdada em
  `feature/ui-review-fase28`, confirmado via `git log`/`git branch
  --contains` em 2026-09-15) — nota antiga de "nada commitado" ficou
  stale.
- Fase 5+ não definidas (plano original de 8 fases perdido). Ver
  `docs/roadmap_pendencias_implementacoes.md` pra decisão de fechar aqui ou
  retomar.
- Medir APK size pós Fase 1–4 (ainda não feito).
- Verificação manual visual da fonte Nunito vendorizada (Fase 2, pendente).

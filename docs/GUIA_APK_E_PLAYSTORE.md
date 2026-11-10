# Guia — Gerar APK de teste e publicar na Play Store

Guia prático pra quem vai (A) instalar o app num Android de teste sem passar
pela loja, e (B) saber exatamente o que falta pra publicar de verdade.

Também existe uma versão interativa: `docs/guia_apk_e_playstore.html` (abre
no navegador, checklist clicável que lembra o progresso).

Detalhes de assinatura, permissões e resposta de "segurança de dados" do
Play Console já estão documentados em `docs/PLAY_STORE.md` — este guia não
repete aquilo, só referencia.

---

## Parte A — Gerar APK pra instalar num Android de teste

### Pré-requisitos

- Flutter instalado e funcionando (`flutter doctor` sem erro vermelho).
- No aparelho Android: **Ativar opções do desenvolvedor** → **Depuração USB**
  ligada (pra instalar via `adb`) OU permitir **instalar de fontes
  desconhecidas** (pra instalar o `.apk` copiado direto pro aparelho).

### Passo a passo

```bash
cd frontend
flutter pub get
flutter build apk --release
```

O APK sai em:

```
frontend/build/app/outputs/flutter-apk/app-release.apk
```

Pra instalar, duas opções:

**Com o aparelho conectado por USB (mais rápido):**

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

**Sem `adb` — transferindo o arquivo:** copie o `.apk` pro celular (cabo,
Drive, WhatsApp Web etc.) e abra o arquivo no aparelho. Precisa ter
"instalar de fontes desconhecidas" liberado pro app usado pra abrir o
arquivo (Arquivos, Chrome, etc.).

**Alternativa direta, sem gerar arquivo manualmente:**

```bash
flutter install -d <device-id>
```

(`flutter devices` lista os IDs disponíveis.)

### E o emulador?

`./scripts/run_android.sh` sobe o AVD `Pixel_6` e roda o app — mas em modo
**debug**, pra desenvolvimento. É ótimo pra iterar, mas não gera um artefato
que dá pra distribuir pra outra pessoa testar. Pra isso, use o `flutter build
apk --release` acima mesmo mirando num emulador.

### Nota sobre assinatura

Se `frontend/android/key.properties` existir (ele existe, ver
`docs/PLAY_STORE.md`), o build `--release` já sai assinado com a keystore de
upload. Se não existisse, o Gradle cairia pro signing de debug — funciona
pra instalar e testar, mas não é o artefato que a Play Store aceita como
definitivo.

### Checklist — Parte A

- [ ] `flutter doctor` sem erro crítico
- [ ] Depuração USB ou fontes desconhecidas habilitada no aparelho de teste
- [ ] `flutter build apk --release` rodou sem erro
- [ ] APK instalado e app abre normalmente no aparelho
- [ ] Testou o fluxo principal (tocar um episódio, notificação, etc.) no
      aparelho físico — o emulador não cobre tudo (ver Parte B)

---

## Parte B — O que falta pra publicar na Play Store

### Já feito (não precisa re-checar, só contexto)

- Keystore de upload gerada e configurada (`key.properties` +
  `signingConfigs.release` no `build.gradle.kts`).
- Todas as permissões do `AndroidManifest.xml` documentadas e justificadas.
- Resposta de "Segurança dos dados" do Play Console já redigida (app não
  coleta nem compartilha dados).

### Falta fazer

**Keystore**

- [x] Trocar a senha placeholder `podcast-changeme` da keystore — feito
      2026-09-11 (senha em `~/podcast-keystore-secrets/`, detalhes em
      `docs/PLAY_STORE.md`)
- [x] Backup local em `~/podcast-keystore-secrets/`. Falta backup fora desta
      máquina (nuvem/HD externo) — ação manual pendente

**Versionamento**

- [x] `version: 1.0.0+1` revisado — mantido pra primeiro envio (sem release
      anterior pra incrementar contra)

**Arte** — feito 2026-09-11 (placeholder gerado, não é peça de design
profissional; trocar depois se houver arte melhor)

- [x] Ícone adaptativo gerado via `flutter_launcher_icons`
- [x] Splash screen customizado via `flutter_native_splash`
- [x] Ícone da loja 512×512 —
      `frontend/assets/branding/source/play_store_icon_512.png`
- [x] Feature graphic 1024×500 —
      `frontend/assets/branding/source/feature_graphic_1024x500.png`
- [x] Screenshots reais (emulador) em
      `frontend/assets/branding/screenshots/`: Início, Descobrir, detalhe de
      podcast/episódio, player cheio, Biblioteca

Fonte de toda a arte: `frontend/assets/branding/source/` (script de geração
não versionado, só os PNGs resultantes).

**Textos da loja**

- [x] Descrição curta (pt-BR) — texto pronto em `docs/PLAY_STORE.md`
- [x] Descrição longa (pt-BR) — texto pronto em `docs/PLAY_STORE.md`
- [x] Categoria: "Música e áudio"
- [x] Classificação indicativa: "Livre"

**Política de privacidade**

- [x] Hospedada via GitHub Pages:
      https://louismatos.github.io/podcast/privacy/
- [ ] Colar a URL no Play Console no momento do envio

**Branding**

- [x] `android:label` trocado pra `Ecoo` (era `podcast_app`)

**Teste em device real** (coisas que o emulador não exercita bem)

- [x] App shortcuts (atalhos de long-press no ícone) — validado SM-G570M, Fase 26c
- [x] Share (compartilhar episódio/podcast) — validado SM-G570M, Fase 26c
- [x] Deep link (`podcastapp://...` e `https://`) — validado SM-G570M, Fase 20/26c
- [x] Notificações de novo episódio + controle de mídia na tela de bloqueio — validado SM-G570M, Fase 20
- [ ] Android Auto (via DHU ou carro real) — segue bloqueado, sem hardware disponível (v3 Fase 26c)

**Build final e envio**

- [ ] `flutter build appbundle --release` (gera o `.aab` que a loja aceita)
- [ ] Criar/configurar o app no Play Console
- [ ] Subir primeiro numa faixa de **teste interno**, não direto pra
      produção
- [ ] Preencher ficha da loja + política de privacidade + data safety no
      Play Console
- [ ] Revisar e enviar pra análise

### Bloqueio técnico conhecido (não é checklist, é aviso)

`permission_handler` está preso em `^12.0.1` porque a versão `^13` exige
`compileSdk 37`, e o Flutter instalado atualmente só oferece `compileSdk 36`
por padrão. Isso **não bloqueia a publicação** — é dívida técnica que será
revisitada quando o Flutter subir a versão padrão de `compileSdk` (rastreado
como Fase 24 em `docs/roadmap_v3.md`).

---

## Referências

- `docs/PLAY_STORE.md` — detalhes de assinatura, permissões, data safety
- `docs/roadmap_v3.md` — Fase 24 (toolchain/SDK) e Fase 26 (arte/keystore/
  Android Auto em device real)

# Publicação na Play Store

Checklist pra submeter o Podcast App. Complementa o `docs/ROADMAP_V2.md` Fase 18.

## Assinatura (feito na Fase 18)

- Keystore de upload: `~/podcast-upload-keystore.jks` (FORA do repo), alias
  `upload`, validade 10000 dias.
- `frontend/android/key.properties` (gitignored) aponta pra ela.
  `key.properties.example` é o template versionado.
- **Senha placeholder trocada** (2026-09-11). Keystore é PKCS12 — `keytool
  -keypasswd` não é suportado nesse formato (store e key compartilham a
  mesma senha). Senha real fica em
  `~/podcast-keystore-secrets/keystore-password.txt` (fora do repo, `chmod
  600`), copiada em `frontend/android/key.properties`.
- `app/build.gradle.kts`: `signingConfigs.release` (lê `key.properties`),
  `isMinifyEnabled` + `isShrinkResources` + `proguard-rules.pro`.
- Guardar o SHA-256 do certificado de upload (Play App Signing usa outro pra
  produção; este é só o de upload).
- **Backup da keystore**: cópia em `~/podcast-keystore-secrets/` (fora do
  repo). Falta ainda um backup fora desta máquina (nuvem/HD externo) —
  perder = não conseguir atualizar o app.

## Build de release

```bash
cd frontend
flutter build appbundle --release   # gera build/app/outputs/bundle/release/app-release.aab
```

Bump antes de cada envio (em `frontend/pubspec.yaml`, campo `version`):
`1.0.0+1` → `versionName+versionCode`. O `versionCode` (número depois do `+`)
tem que subir sempre.

## Declaração de dados (Data safety) na Play Console

Resposta curta: **o app não coleta nem compartilha nenhum dado**.

| Pergunta da Console | Resposta |
| --- | --- |
| O app coleta ou compartilha dados do usuário? | **Não** |
| Dados criptografados em trânsito | N/A (nada é enviado a nós) |
| Usuário pode pedir exclusão | N/A (nada sai do aparelho; desinstalar apaga tudo) |

Requisições de rede são só pra APIs públicas da Apple (busca), feeds RSS e
CDNs de áudio/imagem dos podcasts — direto do device, sem intermediário e sem
identificadores. Isso não é "coleta" pelos critérios da Play.

## Permissões — justificativa

| Permissão | Por quê |
| --- | --- |
| `INTERNET` | Buscar e baixar podcasts, feeds e capas. |
| `POST_NOTIFICATIONS` | Notificação de reprodução (controles) + aviso de episódio novo. |
| `RECEIVE_BOOT_COMPLETED` | Reagendar o refresh em segundo plano após reboot. |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Prompt opcional pra não pausar download/refresh em background. |
| `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_MEDIA_PLAYBACK` | Player em background (audio_service). |
| `WAKE_LOCK` | Manter o áudio tocando com a tela apagada. |

`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` exige o formulário de "Permissões
sensíveis" na Console — justificar como "app de mídia com reprodução e
download em segundo plano".

## Política de privacidade

`docs/privacy/index.html` — página estática. Hospedar (GitHub Pages:
`https://<user>.github.io/<repo>/privacy/`) e colar a URL na Console.
**Definir a URL final e referenciar aqui.**

## Ficha da loja

- [x] Ícone 512×512, feature graphic 1024×500 — `frontend/assets/branding/source/`.
- [x] Screenshots (telefone) — `frontend/assets/branding/screenshots/`.
- [x] Descrição curta + longa (pt-BR) — abaixo.
- [x] Categoria: Música e áudio. Classificação etária: Livre.
- [ ] País-alvo, preço (grátis) — definir no Play Console no momento do envio.

### Descrição curta (máx. 80 caracteres)

```
Ouça e organize seus podcasts offline, sem conta e sem anúncios.
```

### Descrição longa

```
Ecoo é um app de podcasts simples e direto: assine, baixe e ouça — sem
criar conta, sem anúncios e sem rastreamento.

DESCUBRA E ASSINE
Busque por nome ou categoria, veja os mais ouvidos no Brasil e assine
qualquer feed RSS público, incluindo os que não estão nos catálogos
tradicionais.

OUÇA DO SEU JEITO
Player completo com velocidade ajustável, equalizador, realce de volume,
timer para dormir e capítulos do episódio quando disponíveis. Controles
também na tela de bloqueio, no fone Bluetooth e no Android Auto.

BAIXE PARA OUVIR OFFLINE
Baixe episódios para ouvir sem internet — útil em viagem, no metrô ou em
qualquer lugar com sinal ruim.

NUNCA PERCA O LUGAR
Fila de reprodução, histórico de escuta e estatísticas de tempo ouvido
por dia. Continue de onde parou em qualquer episódio.

PRIVACIDADE DE VERDADE
Sem login, sem sincronização com servidor, sem coleta de dados. Tudo fica
salvo só no seu aparelho — desinstalar o app apaga tudo.

Importe e exporte suas assinaturas via OPML a qualquer momento.
```

## Pendências de asset (Fase 18 não fecha)

- Ícone e splash finais dependem de arte — hoje é o ícone default do Flutter.
  Quando houver o PNG fonte: `flutter_launcher_icons` + `flutter_native_splash`.

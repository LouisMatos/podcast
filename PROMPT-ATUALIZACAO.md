# Atualizar o projeto base: Painel de testes + FlatLaf + Ambiente por alvo

> **Como usar:** abra o Claude Code na pasta do projeto que foi criado com a versão anterior do `PROMPT-UNICO.md` e cole **este arquivo inteiro** como mensagem. Numa máquina nova, ajuste o caminho do PROMPT-UNICO abaixo ou cole o PROMPT-UNICO junto.

---

Este projeto foi criado com uma versão anterior do prompt único. A especificação atualizada está em
`/Users/luismatos/Documents/prod_luis/prompt/PROMPT-UNICO.md`. Implemente **só a diferença** descrita abaixo,
usando aquele arquivo como contrato. Fale comigo em pt-BR.

## Antes de qualquer ação

1. Leia **inteiros** no PROMPT-UNICO.md:
   - Anexo 02, grupo **H** (lições 54–63) e a lição 49 reescrita;
   - Anexo 03 (tabela de arquivos e fluxo "Pelo Painel");
   - Anexo 04: **G2** e **G9**;
   - Anexo 06: pom (`flatlaf.version`, `exec.mainClass`, dependência `flatlaf`, `mainClass=${exec.mainClass}`) e `mapeador.tema`;
   - Anexo 07: `Config`, `DriverFactory`, `Ambiente`, `RelatorioAllure`;
   - Anexo 09: seção **Visual (FlatLaf)**, janela principal e Espelho;
   - Anexo 10: `AmbienteTest` e `PainelTestesTest`;
   - Anexo 11: CLAUDE.md, README, `docs/features/painel-testes.md`, índice do `docs/README.md`, `standards/architecture.md`;
   - **Anexo 13 inteiro** (spec do Painel).
2. Rode `mvn -q -DskipTests test-compile` e `mvn -q test -Dtest='InspetorTest,MapeadorElementosTest'` para provar que o ponto de partida está verde (17 + 14). Se não estiver, pare e me mostre.
3. Compare o código atual com a spec e me mostre, numa lista curta, o que vai mudar por arquivo. **Espere meu ok.**

## Regras duras

- A spec é o contrato: nomes, assinaturas, mensagens de console/erro e literais (regex, `FlatLaf.style`, placeholder, textos da tela) **exatamente** como no PROMPT-UNICO.md. Nada além do que a spec pede.
- Não mexa no que não está na lista abaixo (suíte, screens, steps, `Inspetor`, `Evidencias`, `Hooks`, `ResumoMarkdown`, `RodarPorTag`), a não ser que o gate falhe por causa da mudança.
- Fronteiras do Anexo 03 continuam valendo: `tools` não importa Appium/Selenium; driver só no `ThreadLocal`.
- Versão pinada: FlatLaf `3.8`. Nada de "última versão".
- Cada etapa termina no gate dela. Falhou: procure o sintoma no Anexo 02 primeiro, corrija a causa raiz, rode de novo. Duas tentativas sem passar: pare e me mostre o erro exato.
- Java 25 em todo shell que roda Maven: `export JAVA_HOME="$(brew --prefix openjdk@25)/libexec/openjdk.jdk/Contents/Home"; export PATH="$JAVA_HOME/bin:$PATH"; export ANDROID_HOME=$HOME/Library/Android/sdk`.

## Etapas

### U1 — Build e config (gate G1)
- `pom.xml`: properties `flatlaf.version` e `exec.mainClass`; dependência `com.formdev:flatlaf` (test); `exec-maven-plugin` com `mainClass=${exec.mainClass}`.
- `config/android.properties` e `config/ios.properties`: `mapeador.tema=auto` com o comentário da spec.
- G1: `mvn -q -DskipTests test-compile`.

### U2 — Mapeador com FlatLaf (gates G1, G2, G7)
- `tools/MapeadorElementos`: `tema()`, `macEscuro()` e `destacar()` package-private; `main` chama `tema()` antes do `invokeLater`; barra em `JPanel` + `FlowLayout` (nada de `JToolBar`); status bar com borda; larguras das colunas; placeholder e `destacar(testar)` no Espelho; cor do resultado do Testar.
- G1, G2 (só `InspetorTest` + `MapeadorElementosTest`: 17 + 14). Depois `mvn -q test-compile exec:java` e me guie no G7 (inclui tema claro/escuro e `-Dmapeador.tema=escuro`), pedindo confirmação visual.

### U3 — core (gates G1, G2)
- `Config`: cache por plataforma (`Map<String, Properties>` + `computeIfAbsent`).
- `DriverFactory`: `udid` → `setUdid` nas duas plataformas.
- `Ambiente`:
  - `enum Alvo` + `atual()`;
  - `appiumNoAr()`, `devices(Alvo)`, `diagnostico(Alvo)`;
  - `filtrarAdb`/`filtrarSimctl`/`filtrarXctrace`/`explicar`/`rodar`;
  - `garantirNoAr()` e `garantirDevice()` novos;
  - `exigirDevice()`/`deviceOnline()` ficam como estão.
- `RelatorioAllure`: `limparResultados()`/`gerar()` `public static`; listener vira no-op com `relatorio.manual`.
- `core/AmbienteTest` com os 5 casos do Anexo 10.
- G1 e `mvn -q test -Dtest='InspetorTest,MapeadorElementosTest,AmbienteTest'` (17 + 14 + 5).

### U4 — Painel de testes (gates G1, G2, G3, G9)
- `tools/PainelTestes` conforme Anexo 13, inteiro.
- `tools/PainelTestesTest` com os 3 casos do Anexo 10. As contagens do `descobreOsCenariosDeFeatures` são as **deste projeto**: se ele já tem features além da de fábrica, ajuste os números ao que o `descobrir()` acha e me diga quais.
- G1, G2 completo (`-Dtest='InspetorTest,MapeadorElementosTest,AmbienteTest,PainelTestesTest'`: 17 + 14 + 5 + 3) e G3 (dry-run segue descobrindo os cenários).
- Me guie no **G9** inteiro, pedindo confirmação visual a cada passo (você não enxerga a janela). Na parte de reexecução, crie a feature temporária, rode, **apague** e recompile.

### U5 — Regressão (gates G4, G6)
- G4: `mvn test -Dcucumber.filter.tags="@smoke"` verde (o `RelatorioAllure` sem `relatorio.manual` continua limpando e gerando sozinho; `historico-allure.jsonl` ganha **uma** linha).
- G6: ▶ do `RodarPorTag` com tudo desligado sobe emulador e Appium e agora imprime também `[ambiente] Android emulador · udid=emulator-5554`.

### U6 — Documentação (rotina obrigatória do CLAUDE.md)
- `CLAUDE.md`:
  - comandos do Painel e dos testes novos;
  - parágrafo do Painel;
  - pegadinhas do grupo H;
  - trocar "Config carrega uma vez" pela regra do cache por plataforma;
  - remover qualquer "não use `-Dexec.mainClass`".
- `README.md`: seção **Painel de testes**.
- `docs/features/painel-testes.md` (seções e pendências do Anexo 11); `docs/features/mapeador-elementos.md` ganha a seção de visual; `docs/README.md`: linha nova no índice.
- `standards/architecture.md`: linha `tools` com Launcher API e FlatLaf; regra do estático cita o cache do `Config`. Sem ADR novo.
- `plans/`: próximo número livre, `NNNN-painel-testes-flatlaf.md`, com o plano desta atualização e status `implementado` + data; linha no `plans/README.md`.

## Formato de cada resposta

```
Etapa Ux — <nome>
Feito: <arquivos criados/alterados>
Gate: <comando>
Resultado: <trecho decisivo da saída>  ✔ | ✘
Próximo: <etapa seguinte ou o que preciso fazer>
```

Ao final:
- gates aprovados (G1, G2 com 39 verdes, G3, G4, G6, G7, G9);
- pendências conhecidas: iOS sem Xcode; iOS físico precisa de assinatura do WDA; reexecução que passa (Erro→Sucesso) só confirmada com uma falha intermitente real;
- os 4 comandos do dia a dia.

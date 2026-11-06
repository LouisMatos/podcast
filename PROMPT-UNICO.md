# Prompt único — Criar o projeto base de automação mobile do zero

> **Como usar:** abra o Claude Code numa pasta qualquer do Mac novo e cole **este arquivo inteiro** como primeira mensagem. Não precisa de mais nada.

---

Você vai criar, do zero nesta máquina, o **projeto base de automação mobile** do time: Java 25 + Appium 3 + Cucumber 8 + Allure 3, um código de teste para Android (UiAutomator2) e iOS (XCUITest), com: suíte Cucumber em pt-BR, runner pelo ▶ do VSCode que sobe emulador e Appium sozinho, relatório Allure 3 em HTML único com screenshot por step e vídeo, e o Mapeador de Elementos (janela Swing que espelha o emulador e gera locators). Fale comigo em pt-BR.

Não existe código de referência: você escreve tudo a partir da **especificação** abaixo, que foi extraída de um projeto que já funciona (compila, 31 testes offline verdes, smoke e relatório validados no emulador). Todo o material está **neste próprio prompt**, em anexos no final:

| Ref | Conteúdo |
|---|---|
| **Anexo 01** | Preparação da máquina |
| **Anexo 02** | 53 erros reais já vividos: sintoma → causa → regra |
| **Anexo 03** | Arquitetura: camadas, regras, papel de cada arquivo, fluxo de execução |
| **Anexo 04** | Gates G0–G8 com comando e resultado esperado |
| **Anexo 05** | Apontar para o app do time e escrever o primeiro teste |
| **Anexo 06** | Spec de build: estrutura, `pom.xml`, configs, fixture |
| **Anexo 07** | Spec da camada `core` |
| **Anexo 08** | Spec dos runners, `BaseScreen` e suíte de fábrica |
| **Anexo 09** | Spec do Mapeador (`Inspetor` + `MapeadorElementos`) |
| **Anexo 10** | Spec dos testes offline (17 + 14 casos) |
| **Anexo 11** | Spec da documentação, padrões e ADRs do projeto |
| **Anexo 12** | Padrões de uma suíte real (gabarito de estilo) |
| **Anexo SH** | Script `verificar-maquina.sh` |

## Antes de qualquer ação

1. Leia **inteiros**: **Anexo 03**, **Anexo 02**, **Anexo 04** e depois **Anexo 06** a **Anexo 11**. Não pule: a maior parte das falhas possíveis já está catalogada em **Anexo 02**.
2. Me pergunte, numa única pergunta com opções, e **espere a resposta**:
   - pasta do projeto novo (sugira `~/Documents/mobile/automacao`); se existir e não estiver vazia, pare e me mostre o conteúdo;
   - nome do AVD Android (rode `~/Library/Android/sdk/emulator/emulator -list-avds` e ofereça os existentes);
   - app alvo: Settings do Android (default, recomendado para validar o pipeline) ou package/activity do app do time;
   - se quero `git init` + commit inicial no fim.

## Regras duras (valem a sessão inteira)

- **A spec é o contrato.** Nomes de pacote, classe, método, constante, chave de config, mensagem de console e de erro **exatamente** como escritos. Onde a spec dá um fragmento literal (import, comando de processo, regex), use-o literalmente. Onde a spec descreve comportamento, implemente exatamente aquele comportamento — nem mais, nem menos. Nada de classe, interface, dependência ou config que a spec não peça.
- **Versões pinadas e imutáveis** (**Anexo 06**). Não "atualize para a última".
- **Nunca**: `PageFactory` do Selenium (é `io.appium.java_client.support.PageFactory`); `cucumber.glue` apontando para `...steps`; remover Jackson; adapter Allure oficial; `allure generate` à mão; `exec:java` sem `test-compile`; `exec:java -Dexec.mainClass=...` (o `mainClass` fixo do pom ganha e abre o Mapeador); `Thread.sleep` em steps/screens (o polling de processo do `Ambiente` em `core` usa `Thread.sleep` de propósito); implicit wait; `ProcessBuilder("appium")` cru.
- **Fronteiras de camada** (**Anexo 03**): só `core` importa Appium/Selenium; step não toca driver; screen não expõe locator; um Page Object para as duas plataformas; driver só no `ThreadLocal` do `DriverManager` (exceção: `Inspetor`).
- **Estilo**: Java 25 idiomático (records, `switch` expressão, pattern matching de `instanceof`, `var` não), classes utilitárias `final` com construtor privado, Javadoc de uma linha por classe, comentário só para o "por quê" não óbvio, mensagens em pt-BR.
- **Gate obrigatório.** Cada fase termina rodando o gate de **Anexo 04**. Só avance com o resultado esperado. Se falhar: procure o sintoma em **Anexo 02** primeiro, corrija a causa raiz, rode o gate de novo. Se em 2 tentativas não passar, pare e me mostre o erro exato.
- **Não instale nada sem me avisar.** Comandos de instalação (brew, npm -g, Android Studio, Xcode) você mostra e eu confirmo.
- Fora de escopo: CI, execução paralela, cloud, massa externa.
- Java 25 em todo shell que roda Maven: `export JAVA_HOME="$(brew --prefix openjdk@25)/libexec/openjdk.jdk/Contents/Home"; export PATH="$JAVA_HOME/bin:$PATH"; export ANDROID_HOME=$HOME/Library/Android/sdk`.

## Fases

### F0 — Máquina (gate G0)
Grave o script de **Anexo SH** (numa pasta temporária, não no projeto) e rode `zsh verificar-maquina.sh <avd>`. Para cada ✘, mostre o passo de **Anexo 01** e espere eu executar/autorizar. Atenção: JDK 25 via `JAVA_HOME`; **nvm carregado no `~/.zshrc`** (o Java sobe `appium` e `npx` via `/bin/zsh -ic`); `ANDROID_HOME` no `~/.zshrc`; AVD com o nome exato e a imagem validada (API 31, Google APIs).

### F1 — Esqueleto e build (gate G1)
Crie a estrutura de pastas, `pom.xml`, `allurerc.json`, `.gitignore`, `.vscode/settings.json`, `config/*.properties` (com o AVD e o app que escolhi), `src/test/resources/junit-platform.properties` e `allure.properties` conforme **Anexo 06**. Rode G1 (a 1ª vez baixa dependências).

### F2 — core sem o Inspetor (gate G1)
`Config`, `DriverManager`, `DriverFactory`, `Evidencias`, `Hooks`, `Ambiente`, `RelatorioAllure`, `ResumoMarkdown` conforme **Anexo 07**. G1.

### F3 — runners, BaseScreen e suíte de fábrica (gates G1, G3)
`RunCucumberTest`, `RodarPorTag`, `BaseScreen`, `AjustesScreen`, `AjustesSteps`, `ajustes.feature` conforme **Anexo 08**. G1 e G3 (dry-run descobre `Abrir a tela de Ajustes`, sem steps `undefined`).

### F4 — Suíte real e relatório (gates G4, G5)
Me peça para subir `appium` numa aba (com `ANDROID_HOME`) e o emulador, ou suba você em background do jeito de **Anexo 01**. Rode `mvn test -Dcucumber.filter.tags="@smoke"` contra o **Settings** (se o config já aponta pro app do time, valide primeiro com `-DappPackage=com.android.settings -DappActivity=.Settings`). Confira o relatório (G5): HTML único, screenshot por step, vídeo em Desmontagem, `resumo.md`, `historico-allure.jsonl`.

### F5 — Mapeador e testes offline (gates G2, G7)
1. Com emulador + Appium no ar e o Settings na tela inicial, gere a fixture `src/test/resources/fixtures/settings-android.xml` com os comandos de **Anexo 06** e confira o que **Anexo 06** pede que ela contenha.
2. `core/Inspetor` e `tools/MapeadorElementos` conforme **Anexo 09**; o `exec-maven-plugin` já está no pom.
3. `core/InspetorTest` e `tools/MapeadorElementosTest` com **todos** os casos de **Anexo 10** (mesmos nomes de método).
4. G2 (17 + 14 verdes; o `[Fatal Error] ... DOCTYPE` é esperado). Depois `mvn -q test-compile exec:java` e me guie no roteiro de G7, pedindo confirmação visual (você não enxerga a janela).

### F6 — ▶ do VSCode (gate G6)
Me guie: abrir o projeto no VSCode, extensão Java com runtime 25, fechar emulador e matar o Appium (`lsof -ti tcp:4723 | xargs kill`), abrir `RodarPorTag.java`, clicar **Run**. Me peça para colar o console e compare com G6.

### F7 — Primeiro teste do app do time (gate G8) — só se escolhi app do time
Siga **Anexo 05** de ponta a ponta, com os padrões de **Anexo 12**. Ao tornar o app do time o default, troque a tag do `ajustes.feature` para só `@ajustes`.

### F8 — Documentação e entrega
Escreva `CLAUDE.md`, `README.md`, `standards/` (README, architecture, code-style, ADRs 0001–0004), `docs/` (README com template e índice, `features/ajustes.md`, `features/evidencias.md`, `features/mapeador-elementos.md`, `padroes-suite-real.md`, `mapeamento/.gitkeep`), `plans/README.md` e `plans/0001-setup-inicial.md` conforme **Anexo 11** — a seção **Rotina obrigatória de documentação** do `CLAUDE.md` vai com o texto exato. Se houve F7: doc da feature nova + linha nos índices + plano. Se pedi git: `git init`, conferir `.gitignore`, commit `chore: projeto base de automação mobile`.

## Formato de cada resposta de fase

```
Fase Fx — <nome>
Feito: <arquivos criados/alterados>
Gate: <comando>
Resultado: <trecho decisivo da saída>  ✔ | ✘
Próximo: <fase seguinte ou o que preciso fazer>
```

Ao final: caminho do projeto, gates aprovados, pendências (ex.: iOS sem Xcode) e os 3 comandos do dia a dia (`▶ RodarPorTag`, `mvn test -Dcucumber.filter.tags="@smoke"`, `mvn -q test-compile exec:java`).


---

# ANEXOS


## Anexo 01

## 01 — Preparar a máquina

Fazer **uma vez por máquina**, na ordem. No fim, `zsh verificar-maquina.sh` tem que terminar em `Máquina pronta.`

> O projeto base é **macOS only**: `core.Ambiente` usa `/bin/zsh -ic` e `lsof` para subir/derrubar o Appium.

### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Java 25 + Maven

```bash
brew install openjdk@25 maven
```

**Não** troque o Java padrão do sistema. Selecione o 25 só para o projeto, colocando no `~/.zshrc`:

```bash
export JAVA_HOME="$(brew --prefix openjdk@25)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
```

Confira: `mvn -v` precisa mostrar `Java version: 25`.

No VSCode, instale o **Extension Pack for Java** e aponte o JDK 25 (`Java: Configure Java Runtime`), senão o ▶ do `RodarPorTag` usa outro JDK e não compila (`release 25` não suportado).

### 3. Node 20.19+ via nvm (carregado no `~/.zshrc`)

```bash
brew install nvm
mkdir -p ~/.nvm
```

Adicione ao `~/.zshrc` (é **obrigatório** estar no `.zshrc`: o Java sobe o Appium e o Allure via `/bin/zsh -ic`, que só lê o `.zshrc`):

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"
```

```bash
source ~/.zshrc
nvm install 20
nvm alias default 20
node -v          # v20.19.0 ou maior — Appium 3 exige ^20.19.0
```

### 4. Appium 3 + driver Android

```bash
npm i -g appium@3.9.0
appium driver install uiautomator2
appium driver list --installed     # uiautomator2 [installed]
```

Não suba o Appium com `--allow-insecure=session_discovery`: no Appium 3 o formato válido é `--allow-insecure=*:session_discovery`, e o errado derruba o server na partida. O projeto não precisa de flag nenhuma.

### 5. Android SDK + emulador

1. Instale o **Android Studio** (`brew install --cask android-studio`) e abra uma vez para baixar o SDK em `~/Library/Android/sdk`.
2. `SDK Manager` → marque **Android SDK Platform-Tools** e **Android Emulator**.
3. `Device Manager` → crie um AVD com a **imagem validada**: **Pixel 6**, **Android 12 (API 31), Google APIs, arm64-v8a** (`system-images;android-31;google_apis;arm64-v8a`), nome **`Pixel_6`** (default do `config/android.properties`; outro nome = ajustar `deviceName`). Mac Intel: mesma API 31 com `x86_64`.
   **Use essa imagem.** O smoke de fábrica valida o Settings do Android pelo `resource-id` `com.android.settings:id/search_action_bar_title`, que muda entre versões: com outra API o gate G4 pode falhar só por locator (ver lição 53).
4. No `~/.zshrc`:

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
```

`ANDROID_HOME` tem que estar no shell **que sobe o `appium`**. Sem ele o Appium responde 500:
`Neither ANDROID_HOME nor ANDROID_SDK_ROOT environment variable was exported`.

`adb` e `emulator` **não** entram no PATH — o projeto chama pelo caminho completo do SDK. Use assim também:

```bash
~/Library/Android/sdk/emulator/emulator -list-avds
~/Library/Android/sdk/platform-tools/adb devices
```

### 6. Maven atrás de proxy/Nexus corporativo

Todas as dependências vêm do **Maven Central**, inclusive o adapter `io.github.shafthq:allure-cucumber8-jvm:10.4.20261102` (validado com cache `~/.m2` vazio). Se a empresa usa mirror/Nexus em `~/.m2/settings.xml`, ele precisa fazer proxy do Central; senão G1 falha resolvendo esse adapter.

### 7. iOS (opcional)

Só **Command Line Tools não basta** (`tool 'xcodebuild' requires Xcode`). Precisa do Xcode completo:

```bash
# App Store → Xcode, abrir uma vez e aceitar a licença
sudo xcode-select -s /Applications/Xcode.app
appium driver install xcuitest
xcrun simctl list devices available     # escolher deviceName/platformVersion pro config/ios.properties
```

### 8. Conferir

```bash
zsh verificar-maquina.sh            # ou: zsh verificar-maquina.sh <nome-do-seu-avd>
```

✘ é obrigatório; ! é aviso (iOS ou conveniência).


## Anexo 02

## 02 — Lições aprendidas (erros que já custaram tempo)

Cada item: **sintoma** → causa → **regra que a spec impõe** (o "→"). As specs 06–10 já foram escritas respeitando tudo isto; esta lista existe para quem implementa não "simplificar" e reabrir o erro. Diante de qualquer falha, procure o sintoma aqui **antes** de mudar código.

### A. Build e dependências

1. **`PageFactory.initElements` não aceita `AppiumFieldDecorator`** (erro de compilação).
   Desde o java-client 11 o decorator implementa a interface do Appium.
   → `BaseScreen` importa `io.appium.java_client.support.PageFactory`, **não** o do Selenium.
2. **Criação de sessão falha em runtime** com erro de JSON.
   Selenium 4.5x delega JSON ao Jackson e não o traz transitivo.
   → `pom.xml` declara `jackson-databind` + `jackson-datatype-jdk8` 2.22.4 à mão. Não remover.
3. **Selenium resolve versão diferente em cada máquina.**
   java-client declara range `[4.50.0,5.0)`.
   → `selenium-java` pinado em 4.52.0.
4. **Nenhum driver é criado, steps rodam sem app.**
   `cucumber.glue` apontando pra `...steps` deixa o `Hooks` (em `core`) de fora.
   → `cucumber.glue=br.com.automacao` (raiz) em `junit-platform.properties`.
5. **Warning de descoberta do JUnit Platform 6.**
   `@SelectClasspathResource("features")`.
   → `RunCucumberTest` usa `@SelectPackages("features")`.
6. **`Funcionalidade:` não é reconhecido.**
   Falta o cabeçalho de idioma.
   → `# language: pt` na **primeira linha** de todo `.feature`.
7. **`NoSuchMethodError` ao gerar Allure.**
   O oficial `allure-cucumber7-jvm` quebra no Cucumber 8 (`Location.getLine()` mudou `Long`→`int`).
   → `io.github.shafthq:allure-cucumber8-jvm:10.4.20261102` (PR allure-java#1455, está no Maven Central).
8. **`NoClassDefFoundError` de classes do Allure.**
   O jar do adapter shafthq **não declara dependências** e foi compilado contra o Allure Java 3 (`AttachmentOptions`).
   → `allure-java-commons:3.0.1` declarado à mão. Não usar 2.x.
9. **Resultados de runs antigas aparecem no relatório.**
   Allure Java 3 não limpa mais `target/allure-results`.
   → `RelatorioAllure` zera a pasta no `TestRunStarted`.
10. **`exec:java` roda classe velha ou `ClassNotFoundException`.**
    `exec:java` não compila.
    → Sempre `mvn -q test-compile exec:java`.
11. **`InspetorTest`/`MapeadorElementosTest` não rodam no `mvn test`.**
    Surefire só inclui `**/Run*Test.java` (de propósito: a suíte real precisa de device).
    → Rodar com `-Dtest=InspetorTest` (o `-Dtest` sobrepõe o include).
12. **Sessão do Mapeador morre enquanto você navega.**
    `newCommandTimeout` vem de `waitSeconds` (20 s).
    → `exec-maven-plugin` passa `waitSeconds=600` só pro Mapeador.
13. **Mudar a versão do Cucumber** quebra o adapter Allure (item 7). Não mude sem revisar o ADR 0004.

### B. Ambiente (Appium 3, nvm, SDK)

14. **Appium 500: `Neither ANDROID_HOME nor ANDROID_SDK_ROOT environment variable was exported`.**
    A variável tem que estar no shell **que sobe o appium**, não no do Maven.
    → `~/.zshrc` exporta; `Ambiente.garantirAppium()` também injeta `ANDROID_HOME`/`ANDROID_SDK_ROOT` no processo filho.
15. **Appium 3 morre na partida, nada escuta na 4723.**
    `--allow-insecure=session_discovery` é inválido no Appium 3.
    → Projeto sobe `appium` sem flag. Se precisar: `--allow-insecure=*:session_discovery`.
16. **`GET /sessions` não existe.**
    No Appium 3 virou `GET /appium/sessions` (e exige a flag acima).
    → O projeto não lista sessões: o Mapeador cria a sua com `create(false)` e o `conectar()` sempre encerra a anterior.
17. **`ProcessBuilder("appium")` não acha o binário** (ou o `npx`).
    O nvm só entra no PATH pelo `.zshrc`.
    → `Ambiente`/`RelatorioAllure` lançam via `/bin/zsh -ic "exec appium"` / `npx --yes allure@3.22.1`. Por isso o nvm **tem** que estar no `.zshrc`.
18. **`adb`/`emulator`: command not found.**
    Não estão no PATH.
    → Código usa `$ANDROID_HOME/platform-tools/adb` e `$ANDROID_HOME/emulator/emulator` (fallback `~/Library/Android/sdk`).
19. **▶ sem ambiente: `ConnectException POST http://127.0.0.1:4723/session` + vários stack traces.**
    Appium/emulador fora do ar.
    → `Ambiente.garantirNoAr()` sobe o AVD (`-no-snapshot-save`, espera `sys.boot_completed`, até 180 s) e o Appium (até 30 s) antes da suíte. Logs em `target/emulator.log` e `target/appium.log`.
20. **Emulador não sobe: nome do AVD errado.**
    `Ambiente` usa `avd` ou, na falta, `deviceName` do config.
    → `deviceName` = nome **exato** de `emulator -list-avds`.
21. **iOS: `tool 'xcodebuild' requires Xcode`.**
    Só Command Line Tools instalado.
    → Xcode completo + `sudo xcode-select -s /Applications/Xcode.app` + `appium driver install xcuitest`.
22. **Node antigo: Appium 3 recusa instalar/rodar.**
    → Node `^20.19.0`.
23. **JDK errado no ▶ do VSCode** (`release 25` inválido).
    → Configure o runtime Java 25 na extensão Java (`Java: Configure Java Runtime`).

### C. Mapeador: threads

24. **`IllegalStateException` em `DriverManager.get()`.**
    `DriverManager` é `ThreadLocal`; o polling roda em thread de executor.
    → `Inspetor` guarda driver próprio e **todo** acesso (inclusive `conectar()`) passa pelo mesmo executor single-thread.
25. **Polling para em silêncio.**
    Exceção que escapa de tarefa agendada cancela o agendamento.
    → `try/catch(Throwable)` em cada tick + `scheduleWithFixedDelay` (não `AtFixedRate`).
26. **`mvn` não termina e sessão fica viva ao fechar a janela.**
    Thread de executor não-daemon.
    → `WindowListener` cancela, chama `encerrar`, faz `shutdown` + `awaitTermination`.
27. **Sessão órfã ao reconectar.**
    → `conectar()` chama `encerrar()` antes.
28. **Mapeador sequestra o emulador abrindo o app do config.**
    → `DriverFactory.create(false)`: anexa ao app em primeiro plano. A suíte usa `create()`.

### D. Mapeador: lógica

29. **Rolar a lista criava "tela nova".** `RecyclerView` só expõe itens visíveis.
    → Assinatura de tela = activity + elementos **fora** de ancestral `scrollable`.
30. **App bar que colapsa mudava a tela.** → Se os fixos são subconjunto, é a mesma tela (merge).
31. **`.MainActivity` de apps diferentes viravam uma tela só.** → Nome = `pacote/activity`.
32. **Escala errada no Android.** → Escala = largura do PNG / largura exibida (XML só no iOS).
33. **Copiar do popup pegava lixo** (tabela reconstruída a cada tick). → Lê a fonte uma vez ao abrir o popup.
34. **XPath colado ficava com a estratégia antiga.** → Texto começando com `/` vira xpath automaticamente.
35. **`[Fatal Error] ... DOCTYPE fica desativado ...` no `InspetorTest`** é **esperado**: é o teste que prova que o parser rejeita XXE. O teste passa.

### E. Evidências

36. **Classes de opções de gravação "não existem".** Estão em `io.appium.java_client.android` / `.ios` (não `.options`); `VideoQuality` é enum aninhado.
37. **Eventos do Cucumber "não existem".** Estão no jar `cucumber-plugin` (`io.cucumber.plugin.event`), não em `cucumber-core`.
38. **Duração `82,6s`** em pt-BR. → `Locale.US` na formatação.
39. **Driver sem gravação de tela.** → `instanceof CanRecordScreen` antes de gravar.
40. **Vídeo cortado em 180 s.** Limite do `adb screenrecord`. Conhecido; cenário longo = dividir.
41. **Pasta de timestamp 3 h adiantada.** `maven.build.timestamp` é UTC. Esperado.
42. **Cenário de 40–80 s com steps de < 1 s.** Tempo é criação de sessão + gravação nos hooks. Esperado.

### F. Allure 3

43. Config em **`allurerc.json`** (não `.mjs`: o `.mjs` importa `defineConfig` e exige install local).
44. Anexos via **`scenario.attach`** (não `Allure.addAttachment`): `Evidencias` fica sem import de Allure.
45. **Nunca rode `allure generate` à mão**: cada generate acrescenta uma linha ao histórico e polui o trend.
46. Vídeo aparece em **Desmontagem** (é anexado no `@After`), não na aba Anexos. Normal.
47. Tamanho: ~22 MB num smoke de 5 cenários com vídeo. Reduzir: `video.bitRate`/`video.size`.
48. Pela IDE o relatório vai pra `evidencias/relatorio-allure/` (sem timestamp) e sobrescreve; histórico acumula igual.

### G. Runner e escrita de teste

49. **Constantes do `RodarPorTag` ignoradas.** `Config` carrega o `.properties` uma vez no primeiro acesso.
    → `System.setProperty` **antes** de qualquer `Config.get`. Nunca em bloco inicializador `{ ... }` (não roda num `main` estático).
50. **App nasce vazio a cada cenário** (UiAutomator2 faz `pm clear`). → Cenário cria o próprio dado (seed), nunca depende de outro.
51. **Dado ao vivo muda de nome.** → Selecionar por posição/slot (`descriptionStartsWith("1")`), nunca por título.
52. **Botão ignora toque enquanto a tela carrega** (skeleton) e `elementToBeClickable` não ajuda. → Esperar um elemento que só aparece com a tela carregada antes de tocar.
53. **Locator de app de sistema quebra** em outra versão de Android/fabricante/idioma (`resource-id` do Settings, `accessibility="Settings"` vs "Ajustes"). → Em app do time, `accessibility id` combinado com dev.


## Anexo 03

## 03 — Arquitetura e papel de cada arquivo

Mapa rápido. Spec detalhada de cada arquivo: Anexo 06 (build/config), Anexo 07, Anexo 08, Anexo 09, Anexo 10; padrões e ADRs: Anexo 11.

### Camadas

```
feature (Gherkin pt-BR)   o QUÊ, em linguagem de negócio
   ↓
steps                     traduz frase → chamada de screen + assert
   ↓
screens (Page Object)     ações de negócio de UMA tela; locators privados
   ↓
core                      driver, config, hooks, evidência, ambiente, relatório
   ↓
Appium Server → device

tools                     utilitário de dev (Mapeador), fora do teste; só chama core
```

Dependência só para baixo. Regras duras:

1. Só `core` importa `io.appium`/`org.openqa.selenium`. Exceções: as screens importam `@AndroidFindBy`/`@iOSXCUITFindBy`/`WebElement`; e a `BaseScreen` (e só ela) importa também `AppiumDriver`, `AppiumFieldDecorator`, `PageFactory`, `WebDriverWait`, `ExpectedConditions` para montar o PageFactory e os waits.
2. Step nunca toca driver, `By` ou `Thread.sleep`.
3. Screen expõe comportamento (`boolean estaVisivel()`), nunca elemento (`WebElement getTitulo()`).
4. Um Page Object para Android e iOS: dois locators no mesmo campo. Nada de `if (android)` espalhado.
5. Driver só em `ThreadLocal` (`DriverManager`). Nenhum outro estado estático mutável (exceção documentada: `Inspetor`).

### Arquivos

| Arquivo | Papel |
|---|---|
| `pom.xml` | Versões pinadas; Surefire só `Run*Test`; `cucumber.plugin` com timestamp por run; `exec-maven-plugin` abre o Mapeador com `waitSeconds=600` |
| `allurerc.json` | Allure 3: HTML único (`singleFile`), pt, histórico em `evidencias/historico-allure.jsonl` |
| `config/android.properties` / `ios.properties` | Capabilities + app sob teste + vídeo + Mapeador. Qualquer chave sobreposta por `-Dchave=valor` |
| `src/test/resources/junit-platform.properties` | `cucumber.glue` na raiz, plugins (pretty, Allure, ResumoMarkdown, RelatorioAllure) |
| `src/test/resources/allure.properties` | `allure.results.directory=target/allure-results` |
| `core/Config` | Lê `config/<platform>.properties` **uma vez**; system property ganha do arquivo |
| `core/DriverFactory` | Monta `AndroidDriver`/`IOSDriver` a partir do config. `create()` abre o app; `create(false)` anexa ao que está na tela (Mapeador) |
| `core/DriverManager` | `ThreadLocal<AppiumDriver>`: `set`/`get`/`quit` |
| `core/Hooks` | `@Before` cria driver + inicia vídeo; `@AfterStep` anexa screenshot; `@After` anexa falha + vídeo e faz `quit` (cada etapa em try/catch) |
| `core/Evidencias` | Screenshot e vídeo como `byte[]` (nada em disco) |
| `core/Ambiente` | Sobe emulador (AVD do config) e Appium (`/bin/zsh -ic`) se não estiverem no ar; no-op em dry-run |
| `core/RelatorioAllure` | Listener Cucumber: zera `target/allure-results` no início, roda `npx allure@3.22.1 generate` no fim, grava `environment.properties` (plataforma/app) |
| `core/ResumoMarkdown` | Listener Cucumber: `resumo.md` leve com link pro `index.html` |
| `core/Inspetor` | Lógica do Mapeador: lê hierarquia, sugere locator único, testa locator. Driver próprio num executor single-thread |
| `core/InspetorTest`, `tools/MapeadorElementosTest` | Testes offline (sem device); o `InspetorTest` usa a fixture `fixtures/settings-android.xml` |
| `tools/MapeadorElementos` | Janela Swing: espelho ao vivo com hover, escolher elemento, copiar locator (clique direito), testar locator (match em vermelho), relatório em `docs/mapeamento/` |
| `runner/RunCucumberTest` | Entrada do `mvn test` (`@Suite` + `@SelectPackages("features")`) |
| `runner/RodarPorTag` | Entrada do ▶ do VSCode: constantes `TAGS`/`PLATAFORMA`/`APP_*`, `Ambiente.garantirNoAr()`, Launcher API |
| `screens/BaseScreen` | `PageFactory` do Appium + `WebDriverWait`; helpers `visivel(el)` e `clicar(el)` |
| `screens/AjustesScreen` + `steps/AjustesSteps` + `features/ajustes.feature` | Smoke do próprio framework contra o Settings do sistema |
| `docs/padroes-suite-real.md` | Padrões de uma suíte real de 5 telas (seed, slot, skeleton) — gabarito de estilo, conteúdo de Anexo 12 |

### Fluxo de uma execução

```
▶ RodarPorTag.main
  → System.setProperty(platform, app...)      (antes do Config!)
  → Ambiente.garantirNoAr()                   (emulador + Appium)
  → Launcher(selectPackage "features", tag)
      RelatorioAllure: limpa target/allure-results
      por cenário: Hooks.@Before → steps → screens → Hooks.@AfterStep(png) → Hooks.@After(mp4, quit)
      AllureCucumber8Jvm grava results
      RelatorioAllure (TestRunFinished): npx allure generate → evidencias/.../relatorio-allure/index.html
      ResumoMarkdown → resumo.md
```

`mvn test` faz o mesmo a partir do `RunCucumberTest`, mas **não** chama `Ambiente` (Appium/emulador precisam estar no ar).


## Anexo 04

## 04 — Gates de verificação

Cada gate tem **comando** e **resultado esperado**. Só avança quando o atual passar. Todos rodam na raiz do projeto novo, com Java 25 no shell:

```bash
export JAVA_HOME="$(brew --prefix openjdk@25)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
```

### G0 — Máquina

```bash
zsh verificar-maquina.sh <nome-do-avd>     # o script do kit
```

Esperado: última linha `Máquina pronta.` (avisos `!` de iOS podem ficar).

### G1 — Compila

```bash
mvn -q -DskipTests test-compile
```

Esperado: nenhuma saída, exit 0. A primeira vez baixa as dependências (alguns minutos).

### G2 — Testes offline (sem device)

```bash
mvn -q test -Dtest='InspetorTest,MapeadorElementosTest'
grep -h '<testsuite' target/surefire-reports/*.xml | grep -o 'name="[^"]*".*failures="[0-9]*"'
```

Esperado: `InspetorTest` **17** testes e `MapeadorElementosTest` **14** (os casos de Anexo 10), todos com `errors="0"` e `failures="0"`.
A linha `[Fatal Error] :1:31: DOCTYPE fica desativado...` é **esperada** (teste de XXE).

### G3 — Descoberta (dry-run, sem device)

```bash
mvn -q test -Dcucumber.execution.dry-run=true
```

Esperado: lista `Cenário: Abrir a tela de Ajustes  # classpath:features/ajustes.feature:8` e nenhum step `undefined`.

### G4 — Suíte real via Maven

Em outra aba: `appium` (com `ANDROID_HOME` exportado) e o emulador:

```bash
~/Library/Android/sdk/emulator/emulator -avd <nome-do-avd> &
~/Library/Android/sdk/platform-tools/adb devices     # lista "emulator-5554	device"
mvn test -Dcucumber.filter.tags="@smoke"
```

Esperado: `Tests run: 1, Failures: 0, Errors: 0` e `BUILD SUCCESS`.

### G5 — Relatório Allure 3

```bash
ls -td evidencias/20*/ | head -3
open "$(ls -td evidencias/20*/ | head -1)relatorio-allure/index.html"
```

Esperado: um `index.html` único (abre offline) com o cenário verde, screenshot em cada step e o vídeo em **Desmontagem**; `evidencias/historico-allure.jsonl` com uma linha a mais. Se não gerar, ler `target/allure.log`.

### G6 — ▶ do VSCode com tudo desligado

1. Feche o emulador e mate o Appium (`lsof -ti tcp:4723 | xargs kill`).
2. Abra `src/test/java/br/com/automacao/runner/RodarPorTag.java` no VSCode e clique **Run** acima do `main`.

Esperado no console: `[rodar] android · Ajustes (com.android.settings) · tags @smoke`, `[ambiente] Nenhum device online, subindo emulador ...`, `[ambiente] Emulador pronto.`, `[ambiente] Subindo Appium...`, `[ambiente] Appium no ar.`, cenário verde, resumo com `0 tests failed`. Relatório em `evidencias/relatorio-allure/index.html`.

Sem VSCode (headless, mesmo efeito): `mvn -q dependency:build-classpath -Dmdep.includeScope=test -Dmdep.outputFile=target/cp.txt` e `java -cp "target/test-classes:$(cat target/cp.txt)" br.com.automacao.runner.RodarPorTag`. **Não** use `exec:java -Dexec.mainClass` (o pom fixa o Mapeador). Ao derrubar o emulador para o teste, espere ele sumir do `adb devices` antes de rodar.

### G7 — Mapeador

Com emulador e Appium no ar:

```bash
mvn -q test-compile exec:java
```

Esperado: abre a janela; **Conectar** liga sem abrir app nenhum (usa o que está na tela); passar o mouse no espelho destaca o elemento; clique direito → **Copiar @FindBy**; colar um locator no campo ao lado de **Testar** e clicar marca o match em vermelho. **Reiniciar Appium** destrava server preso. Fechar a janela encerra o `mvn`.

### G8 — Primeiro cenário do app do time

Ver Anexo 05. Esperado: `RodarPorTag` com `TAGS="@smoke"` verde contra o app do time, e a 1ª linha do console mostrando plataforma/app corretos (`[rodar] android · <app> (<package>) · tags @smoke`). O `RelatorioAllure` também grava `environment.properties` (Plataforma/App/Pacote) nos results; se o Allure 3 exibe isso no HTML ainda não foi confirmado.


## Anexo 05

## 05 — Apontar o projeto para o app do time e escrever o primeiro teste

Padrões de uma suíte real (5 telas, seed, dado ao vivo) em Anexo 12. Use como gabarito de estilo.

### 1. Instalar o app e descobrir package/activity (Android)

```bash
ADB=~/Library/Android/sdk/platform-tools/adb
$ADB install -r caminho/do/app.apk
$ADB shell pm list packages | grep <parte-do-nome>                   # package
$ADB shell cmd package resolve-activity --brief <package> | tail -1   # package/.Activity de entrada
```

iOS: `bundleId` do app (ex.: `com.empresa.app`) e o `.app`/`.ipa` instalado no simulador.

### 2. Configurar

`config/android.properties`:

```properties
appNome=<Nome do app>
appPackage=<package>
appActivity=<.Activity>
deviceName=<nome exato do AVD>
```

Ou, sem mexer no arquivo, nas constantes do `RodarPorTag` (`APP_NOME`, `APP_ID`, `APP_ACTIVITY`).
Lembrete: o app **nasce vazio** em cada cenário (`pm clear`). Se precisa de login/dado, o cenário cria.

### 3. Mapear a tela

```bash
mvn -q test-compile exec:java
```

Abra o app no emulador → **Conectar** → navegue até a tela → passe o mouse no elemento → clique direito → **Copiar @FindBy** (também há **Copiar valor** e **Copiar By.xxx()**). Cole no campo de teste e clique **Testar**: tem que marcar **1** match em vermelho. **Scanear**/**Stop** gravam o relatório das telas visitadas em `docs/mapeamento/`. Preferência de locator: `accessibility` > `id` > `uiAutomator` > `xpath`.

### 4. Screen (Page Object)

Arquivo `src/test/java/br/com/automacao/screens/<Tela>Screen.java`, classe pública que estende `BaseScreen`, com Javadoc de uma linha dizendo a tela.

- Um campo `private WebElement` por elemento usado, anotado com o locator copiado do Mapeador: `@AndroidFindBy(...)` e, se houver iOS, `@iOSXCUITFindBy(...)` **no mesmo campo**.
- Métodos públicos de negócio: ações (`entrarCom(String nome)`: `visivel(usuario).sendKeys(nome)` e `clicar(entrar)`) e verificações que devolvem `boolean` (`estaVisivel()`: `visivel(titulo).isDisplayed()`).
- Sem assert, sem `System.out`, sem `Thread.sleep`, sem expor `WebElement`.
- Gabarito de estilo: Anexo 12.

### 5. Steps

Arquivo `src/test/java/br/com/automacao/steps/<Fluxo>Steps.java`, classe pública com um campo `private final <Tela>Screen` por tela (seguro: o Cucumber cria a instância por cenário, depois do `@Before` que cria o driver).

- Anotações `io.cucumber.java.pt` (`@Dado`, `@Quando`, `@Entao`) com a frase exata do Gherkin; método com o nome em camelCase da frase (`queATelaDeLoginFoiAberta`).
- Assert só aqui, `org.junit.jupiter.api.Assertions`, sempre com mensagem (`"Tela de login não abriu"`).

### 6. Feature

`src/test/resources/features/<slug>.feature`:

```gherkin
# language: pt
@smoke
Funcionalidade: Login
  Como usuário do app
  Quero entrar com minhas credenciais
  Para acessar minha conta

  Cenário: Tela de login aparece ao abrir o app
    Dado que a tela de login foi aberta
```

### 7. Rodar

`RodarPorTag` com `TAGS = "@smoke"` → ▶. Ou `mvn test -Dcucumber.filter.tags="@smoke"`.
O `ajustes.feature` (Settings) também é `@smoke`: quando o app do time virar o default, troque a tag dele para só `@ajustes`, senão ele roda contra o app errado.

### 8. Documentar (rotina obrigatória do `CLAUDE.md`)

- `docs/features/<slug>.md` pelo template de `docs/README.md` + linha no índice.
- `plans/NNNN-<slug>.md` com status (`proposto` → `implementado`) + linha em `plans/README.md`.


## Anexo 06

## 06 — Spec: build, estrutura e arquivos de configuração

### Estrutura de pastas

```
<projeto>/
├── pom.xml
├── allurerc.json
├── .gitignore
├── .vscode/settings.json
├── CLAUDE.md  README.md
├── config/android.properties  config/ios.properties
├── docs/README.md  docs/features/  docs/mapeamento/.gitkeep
├── plans/README.md
├── standards/README.md  standards/architecture.md  standards/code-style.md  standards/decisions/
└── src/test/
    ├── java/br/com/automacao/{core,runner,screens,steps,tools}/
    └── resources/
        ├── junit-platform.properties
        ├── allure.properties
        ├── features/ajustes.feature
        └── fixtures/settings-android.xml
```

**Não existe `src/main`.** Tudo é escopo `test` (inclusive o Mapeador).

### pom.xml

Coordenadas do projeto: `br.com.automacao:automacao-mobile:1.0.0-SNAPSHOT`, `packaging` jar (default).

#### Properties

| Property | Valor |
|---|---|
| `maven.compiler.release` | `25` |
| `project.build.sourceEncoding` | `UTF-8` |
| `appium.java-client.version` | `11.0.0` |
| `selenium.version` | `4.52.0` |
| `cucumber.version` | `8.0.4` |
| `junit.version` | `6.1.3` |
| `slf4j.version` | `2.0.20` |
| `jackson.version` | `2.22.4` |
| `surefire.version` | `3.6.1` |
| `allure.cucumber8.version` | `10.4.20261102` |
| `allure.java.version` | `3.0.1` |
| `maven.build.timestamp.format` | `yyyy-MM-dd_HH-mm-ss` |

#### dependencyManagement (import de BOM, `type=pom`, `scope=import`)

- `io.cucumber:cucumber-bom:${cucumber.version}`
- `org.junit:junit-bom:${junit.version}`

#### Dependências (todas `scope=test`)

| GroupId:ArtifactId | Versão | Por quê (comentário no pom) |
|---|---|---|
| `io.appium:java-client` | `${appium.java-client.version}` | |
| `org.seleniumhq.selenium:selenium-java` | `${selenium.version}` | **pinado**: o java-client declara range `[4.50.0,5.0)` |
| `io.cucumber:cucumber-java` | (BOM) | |
| `io.cucumber:cucumber-junit-platform-engine` | (BOM) | |
| `org.junit.platform:junit-platform-suite` | (BOM) | |
| `org.junit.jupiter:junit-jupiter` | (BOM) | |
| `io.qameta.allure:allure-java-commons` | `${allure.java.version}` | o jar do adapter não declara deps; compilado contra Allure Java 3 |
| `io.github.shafthq:allure-cucumber8-jvm` | `${allure.cucumber8.version}` | o oficial `allure-cucumber7-jvm` dá `NoSuchMethodError` no Cucumber 8; este é o PR allure-java#1455 |
| `com.fasterxml.jackson.core:jackson-databind` | `${jackson.version}` | Selenium 4.5x delega JSON ao Jackson e não o traz transitivo |
| `com.fasterxml.jackson.datatype:jackson-datatype-jdk8` | `${jackson.version}` | idem |
| `org.slf4j:slf4j-simple` | `${slf4j.version}` | |

`junit-platform-launcher` (usado pelo `RodarPorTag`) vem transitivo — não declarar.

#### Plugins

**`maven-surefire-plugin` `${surefire.version}`**
- `includes`: só `**/Run*Test.java`.
- `systemPropertyVariables`:
  - `evidencias.dir` = `evidencias/${maven.build.timestamp}`
  - `cucumber.plugin` = `pretty, io.qameta.allure.cucumber8jvm.AllureCucumber8Jvm, br.com.automacao.core.ResumoMarkdown, br.com.automacao.core.RelatorioAllure`

**`org.codehaus.mojo:exec-maven-plugin` `3.5.0`**
- `mainClass` = `br.com.automacao.tools.MapeadorElementos`
- `classpathScope` = `test` (comentário: não há `src/main`)
- `systemProperties`: `waitSeconds` = `600` (comentário: vira `newCommandTimeout`; 20 s mataria a sessão enquanto o usuário navega)

### src/test/resources/junit-platform.properties

| Chave | Valor | Comentário |
|---|---|---|
| `cucumber.glue` | `br.com.automacao` | raiz do pacote: cobre core (Hooks), steps e screens |
| `cucumber.plugin` | `pretty, io.qameta.allure.cucumber8jvm.AllureCucumber8Jvm, br.com.automacao.core.ResumoMarkdown, br.com.automacao.core.RelatorioAllure` | mesma lista do pom; pela IDE não há `evidencias.dir`, então tudo cai em `evidencias/` sem timestamp |
| `cucumber.publish.quiet` | `true` | |

**Não** colocar `cucumber.filter.tags` aqui (o smoke de fábrica precisa rodar no `mvn test` puro).

### src/test/resources/allure.properties

`allure.results.directory=target/allure-results`

### allurerc.json (raiz)

```json
{
  "name": "Automação Mobile",
  "historyPath": "evidencias/historico-allure.jsonl",
  "plugins": { "awesome": { "options": { "singleFile": true, "reportLanguage": "pt" } } }
}
```

JSON e não `.mjs`: o `.mjs` importa `defineConfig` e exigiria `npm install` local.

### config/android.properties

| Chave | Valor | Uso |
|---|---|---|
| `appNome` | `Ajustes` | rótulo em console/relatório |
| `platformName` | `Android` | informativo |
| `automationName` | `UiAutomator2` | informativo |
| `deviceName` | `Pixel_6` | nome **exato** do AVD; `Ambiente` sobe esse AVD (comentário dizendo isso + `avd=<nome>` opcional) |
| `appPackage` | `com.android.settings` | app sob teste (comentário: default = Settings, troque pelo app do time) |
| `appActivity` | `.Settings` | |
| `serverUrl` | `http://127.0.0.1:4723/` | |
| `waitSeconds` | `20` | timeout de espera explícita e `newCommandTimeout` |
| `video.enabled` | `true` | |
| `video.size` | `540x1200` | |
| `video.bitRate` | `1000000` | |
| `video.timeLimitSeconds` | `180` | |
| `mapeador.intervaloSegundos` | `3` | |
| `mapeador.saida` | `docs/mapeamento` | |
| `mapeador.todos` | `false` | |

Chaves opcionais lidas pelo código: `avd` (default = `deviceName`), `noReset` (default `false`).

### config/ios.properties

| Chave | Valor |
|---|---|
| `appNome` | `Ajustes` |
| `platformName` | `iOS` |
| `automationName` | `XCUITest` |
| `deviceName` | `iPhone 16` |
| `platformVersion` | `18.0` |
| `bundleId` | `com.apple.Preferences` |
| `serverUrl` | `http://127.0.0.1:4723/` |
| `waitSeconds` | `20` |
| `video.enabled` | `true` |
| `video.quality` | `medium` |
| `video.fps` | `10` |
| `video.timeLimitSeconds` | `180` |
| `mapeador.intervaloSegundos` | `3` |
| `mapeador.saida` | `docs/mapeamento` |
| `mapeador.todos` | `false` |

### .gitignore

Linhas: `target/`, `.idea/`, `*.iml`, `.vscode/`, `*.log`, `evidencias/`, `.DS_Store`.

### .vscode/settings.json

Uma chave: `"java.configuration.updateBuildConfiguration": "interactive"`. É conveniência **local** (a pasta `.vscode/` fica no `.gitignore` de propósito; cada pessoa tem o seu) — criar mesmo assim.

### src/test/resources/fixtures/settings-android.xml

Page source **real** da tela inicial do Settings (Android 12 / API 31, Pixel 6, 1080 px de largura), usado pelo `InspetorTest`. É dado capturado, não escrito à mão. Como gerar (emulador e Appium no ar, Settings aberto na tela inicial):

```bash
SID=$(curl -s -X POST http://127.0.0.1:4723/session -H 'Content-Type: application/json' \
  -d '{"capabilities":{"alwaysMatch":{"platformName":"Android","appium:automationName":"UiAutomator2","appium:appPackage":"com.android.settings","appium:appActivity":".Settings"}}}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["value"]["sessionId"])')
curl -s http://127.0.0.1:4723/session/$SID/source | python3 -c 'import sys,json;print(json.load(sys.stdin)["value"])' \
  > src/test/resources/fixtures/settings-android.xml
curl -s -X DELETE http://127.0.0.1:4723/session/$SID >/dev/null
```

Conferir que o arquivo contém: raiz `<hierarchy`, vários nós com `resource-id="android:id/title"`, um nó `resource-id="com.android.settings:id/search_action_bar_title"`, atributos `bounds="[x1,y1][x2,y2]"`, `focused="false"`, e o primeiro nó com bounds tem largura 1080.


## Anexo 07

## 07 — Spec: camada `core` (pacote `br.com.automacao.core`)

Convenções para todas as classes utilitárias: `public final class`, construtor `private` vazio, métodos `static`. Javadoc de uma linha no topo dizendo o papel. Comentário só para o "por quê" não óbvio. Mensagens de erro em pt-BR.

---

### Config

Lê `config/<platform>.properties`. Qualquer chave pode ser sobreposta por `-Dchave=valor` (system property ganha do arquivo).

| Assinatura | Comportamento |
|---|---|
| `static String platform()` | `System.getProperty("platform", "android")` em minúsculas |
| `static String get(String key)` | system property → arquivo; nulo ou em branco lança `IllegalStateException("Configuração ausente: " + key)` |
| `static int getInt(String key)` | `Integer.parseInt(get(key))` |
| `static String get(String key, String padrao)` | igual, mas nulo/branco devolve `padrao` |
| `static int getInt(String key, int padrao)` | |
| `static boolean getBoolean(String key, boolean padrao)` | |

- O `Properties` é um campo `static final` carregado **uma única vez** na inicialização da classe, de `Path.of("config", platform() + ".properties")` (relativo ao diretório de trabalho).
- Arquivo ausente: `IllegalStateException("Arquivo de configuração não encontrado: " + caminhoAbsoluto)`. Falha de leitura: `IllegalStateException("Falha ao ler " + arquivo, causa)`.
- Consequência que o resto do projeto respeita: quem quer mudar `platform`/app por código precisa fazer `System.setProperty` **antes** do primeiro acesso a `Config` (lição 49).

### DriverManager

Único ponto de acesso ao driver. Campo `private static final ThreadLocal<AppiumDriver>`.

| Assinatura | Comportamento |
|---|---|
| `static AppiumDriver get()` | sem driver: `IllegalStateException("Driver não inicializado. Hooks.@Before não rodou?")` |
| `static void set(AppiumDriver driver)` | |
| `static void quit()` | se há driver: `quit()` e `remove()` do ThreadLocal |

### DriverFactory

Única classe que sabe criar driver por plataforma. Nova plataforma entra aqui.

| Assinatura | Comportamento |
|---|---|
| `static AppiumDriver create()` | `create(true)` |
| `static AppiumDriver create(boolean abrirApp)` | `abrirApp=false` = sessão sem app, só se anexa ao que está na tela (Mapeador) |

Comportamento de `create(abrirApp)` — `switch` (expressão) em `Config.platform()`:
- comum: `serverUrl` vira `URL` (`MalformedURLException` → `IllegalStateException("serverUrl inválida", e)`); `newCommandTimeout` = `Duration.ofSeconds(Config.getInt("waitSeconds"))`; `noReset` = `Config.getBoolean("noReset", false)`.
- `"android"`: `UiAutomator2Options` com `deviceName`; se `abrirApp`, `appPackage` + `appActivity`; devolve `new AndroidDriver(url, options)`.
- `"ios"`: `XCUITestOptions` com `deviceName`, `platformVersion`; se `abrirApp`, `bundleId`; devolve `new IOSDriver(url, options)`.
- outro: `IllegalArgumentException("Plataforma não suportada: " + plataforma)`.
- Pacotes: `io.appium.java_client.android.options.UiAutomator2Options`, `io.appium.java_client.ios.options.XCUITestOptions`.

### Evidencias

Captura de evidência em **bytes** (nada em disco). Quem anexa no relatório é o `Hooks`. Única classe de `core`, além de `DriverFactory`/`DriverManager`, que toca `TakesScreenshot`/`CanRecordScreen`.

| Assinatura | Comportamento |
|---|---|
| `static String slug(String nome, int linha)` | remove acentos (NFD + remove `\p{M}`), minúsculas, toda sequência não `[a-z0-9]` vira um `-`, tira `-` das pontas, trunca em 80 chars, tira `-` final, acrescenta `-l<linha>`. Ex.: `slug("Abrir a tela de Ajustes", 8)` → `abrir-a-tela-de-ajustes-l8` |
| `static byte[] screenshot()` | `TakesScreenshot` do driver atual, `OutputType.BYTES` |
| `static void iniciarVideo()` | ver abaixo |
| `static byte[] pararVideo()` | ver abaixo |

`iniciarVideo()`:
- Sai sem fazer nada se `video.enabled` (default `false`) for falso **ou** se o driver não for `instanceof CanRecordScreen` (lição 39; usar pattern matching `instanceof CanRecordScreen gravador`).
- `timeLimit` = `Duration.ofSeconds(Config.getInt("video.timeLimitSeconds", 180))`. Comentário `ponytail:` dizendo que o `adb screenrecord` corta em 180 s sem ffmpeg.
- Android: `AndroidStartScreenRecordingOptions` com `withVideoSize(Config.get("video.size","540x1200"))`, `withBitRate(Config.getInt("video.bitRate",1_000_000))`, `withTimeLimit`.
- iOS: `IOSStartScreenRecordingOptions` com `withVideoQuality(VideoQuality.valueOf(Config.get("video.quality","medium").toUpperCase()))`, `withFps(Config.getInt("video.fps",10))`, `withTimeLimit`.
- Pacotes **reais** (lição 36): `io.appium.java_client.android.AndroidStartScreenRecordingOptions`, `io.appium.java_client.ios.IOSStartScreenRecordingOptions` (o `VideoQuality` é enum aninhado nela), `io.appium.java_client.screenrecording.CanRecordScreen`.

`pararVideo()`: mesmas guardas (devolve `null`); `stopRecordingScreen()` devolve Base64; nulo/branco → `null`; senão `Base64.getDecoder().decode(...)`.

### Hooks

`public class Hooks` (não final; Cucumber instancia por cenário). Campo de instância `int contadorDeSteps`.

| Hook | Comportamento |
|---|---|
| `@Before public void abrirApp()` | `DriverManager.set(DriverFactory.create())` e `Evidencias.iniciarVideo()` |
| `@AfterStep public void capturarStep(Scenario scenario)` | anexa `Evidencias.screenshot()` como `image/png` com nome `"step %02d".formatted(++contadorDeSteps)`. Exceção: `System.err.println("Falha ao anexar screenshot do step: " + msg)` e segue |
| `@After public void encerrar(Scenario scenario)` | três blocos `try/catch` **independentes**, em ordem: (1) se `scenario.isFailed()`, anexa screenshot `image/png` com nome `falha`; (2) `pararVideo()` não nulo → anexa como `video/mp4` com nome `video`; (3) `DriverManager.quit()`. Cada catch imprime em `System.err` "Falha ao anexar screenshot de falha: …", "Falha ao anexar vídeo: …", "Falha ao encerrar driver: …" |

Anexo é sempre `scenario.attach(bytes, mime, nome)` — **não** `Allure.addAttachment` (o adapter converte; `core` não importa Allure).

### Ambiente

Sobe o que faltar (emulador Android + Appium) para o `RodarPorTag` e o Mapeador. **Não importa Appium/Selenium**: só `ProcessBuilder` e `java.net.http.HttpClient`. Javadoc diz: macOS only.

| Assinatura | Comportamento |
|---|---|
| `static void garantirNoAr() throws Exception` | se `System.getProperty("cucumber.execution.dry-run")` for `true`, retorna. Senão `garantirDevice()` e depois `garantirAppium()` |
| `static void garantirAppium() throws Exception` | ver abaixo |
| `static void matarAppium() throws Exception` | `lsof -ti tcp:<porta do serverUrl> -sTCP:LISTEN`; para cada PID, `kill`; espera 1,5 s. Usado pelo botão "Reiniciar Appium" |
| `static void garantirDevice() throws Exception` | ver abaixo |
| `static void exigirDevice() throws Exception` | Android sem device online: `IllegalStateException("Nenhum emulador/device online. Suba o " + deviceName + ".")`. Usado pelo Mapeador (que não sobe emulador sozinho) |

`garantirAppium()`:
1. `GET <serverUrl>/status`; status 200 = no ar → retorna. `IOException` conta como "fora do ar".
2. Imprime `[ambiente] Subindo Appium...`.
3. Log em `target/appium.log` (cria a pasta). Processo, com stderr redirecionado ao stdout e saída para o log — **exatamente** (lição 17):
   `new ProcessBuilder("/bin/zsh", "-ic", "exec appium")`
   Comentário: o nvm (e com ele o appium) só entra no PATH pelo `.zshrc`.
4. Injeta no ambiente do processo `ANDROID_HOME` e `ANDROID_SDK_ROOT` = `androidHome()` (lição 14).
5. Até 30 vezes: dorme 1 s; se `/status` responde 200 → imprime `[ambiente] Appium no ar.` e retorna; se o processo morreu → `IllegalStateException("Appium encerrou ao subir (código N), veja target/appium.log")`.
6. Esgotou: `IllegalStateException("Appium não respondeu em 30 s, veja target/appium.log")`.

`garantirDevice()`:
1. Se plataforma não é `android` ou já há device online → retorna (iOS é no-op).
2. `avd = Config.get("avd", Config.get("deviceName"))`. Imprime `[ambiente] Nenhum device online, subindo emulador <avd>...`.
3. Processo `<androidHome>/emulator/emulator -avd <avd> -no-snapshot-save`, log em `target/emulator.log`, com `ANDROID_HOME`/`ANDROID_SDK_ROOT` no ambiente.
4. Até 180 s, a cada 2 s: se `bootCompleted()` → `[ambiente] Emulador pronto.` e retorna; se o processo morreu → `IllegalStateException("Emulador encerrou (código N), veja <log>\n" + últimas 20 linhas do log)` (se não der para ler: `(sem log)`).
5. Esgotou: `IllegalStateException("Emulador não ficou pronto em 180 s, veja <log>")`.

Privados:
- `deviceOnline()`: `adb devices`; alguma linha termina com `\tdevice`.
- `bootCompleted()`: `adb shell getprop sys.boot_completed` com trim igual a `1`.
- `adb()` = `androidHome() + "/platform-tools/adb"`.
- `androidHome()` = env `ANDROID_HOME`, ou se ausente/branco `user.home + "/Library/Android/sdk"`.

### RelatorioAllure

`public final class RelatorioAllure implements io.cucumber.plugin.ConcurrentEventListener` (construtor público implícito: Cucumber instancia). Não importa Appium/Selenium. Constantes: `CLI = "allure@3.22.1"`, `RESULTADOS = Path.of("target/allure-results")`.

- `setEventPublisher`: registra `TestRunStarted` → `limparResultados()` e `TestRunFinished` → `gerar()`. Eventos ficam em `io.cucumber.plugin.event` (jar `cucumber-plugin`, lição 37).
- `limparResultados()`: se a pasta existe, apaga tudo dentro e ela própria (walk em ordem reversa). `IOException` → `UncheckedIOException`.
- `gerar()`:
  1. dry-run (`cucumber.execution.dry-run=true`) → retorna sem gerar.
  2. `saida = Path.of(System.getProperty("evidencias.dir", "evidencias"), "relatorio-allure")`; log `target/allure.log`.
  3. Grava `target/allure-results/environment.properties` com três linhas: `Plataforma=<platform>`, `App=<appNome ou id>`, `Pacote=<id>`, onde id = `bundleId` no iOS e `appPackage` no Android.
  4. Processo **exatamente**: `/bin/zsh -ic "exec npx --yes allure@3.22.1 generate target/allure-results --output <saida>"`, saída no log.
  5. Código 0 → `[allure] Relatório: <caminho absoluto do index.html>`. Senão `System.err`: `[allure] Falha ao gerar o relatório (código N), veja target/allure.log`. `IOException` → `[allure] Falha ao gerar o relatório: <msg>`. `InterruptedException` → reinterrompe a thread.
- Javadoc explica: mora na JVM (não numa fase do Maven) para rodar também no ▶ e mesmo com teste falhando; cada generate acrescenta uma linha ao histórico.

### ResumoMarkdown

`public final class ResumoMarkdown implements ConcurrentEventListener`. Grava `<evidencias.dir>/resumo.md` uma vez, no fim.

Estado: `private final Instant inicioExecucao = Instant.now()` (inicializado na construção do plugin, não por evento), `ConcurrentHashMap<UUID, Cenario>`, `CopyOnWriteArrayList<UUID> ordemDeTermino`. Classes internas privadas `Cenario` (nome, linha, caminho, lista de `Step`, `volatile Status status`, `volatile Duration duracao`) e `Step` (texto, status, duração, `Throwable erro`).

Eventos:
- `TestCaseStarted` → cria `Cenario(nome, linha, caminho)`; caminho = URI do testCase sem o prefixo `<esquema>:` (regex `^\w+:`).
- `TestStepFinished` → **só** se o step for `PickleStepTestStep` (hooks também disparam esse evento); guarda texto, status, duração e erro.
- `TestCaseFinished` → status, duração; adiciona o id em `ordemDeTermino`.
- `TestRunFinished` → cria a pasta e escreve o arquivo (`IOException` → `UncheckedIOException`).

Conteúdo (o timestamp é o nome da pasta `evidencias.dir`):

```
# Relatório de execução — <timestamp>

Plataforma: <platform> · Duração total: <x.ys>
**Resultado: <N> cenário(s) — <P> PASSOU, <F> FALHOU**

Evidências (screenshots por step e vídeo): [relatorio-allure/index.html](relatorio-allure/index.html)

---

## PASSOU|FALHOU — <nome do cenário>
`<caminho>:<linha>` · <x.ys>

| # | Step | Status | Duração |
|---|------|--------|---------|
| 1 | <texto> | PASSED | 0.4s |

### Erro no step <n>
```

Se algum step tem erro (vale o último com erro), após a tabela vem `### Erro no step <n>` e o stacktrace completo dentro de um bloco de código cercado por três crases.

- "cenário" no singular quando N == 1, "cenários" senão. PASSOU = `status.isOk()`.
- Sem guarda de dry-run: o dry-run também grava um `resumo.md` (aceito; o `RelatorioAllure` é que pula).
- Duração formatada com `String.format(Locale.US, "%.1fs", nanos/1e9)`; nula vira `-` (lição 38).

### Inspetor

Spec completa em Anexo 09 (é a lógica do Mapeador, mas mora em `core` porque toca Appium).


## Anexo 08

## 08 — Spec: runners, BaseScreen e a suíte de fábrica

### runner/RunCucumberTest (entrada do `mvn test`)

Classe pública vazia anotada com:
- `@Suite`
- `@IncludeEngines("cucumber")`
- `@SelectPackages("features")` — **não** `@SelectClasspathResource` (lição 5)
- `@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "br.com.automacao")` (constante de `io.cucumber.junit.platform.engine.Constants`)

Anotações de `org.junit.platform.suite.api`. O nome tem que casar `Run*Test` (Surefire).

### runner/RodarPorTag (entrada do ▶ do VSCode)

`public class RodarPorTag` com `public static void main(String[] args)`. Javadoc: roda a suíte filtrando por tag direto pelo ▶, sem Maven; espelha o `RunCucumberTest` via Launcher API; glue e plugin continuam vindo do `junit-platform.properties`, só `cucumber.filter.tags` é sobrescrito.

Constantes `static final String` (com comentários "EDITE AQUI" e exemplos):

| Constante | Valor de fábrica | Comentário |
|---|---|---|
| `TAGS` | `"@smoke"` | exemplos: `"@smoke"`, `"@smoke and not @wip"`, `"@ajustes"` |
| `PLATAFORMA` | `"android"` | `"android"` \| `"ios"` |
| `APP_NOME` | `""` | rótulo no console/relatório (ex.: `"Ajustes"`) |
| `APP_ID` | `""` | `appPackage` (Android) / `bundleId` (iOS) |
| `APP_ACTIVITY` | `""` | só Android. Ex.: `com.android.settings` + `.Settings` |

Vazio = vale o `config/<plataforma>.properties`; `-D` na run config ganha da constante.

`main`, nesta ordem (a ordem é obrigatória, lição 49):
1. `tags` = args unidos por espaço se houver args, senão `TAGS`.
2. `definir("platform", PLATAFORMA)`, `definir("appNome", APP_NOME)`; `ios` = `platform` (system property, default android) é `ios`; `definir(ios ? "bundleId" : "appPackage", APP_ID)`; se Android, `definir("appActivity", APP_ACTIVITY)`. Comentário: tem que vir antes do 1º acesso a `Config`.
3. Em `try`: `id = Config.get(ios ? "bundleId" : "appPackage")` e imprime `[rodar] <platform> · <appNome ou id> (<id>) · tags <tags>`. Exceção → `System.err` `[rodar] Configuração inválida: <msg>` e `System.exit(1)`.
4. Em `try`: `Ambiente.garantirNoAr()`. Exceção → `[ambiente] Não foi possível preparar o ambiente: <msg>` e `System.exit(1)`.
5. `LauncherDiscoveryRequestBuilder.request()` com `selectors(DiscoverySelectors.selectPackage("features"))`, `filters(EngineFilter.includeEngines("cucumber"))`, `configurationParameter(Constants.FILTER_TAGS_PROPERTY_NAME, tags)`.
6. `SummaryGeneratingListener`; `try (LauncherSession session = LauncherFactory.openSession())` → `getLauncher()`, registra o listener, `execute(request)`.
7. Imprime `summary.printTo` e `printFailuresTo` num `PrintWriter(System.out, true)`; `System.exit(falhas > 0 ? 1 : 0)`.

`private static void definir(String chave, String valor)`: só faz `System.setProperty` se `valor` não está em branco **e** a system property ainda não existe. **Nada** em bloco inicializador `{ }` — num `main` estático nunca roda.

### screens/BaseScreen

`public abstract class BaseScreen`. Javadoc: base dos Page Objects; injeta locators por plataforma e expõe waits explícitos.

- `protected final AppiumDriver driver = DriverManager.get();`
- `protected final WebDriverWait wait` = `new WebDriverWait(driver, Duration.ofSeconds(Config.getInt("waitSeconds")))`
- construtor `protected BaseScreen()` chama `PageFactory.initElements(new AppiumFieldDecorator(driver), this)`.
  **O import tem que ser** `import io.appium.java_client.support.PageFactory;` — o do Selenium não compila (lição 1).
- `protected WebElement visivel(WebElement element)` → `wait.until(ExpectedConditions.visibilityOf(element))`
- `protected void clicar(WebElement element)` → `wait.until(ExpectedConditions.elementToBeClickable(element)).click()`

Sem implicit wait. Sem `Thread.sleep`.

### Suíte de fábrica: Ajustes do sistema

#### screens/AjustesScreen

`public class AjustesScreen extends BaseScreen`. Javadoc: tela de Ajustes nativa; um Page Object, dois conjuntos de locators.
- Campo `private WebElement titulo` com **dois** locators:
  - `@AndroidFindBy(xpath = "//*[@resource-id='com.android.settings:id/search_action_bar_title']")`
  - `@iOSXCUITFindBy(accessibility = "Settings")`
- `public boolean estaVisivel()` → `visivel(titulo).isDisplayed()`.

#### steps/AjustesSteps

`public class AjustesSteps`; campo `private AjustesScreen ajustes`.
- `@Dado("que o aplicativo de Ajustes foi aberto")` método `queOAplicativoDeAjustesFoiAberto()` → `ajustes = new AjustesScreen()`.
- `@Entao("a tela de Ajustes é exibida")` método `aTelaDeAjustesEExibida()` → `assertTrue(ajustes.estaVisivel(), "Tela de Ajustes não ficou visível")`.
- Anotações de `io.cucumber.java.pt` (`Dado`, `Entao`); assert de `org.junit.jupiter.api.Assertions`.

#### src/test/resources/features/ajustes.feature

Conteúdo integral (Gherkin é dado, não código):

```gherkin
# language: pt
@smoke @ajustes
Funcionalidade: Ajustes do sistema
  Como time de automação
  Quero validar a abertura do app nativo de Ajustes
  Para confirmar que o pipeline Appium + Cucumber está funcional

  Cenário: Abrir a tela de Ajustes
    Dado que o aplicativo de Ajustes foi aberto
    Então a tela de Ajustes é exibida
```

Quando o app do time virar o default do config, trocar a tag dessa feature para só `@ajustes`.


## Anexo 09

## 09 — Spec: Mapeador de Elementos (`core/Inspetor` + `tools/MapeadorElementos`)

Ferramenta de desenvolvimento, fora do pipeline de teste. Decisão em ADR 0003 (ver Anexo 11).

Divisão de responsabilidade:
- **`core/Inspetor`**: único que fala com o driver. Devolve `record`s de `String`/`byte[]`/`double[]`, **nunca** `WebElement` nem `AppiumDriver`.
- **`tools/MapeadorElementos`**: só Swing + executor. Não importa `io.appium` nem `org.openqa`. Chama `Inspetor`, `Ambiente`, `Config`, `Evidencias.slug`.

---

### core/Inspetor

`public final class Inspetor implements AutoCloseable`. Javadoc: lê a tela atual e devolve elementos com locator sugerido já validado como único; dono do próprio driver (não usa `DriverManager`, que é ThreadLocal); toda chamada vem da mesma thread, que não é a do teste.

#### Records públicos aninhados

| Record | Componentes | Nota |
|---|---|---|
| `Elemento` | `String tipo, String id, String texto, String descricao, String estrategia, String valor` | |
| `Captura` | `String tela, String assinatura, Set<String> fixos, List<Elemento> elementos` | `fixos` = locators fora de listas rolantes |
| `Foto` | `byte[] png, String xml` | screenshot e page source do mesmo instante |

Record privado `Candidato(String estrategia, String valor, String xpath)`.

#### Estado e métodos de instância

Campo `private AppiumDriver driver` (instância, **não** estático).

| Assinatura | Comportamento |
|---|---|
| `void conectar()` | chama `encerrar()` (se lançar `RuntimeException` porque o server morreu, só zera o driver) e cria `DriverFactory.create(false)` (anexa ao app em primeiro plano, lição 28) |
| `Captura capturar(Foto foto)` | `tela` = se driver é `AndroidDriver`: `getCurrentPackage() + "/" + currentActivity()` (lição 31); iOS: `""` (comentário `ponytail:` dizendo que iOS não expõe activity). Delega a `parse(foto.xml(), tela, ios, Config.getBoolean("mapeador.todos", false))` |
| `Foto fotografar()` | `getScreenshotAs(BYTES)` e depois `getPageSource()` |
| `List<double[]> encontrar(String estrategia, String valor)` | `driver.findElements(montarBy(...))`, cada um vira `{x, y, x+w, y+h}` via `getRect()`. Lança se locator inválido |
| `void encerrar()` | se há driver: `quit()` e zera |
| `void close()` | `encerrar()` |

#### `static By montarBy(String estrategia, String valor)` (package-private)

`switch` exato (`AppiumBy`):

| estratégia | fábrica |
|---|---|
| `id` | `AppiumBy.id` |
| `accessibility id` | `AppiumBy.accessibilityId` |
| `xpath` | `AppiumBy.xpath` |
| `class name` | `AppiumBy.className` |
| `-android uiautomator` | `AppiumBy.androidUIAutomator` |
| `ios predicate` | `AppiumBy.iOSNsPredicateString` |
| `ios class chain` | `AppiumBy.iOSClassChain` |
| outra | `IllegalArgumentException("Estratégia desconhecida: " + estrategia)` — não cair em xpath, daria "0 encontrado" enganoso |

#### `static Captura parse(String xml, String tela, boolean ios, boolean todos)` (package-private)

1. Parse seguro (abaixo). Qualquer exceção → `IllegalStateException("Falha ao interpretar o page source", causa)`.
2. Percorre `doc.getElementsByTagName("*")` em ordem de documento. Pula o elemento raiz (pai == documento) e, se `!todos`, os que não `interessa`.
3. Para cada um: `Candidato c = locator(no, ...)`; cria `Elemento(tag, id, texto, descricao, c.estrategia, c.valor)` onde Android usa atributos `resource-id` / `text` / `content-desc` e iOS `name` / `label` / `value`.
4. Chave `estrategia + "=" + valor` entra em `todosOsLocators` (TreeSet); se **não** está dentro de scroll, entra também em `fixos` (TreeSet).
5. `base` = `fixos` se não vazio, senão `todosOsLocators`. Devolve `Captura(tela, assinatura(tela, base), base, elementos)`.

#### Parse seguro (proteção XXE — XML vem de app de terceiros)

`DocumentBuilderFactory` com: feature `http://apache.org/xml/features/disallow-doctype-decl` = true, `XMLConstants.FEATURE_SECURE_PROCESSING` = true, `setXIncludeAware(false)`, `setExpandEntityReferences(false)`. Entrada via `InputSource(StringReader)`. Um XML com `<!DOCTYPE` tem que falhar (o parser imprime `[Fatal Error] ... DOCTYPE ...` no stderr — esperado).

#### Filtro `interessa(no, ios)`

Comentário `ponytail:` (heurística; `-Dmapeador.todos=true` desliga).
- Android: interessa se tem `resource-id`, `text` ou `content-desc` não vazios, **ou** `clickable="true"`.
- iOS: interessa se tem `name`, `label` ou `value` não vazios.

#### Locator único `locator(no, doc, xpath, ios)`

Candidatos em ordem de prioridade, só os de atributo não vazio e "aspável":

| Plataforma | estratégia | valor do candidato | XPath de checagem |
|---|---|---|---|
| Android | `id` | o `resource-id` | `//*[@resource-id=Q]` |
| Android | `accessibility id` | o `content-desc` | `//*[@content-desc=Q]` |
| Android | `xpath` | o próprio XPath | `//<tag>[@text=Q]` |
| iOS | `accessibility id` | o `name` | `//*[@name=Q]` |
| iOS | `xpath` | o próprio XPath | `//<tag>[@label=Q]` |

`Q` = `aspas(valor)`. O primeiro candidato cujo `count(<xpath de checagem>)` no **próprio DOM do snapshot** é exatamente 1 vence. Nenhum único → `xpath` com o **XPath absoluto**.

`static String aspas(String v)` (package-private): vazio → `null`; sem `'` → `'v'`; com `'` e sem `"` → `"v"`; com os dois → `null` (XPath 1.0 não escapa, descarta o candidato).

XPath absoluto `absoluto(no)`: do nó até a raiz, cada segmento `/<tag>[<índice>]`, onde índice = 1 + número de irmãos **anteriores com a mesma tag**. Ex.: `/hierarchy[1]/android.widget.TextView[3]`.

#### Dentro de scroll `dentroDeScroll(no, ios)`

Sobe pelos ancestrais: Android = algum tem `scrollable="true"`; iOS = algum tem tag `XCUIElementTypeScrollView`, `XCUIElementTypeTable` ou `XCUIElementTypeCollectionView`. Comentário: itens de lista reciclam a cada scroll; fora da assinatura, senão todo scroll vira tela nova (lição 29).

#### Assinatura `assinatura(tela, chaves)`

SHA-256 de `tela + "\n" + String.join("\n", chaves)` em UTF-8; devolve os **8 primeiros bytes** em hex minúsculo (`HexFormat.of().formatHex(hash, 0, 8)` = 16 chars). Não é hash do page source: bounds/focused/checked mudam a cada scroll.

#### `public static final class Hierarquia` (hover do espelho)

Page source interpretado uma vez por foto, para consultas repetidas. Javadoc: não é thread-safe (DOM do Xerces expande nós na leitura); usar numa thread só.

- Construtor `Hierarquia(String xml, boolean ios)`: parse seguro (falha → `IllegalStateException("Falha ao interpretar o page source", e)`); guarda, em ordem de documento, os nós que têm limites e seus `{x1,y1,x2,y2}`.
- Limites: Android = atributo `bounds` casando `\[(-?\d+),(-?\d+)]\[(-?\d+),(-?\d+)]`; iOS = `x`, `y`, `width`, `height` (só se tem `width`); número inválido → sem limites. Comentário `ponytail:` ramo iOS não testado.
- `int largura()`: `x2 - x1` do **primeiro** nó com limites; 0 se nenhum.
- `Map<String,String> noEm(double x, double y)`: entre os nós com `x1 <= x < x2` e `y1 <= y < y2`, o de **menor área**; empate vai pro **último** no documento (usar `<=` na comparação). Sem filtro `interessa` (container também é escolhível). Nenhum → `Map.of()`. **Mesmo nó da consulta anterior → devolve a mesma instância de Map** (o Mapeador compara por referência para não redesenhar).
- Detalhe do nó (`LinkedHashMap`, nesta ordem): `estratégia`, `locator` (do algoritmo de locator único), `xpath absoluto`, `tag`, todos os atributos do nó, e por último `bounds` sempre no formato `[x1,y1][x2,y2]` (inteiros).

Estáticos de conveniência **públicos**: `public static Map<String,String> noEm(String xml, double x, double y, boolean ios)` e `public static int larguraTela(String xml, boolean ios)` (criam uma `Hierarquia` e consultam).

---

### tools/MapeadorElementos

`public final class MapeadorElementos`. Javadoc: janela que observa a navegação no emulador e grava, por tela visitada, os locators sugeridos; só Swing + executor; rodar com `mvn -q test-compile exec:java`. `main` faz `SwingUtilities.invokeLater(() -> new MapeadorElementos().abrir())`.

#### Partes testáveis (package-private, cobertas pelo `MapeadorElementosTest`)

`enum Formato` com rótulo: `ANOTACAO("Copiar @FindBy")`, `VALOR("Copiar valor")`, `BY("Copiar By.xxx()")`.

`static String snippet(Formato f, String estrategia, String valor, boolean ios)`:
- mapa estratégia → (atributo do @FindBy, método AppiumBy): `id`→(`id`,`id`), `accessibility id`→(`accessibility`,`accessibilityId`), `xpath`→(`xpath`,`xpath`); estratégia desconhecida usa o de `xpath`.
- `v` = valor escapado como literal Java: primeiro `\` → `\\`, depois `"` → `\"`, depois CR → `\r`, LF → `\n` (nessa ordem).
- `VALOR` → valor cru (sem escapar).
- `BY` → `AppiumBy.<metodo>("<v>")`.
- `ANOTACAO` → `@AndroidFindBy(<attr> = "<v>")` (ou `@iOSXCUITFindBy(` se `ios`) + `\n` + `private WebElement elemento;`.

`static String[] parseLocator(String texto)` — entende o que o menu copia:
- Literal Java entre aspas: `"((?:[^"\\]|\\.)*)"` (atravessa `\"` sem fechar cedo).
- Padrões tentados nesta ordem, `Pattern.DOTALL`, com `find()` (o resto do texto é ignorado):
  1. `AppiumBy\.(\w+)\(\s*<LITERAL>\s*\)`
  2. `@(?:AndroidFindBy|iOSXCUITFindBy)\(\s*(\w+)\s*=\s*<LITERAL>\s*\)`
- O nome capturado é traduzido: `id`→`id`; `accessibilityId` e `accessibility`→`accessibility id`; `xpath`→`xpath`; `className`→`class name`; `androidUIAutomator` e `uiAutomator`→`-android uiautomator`; `iOSNsPredicateString` e `iOSNsPredicate`→`ios predicate`; `iOSClassChain`→`ios class chain`. Nome desconhecido → `null`.
- Devolve `{estratégia, valor desescapado}` ou `null` se nada casar.
- Desescape: varre da esquerda pra direita; `\n`→LF, `\r`→CR, `\"`→`"`, `\\`→`\`, outra `\x` fica `\x`; `\` final fica.

`static String estrategiaDoCru(String texto, String doCombo)`: texto começando com `/` → `xpath`; senão `doCombo` (lição 34).

#### Janela principal "Mapeador de Elementos" (`JFrame`, 1100×600, `setLocationByPlatform`)

- Norte: `JToolBar` não flutuante com botões **Conectar**, **Scanear**, **Stop**, **Inspecionar**, separador, **Reiniciar Appium**. Scanear/Stop/Inspecionar começam desabilitados.
- Centro: tabela de scan (não editável) com colunas `Tela, Tipo, Id, Texto, Estratégia, Valor`, com popup de copiar (abaixo).
- Sul: `JLabel` de status, começa `Desconectado`.
- Fechar: `DO_NOTHING_ON_CLOSE` + `WindowListener.windowClosing` → `fechar()`.

Config lida no construtor: `mapeador.intervaloSegundos` (default 3), `mapeador.saida` (default `docs/mapeamento`).

#### Threads (lições 24–27)

- `ScheduledExecutorService` de **uma thread** (`newSingleThreadScheduledExecutor`, não-daemon). **Todo** acesso ao `Inspetor` (conectar, fotografar, capturar, encontrar, encerrar) roda nele.
- UI só na EDT (`SwingUtilities.invokeLater`, helper `ui(Runnable)`).
- Mapa de telas (assinatura → Tela) só tocado pelo executor; estado do espelho só pela EDT.

#### Ações

**Conectar**: desabilita o botão; status `Conectando (sobe o Appium se preciso, pode levar até 60 s)...`; no executor: `Ambiente.exigirDevice()`, `Ambiente.garantirAppium()`, `inspetor.conectar()`. Sucesso → status `Conectado ao app em primeiro plano. Navegue no emulador e clique em Scanear.`, habilita Scanear e Inspecionar (Conectar fica desabilitado; só o Reiniciar Appium o reabilita). Falha (`Throwable`) → `Falha ao conectar: <msg>` e reabilita Conectar.

**Reiniciar Appium**: desabilita Reiniciar/Scanear/Inspecionar/Stop, cancela o scan; status `Reiniciando Appium...`; em **thread própria daemon** (o executor pode estar preso num conectar pendurado): `Ambiente.matarAppium()` + `Ambiente.garantirAppium()` → `Appium reiniciado. Clique em Conectar.` ou `Falha ao reiniciar Appium: <msg>`; no fim reabilita Reiniciar e Conectar.

**Scanear**: desabilita Scanear, habilita Stop, pede para abrir o espelho, solta resultado de teste; status `Scaneando a cada N s... passe o mouse no espelho para ver o elemento.`; agenda `tick` com `scheduleWithFixedDelay(tick, 0, intervalo, SECONDS)` (**não** `AtFixedRate`: page source do iOS é lento).

**tick** (no executor, **todo** em `try/catch(Throwable)` — exceção que escapa cancela o agendamento em silêncio):
1. `fotografar()`, `capturar(foto)`, monta o `Quadro` (abaixo), `resolver(captura)`.
2. Novos elementos = os cuja chave `estrategia=valor` ainda não estava na tela (dedupe por estratégia+valor, não por xpath absoluto: o índice muda quando a lista recicla).
3. EDT: mostra o quadro, adiciona linhas `<n> <nome da tela>`, tipo, id, texto, estratégia, valor; status `Scaneando: X telas, Y elementos`.
4. Erro → status `Erro no scan (segue tentando): <msg>`.

**resolver(captura)** (lição 29–30): (1) assinatura já conhecida → essa tela; (2) senão, tela com **mesmo nome** e cujos fixos **contêm todos** os fixos da captura (app bar colapsou) → essa tela; (3) senão tela nova numerada `telas.size()+1`, registrada pela assinatura. Tela = `record Tela(int numero, String nome, Set<String> fixos, Map<String, Elemento> elementos)`; o mapa `telas` (`LinkedHashMap` assinatura → Tela) guarda a assinatura como **chave** (o relatório itera as entradas). O merge da regra (2) não registra a assinatura nova. As telas acumulam entre Stop e novo Scanear.

**Stop**: cancela o agendamento, desabilita Stop, habilita Scanear; no executor grava o relatório → status `Relatório gravado: <arquivo> (pode navegar e scanear de novo)` ou `Nada capturado.` ou `Falha ao gravar relatório: <msg>`.

**Inspecionar**: desabilita o botão, pede abrir o espelho, status `Fotografando a tela...`; no executor fotografa e monta o quadro; na EDT solta resultado de teste, mostra, status `Passe o mouse no espelho; clique congela o elemento.`; falha → `Falha ao fotografar: <msg>`; sempre reabilita.

**fechar()**: cancela o scan; submete `inspetor.encerrar()` ao executor (erro só em `System.err`); `shutdown()` + `awaitTermination(30 s)`; descarta espelho e janela. Sem isso o `mvn` não termina.

#### Quadro (foto pronta para a EDT)

`record Quadro(BufferedImage imagem, Inspetor.Hierarquia hierarquia, double r)`, montado **no executor**:
- decodifica o PNG (`ImageIO`); ilegível → `IllegalStateException("screenshot ilegível")`;
- reduz para altura máx. **800 px** (fator `min(1, 800/altura)`, `SCALE_SMOOTH`, `TYPE_INT_RGB`);
- `Hierarquia` do XML da mesma foto;
- `r` = unidade do device por pixel exibido = `largura / larguraReduzida`, onde `largura` = no iOS a `hierarquia.largura()` (se > 0), no Android a **largura do PNG original** (lição 32: a do XML pode ser de um diálogo).

#### Espelho (janela única "Espelho", criada uma vez, `HIDE_ON_CLOSE`)

- Norte: painel de teste — combo de estratégias (`id`, `accessibility id`, `xpath`, `class name`, `-android uiautomator`, `ios predicate`, `ios class chain`), campo de texto (32 colunas), checkbox **tela atual**, botão **Testar** (Enter no campo também testa).
- Centro: `JSplitPane` horizontal: imagem (JLabel alinhado topo-esquerda, desenha por cima retângulos vermelhos com traço 3 — os matches do teste, ou senão o destaque do hover) | tabela `Atributo, Valor` (não editável).
- Sul: label de resultado do teste.
- Mostrar quadro: se a janela principal já foi descartada → não faz nada (lição: tick em voo não ressuscita o espelho). Se há resultado de teste na tela → não troca a foto. Senão troca a imagem; congelado → só some o destaque; não congelado → recalcula o hover no último ponto do mouse. Primeira vez: `pack` + `setLocationByPlatform`. Só fica visível quando Scanear/Inspecionar pediram (o tick só atualiza).
- Hover (`mouseMoved`): se não congelado, sem resultado de teste e com quadro: `noEm(p.x * r, p.y * r)`; se o Map é a **mesma instância** do exibido, não faz nada; senão preenche a tabela de atributos e o destaque = retângulo de `bounds` dividido por `r`.
- Clique **esquerdo** (só esquerdo, lição 33): com resultado de teste → limpa resultado e descongela; senão alterna congelado. Título `Espelho (congelado, clique para soltar)` ou `Espelho`.
- Clique direito na imagem → popup de copiar com a fonte = nó **recalculado sob o ponto do mouse** (não o último exibido).

#### Testar locator

1. Texto vazio → `Digite um locator.`.
2. `parseLocator(texto)`; se casou usa estratégia/valor colados; senão valor cru com `estrategiaDoCru(texto, combo)`. Atualiza o combo para a estratégia usada.
3. Foto nova se **tela atual** desmarcado ou não há quadro. Desabilita Testar, `Testando...`.
4. No executor: (foto nova?) fotografar; `encontrar(estrategia, valor)`; (foto nova?) quadro. EDT: mostra resultado. Erro → só a **primeira linha** da mensagem (`erro: <linha>`; sem mensagem usa o nome da classe).
5. Mostrar resultado: reabilita Testar; janela descartada → sai; com quadro novo troca a imagem e congela; matches = bounds/`r` em vermelho; destaque some em **todos** os ramos; `N encontrado(s)` ou `erro: ...`.

#### Popups de copiar (lição 33)

- Formatos (tabela de scan e imagem do espelho): em `mousePressed` e `mouseReleased`, se `isPopupTrigger`: na tabela seleciona a linha sob o mouse; lê a fonte **uma vez, ao abrir** (tabela: colunas Estratégia e Valor da linha; espelho: nó sob o ponto); sem valor → não abre; um item por `Formato` que copia `snippet(f, estrategia, valor, ios)`.
- Tabela de atributos: item único **Copiar valor desta linha** (valor da coluna 2; vazio não abre).
- Copiar = clipboard do sistema (`StringSelection`) + status `Copiado (<rótulo>): <texto>`.

#### Relatório `.md` gravado no Stop

Arquivo `<mapeador.saida>/<yyyy-MM-dd_HH-mm-ss>-<slug>.md`, slug = `Evidencias.slug(nome da 1ª tela ou "mapeamento" se vazio, quantidade de telas)`. Conteúdo:

```
# Mapeamento de elementos — <timestamp>

## Tela <n> — <nome ou "(sem activity)">

Assinatura: `<assinatura>`

| # | tipo | id | texto | estratégia | valor |
|---|---|---|---|---|---|
| 1 | ... | ... | ... | ... | `<valor>` |
```

Célula: `|` vira `\|`, quebras de linha viram espaço. Valor entre crases, exceto se contém crase (aí só escapado). Sem telas → não grava (`Nada capturado.`).


## Anexo 10

## 10 — Spec: testes offline (sem device)

JUnit Jupiter (`org.junit.jupiter.api.Test` + `Assertions`). Classes package-private, mesmo pacote da classe testada. Rodam com `mvn -q test -Dtest='InspetorTest,MapeadorElementosTest'` (o Surefire só inclui `Run*Test`; `-Dtest` sobrepõe).

### core/InspetorTest — 17 testes

Fixture: `SETTINGS` = conteúdo de `src/test/resources/fixtures/settings-android.xml` lido com `Files.readString(Path.of(...))` (como gerar: Anexo 06). Helpers privados do teste: converter `"[x1,y1][x2,y2]"` em `int[4]`, área, "contém o ponto" (`x1 <= x < x2`, `y1 <= y < y2`).

Ponto de hit-test: `(540, 594)` — dentro da barra de busca do Settings no Pixel 6/API 31. Se a fixture for de outra imagem, usar o centro do nó `com.android.settings:id/search_action_bar_title`.

| # | Nome | Dado | Esperado |
|---|---|---|---|
| 1 | `idRepetidoNaoViraLocatorId` | `parse(SETTINGS, "", false, false)` | todo elemento com `id == "android:id/title"` tem `valor != "android:id/title"` (id repetido nunca vira locator `id`) |
| 2 | `contentDescUnicoSemIdViraAccessibilityId` | `<hierarchy>` com dois `android.widget.ImageView` clicáveis, `content-desc` `Perfil` e `Outro` | 1º elemento: estratégia `accessibility id`, valor `Perfil` |
| 3 | `idUnicoVenceNoSettingsReal` | SETTINGS | elemento com id `com.android.settings:id/search_action_bar_title` tem estratégia `id` |
| 4 | `todoLocatorCasaExatamenteUmNo` | `parse(SETTINGS, "", false, true)` (todos) | para cada elemento, montar XPath (`id` → `//*[@resource-id='v']`, `accessibility id` → `//*[@content-desc='v']`, senão o próprio valor) e `count(...)` num DOM comum do SETTINGS dá `1.0` |
| 5 | `apostrofoNaoQuebraXPath` | 3 `TextView` não clicáveis: `text="Don't"`, `text="Don't"`, e `say "it" don't` (atributo com aspas simples e `&apos;`) | 3 elementos; o 1º valor é `/hierarchy[1]/android.widget.TextView[1]` (duplicado → absoluto); o 3º é `/hierarchy[1]/android.widget.TextView[3]` (as duas aspas → descarta → absoluto) |
| 6 | `textoUnicoComApostrofoUsaAspasDuplas` | 1 `TextView` `text="Don't"` | valor `//android.widget.TextView[@text="Don't"]` |
| 7 | `filtroDescartaLayoutPuro` | SETTINGS com `todos=false` e `true` | `0 < filtrado < todos` |
| 8 | `mesmoXmlMesmaAssinatura` | parse duas vezes | assinaturas iguais |
| 9 | `boundsEFocusedNaoMudamAssinatura` | SETTINGS com `focused="false"`→`"true"` e todo `bounds` → `[1,1][2,2]` (o texto tem que mudar) | assinatura igual à original |
| 10 | `scrollNaListaNaoMudaAssinatura` | molde: `TextView` fixo `text=%s` + `RecyclerView` `resource-id="lista"` `scrollable="true"` contendo `TextView` `text=%s`. A: (Wi-Fi, Item A); B: (Wi-Fi, Item B); C: (Bluetooth, Item A) | A == B; A != C |
| 11 | `doctypeEhRejeitado` | `<?xml…?><!DOCTYPE x [<!ENTITY e SYSTEM "file:///etc/passwd">]><hierarchy>&e;</hierarchy>` | `parse` lança `IllegalStateException` (senão `AssertionError("DOCTYPE deveria ser rejeitado")`) |
| 12 | `hitTestEscolheMenorAreaSobOPonto` | `Inspetor.noEm(SETTINGS, 540, 594, false)` | não vazio; seus `bounds` contêm o ponto; nenhum `bounds="…"` do XML que contém o ponto tem área menor |
| 13 | `hitTestForaDaTelaDevolveVazio` | `noEm(SETTINGS, 5000, 5000, false)` | vazio |
| 14 | `hoverNoMesmoNoReaproveitaODetalhe` | `new Hierarquia(SETTINGS, false)`; `m = h.noEm(540, 594)` | `assertSame(m, h.noEm(x1, y1))` (canto do mesmo nó); `assertNotSame(m, h.noEm(5000, 5000))` |
| 15 | `larguraDaTelaVemDoPrimeiroNoComBounds` | `Inspetor.larguraTela(SETTINGS, false)` | `1080` |
| 16 | `montarByCadaEstrategiaVaiPraSuaFabrica` | cada uma das 7 estratégias | `montarBy(e, v).toString()` igual ao `toString()` da fábrica `AppiumBy` correspondente; e `ios predicate` ≠ `ios class chain` |
| 17 | `montarByEstrategiaDesconhecidaLanca` | `montarBy("css", "a")` | `IllegalArgumentException` |

A linha `[Fatal Error] :1:31: DOCTYPE fica desativado…` no console vem do teste 11 e é esperada.

### tools/MapeadorElementosTest — 14 testes

Strings abaixo são o **valor Java resultante** (não o literal do código-fonte). `LF` = quebra de linha real.

| # | Nome | Chamada | Esperado |
|---|---|---|---|
| 1 | `anotacaoAndroidId` | `snippet(ANOTACAO, "id", "br.app:id/botao", false)` | `@AndroidFindBy(id = "br.app:id/botao")` LF `private WebElement elemento;` |
| 2 | `anotacaoIosAccessibility` | `snippet(ANOTACAO, "accessibility id", "botao", true)` | `@iOSXCUITFindBy(accessibility = "botao")` LF `private WebElement elemento;` |
| 3 | `byAndroidAccessibility` | `snippet(BY, "accessibility id", "botao", false)` | `AppiumBy.accessibilityId("botao")` |
| 4 | `byXpath` | `snippet(BY, "xpath", "//android.widget.Button[1]", false)` | `AppiumBy.xpath("//android.widget.Button[1]")` |
| 5 | `valorSoDevolveOValorCru` | `snippet(VALOR, "id", "br.app:id/botao", false)` | `br.app:id/botao` |
| 6 | `escapaAspasEBarraNoLiteralJava` | `snippet(BY, "xpath", //*[@text="ok"], false)` | `AppiumBy.xpath("//*[@text=\"ok\"]")` |
| 7 | `escapaQuebraDeLinhaNoLiteralJava` | `snippet(BY, "xpath", linha1 LF linha2, false)` | `AppiumBy.xpath("linha1\nlinha2")` (barra + n, literais) |
| 8 | `parseByColado` | `parseLocator` de `AppiumBy.id("br.app:id/botao")` e de `AppiumBy.accessibilityId("ok")` | `{id, br.app:id/botao}` e `{accessibility id, ok}` |
| 9 | `parseAnotacaoColadaIgnoraORestoDoTexto` | `@AndroidFindBy(id = "br.app:id/botao")` LF `private WebElement elemento;` e `@iOSXCUITFindBy(accessibility = "ok")` LF `private WebElement elemento;` | `{id, br.app:id/botao}` e `{accessibility id, ok}` |
| 10 | `parseDesescapaAspasEQuebraDeLinha` | `AppiumBy.androidUIAutomator("new UiSelector().text(\"x\")")` e `AppiumBy.xpath("a\nb")` | `{-android uiautomator, new UiSelector().text("x")}` e `{xpath, a LF b}` |
| 11 | `parseIdaEVoltaComOSnippet` | valor `//*[@text="a\b"]` LF `fim`; `parseLocator(snippet(BY,…))` e `parseLocator(snippet(ANOTACAO,…))` | as duas voltam `{xpath, <valor original>}` |
| 12 | `parseForaDoPadraoDevolveNull` | `//*[@id='x']` e `AppiumBy.metodoQueNaoExiste("x")` | `null` nos dois |
| 13 | `cruComBarraViraXpathIgnorandoOCombo` | `estrategiaDoCru` com (`//android.widget.Button`, `accessibility id`), (`/hierarchy/android.widget.FrameLayout`, `id`), (`br.app:id/botao`, `id`), (`android.widget.Button`, `class name`) | `xpath`, `xpath`, `id`, `class name` |
| 14 | `estrategiaDesconhecidaCaiComoXpath` | `snippet(BY, "desconhecida", "//x", false)` | `AppiumBy.xpath("//x")` |


## Anexo 11

## 11 — Spec: documentação, padrões e ADRs do projeto

Tudo aqui é **texto** do projeto gerado (Markdown). Escrever em pt-BR.

### CLAUDE.md (raiz) — seções obrigatórias, nesta ordem

Primeira linha `# CLAUDE.md` + frase "This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository."

1. **`## O que é este repositório`** — projeto base de automação mobile do time: Java 25 + Appium 3 + Cucumber 8 + Allure 3, Android (UiAutomator2) e iOS (XCUITest) com o mesmo código. App default = Settings do Android (`com.android.settings`/`.Settings`); iOS = `com.apple.Preferences`; trocar de app = só config ou constantes do `RodarPorTag`. Padrões de suíte real em `docs/padroes-suite-real.md`.
2. **`## Comandos`** — bloco bash com: `mvn -q -DskipTests test-compile`; `mvn test -Dplatform=android`; `mvn test -Dplatform=ios`; `mvn test -Dcucumber.filter.tags="@smoke"`; `mvn test -Dcucumber.features=src/test/resources/features/ajustes.feature`; `mvn test -Dtest=InspetorTest`; `mvn test -Dtest=MapeadorElementosTest`; `mvn -q test-compile exec:java`. Depois um parágrafo sobre o ▶ do `RodarPorTag` (constantes, `System.setProperty` antes do `Config`, `-D` ganha, sobe emulador+Appium via `Ambiente.garantirNoAr()`, dry-run não sobe nada). Depois os pré-requisitos por execução via Maven (exports de `JAVA_HOME`/`PATH`/`ANDROID_HOME`, `appium`, `emulator -avd`, `adb devices`), e a nota de que `emulator`/`adb` não estão no PATH e que qualquer chave do config é sobreposta por `-Dchave=valor`.
3. **`## Arquitetura`** — diagrama `feature → steps → screens → core` e as 5 fronteiras (só `core` importa Appium/Selenium; steps nunca tocam driver; screens não expõem locators; um Page Object para as duas plataformas via `@AndroidFindBy` + `@iOSXCUITFindBy`; driver só no `ThreadLocal`). Camada `tools/`. Ponteiro para `standards/` (ADR 0002 substituído pelo 0004).
4. **`## Pegadinhas`** — uma linha por lição de Anexo 02 dos grupos A, B, F e G (PageFactory do Appium; glue na raiz; Selenium pinado; `ANDROID_HOME` no shell do appium com a mensagem de erro exata; Jackson; `# language: pt`; `@SelectPackages`; Surefire só `Run*Test`; `exec:java` não compila; ThreadLocal × Mapeador; `create(false)`; `/appium/sessions` e `--allow-insecure=*:session_discovery`; `Ambiente` via `/bin/zsh -ic`, macOS only; relatório Allure único e onde fica; adapter shafthq; CLI via `npx` e não rodar `allure generate` à mão; evidência via `scenario.attach`, vídeo em Desmontagem, ~22 MB; app nasce vazio; locator de app de sistema é frágil).
5. **`## Rotina obrigatória de documentação`** — **texto exato**:

```
Toda sessão que adicionar ou mudar feature/automação **deve, antes de encerrar**:

1. **`docs/features/<feature>.md`** — criar ou atualizar: o que automatiza, cenários, pré-condições, dados usados, locators sensíveis, pendências conhecidas.
2. **`plans/NNNN-<slug>.md`** — copiar o plano de execução **para dentro do repo**, com status no topo (`proposto` | `implementado`). Plan mode grava em `~/.claude/plans/`, **fora** do repositório: aquele arquivo não é histórico, o repo é a fonte da verdade. Numeração sequencial, nunca reaproveitar número.
3. **Plano aprovado ≠ plano implementado.** Plano novo nasce `proposto` e fica esperando: **não implementar nada até o usuário pedir explicitamente**.
4. **`standards/`** — mexer só quando o padrão em si mudar, e aí registrar um ADR novo em `standards/decisions/NNNN-<slug>.md`.
```

6. **`## Fora de escopo até pedido explícito`** — "CI, execução paralela, grid/cloud (BrowserStack, Sauce), massa de dados externa. Cada um vira um plano em `plans/` antes de virar código."

### README.md (raiz)

Seções: título "Automação Mobile — Java + Appium + Cucumber + Allure"; **Stack** (tabela de versões: Java 25, Maven 3.9+, Node 20.19+, Appium 3.9.0 + uiautomator2 8.7.3, java-client 11.0.0, Selenium 4.52.0 pinado, Cucumber 8.0.4, JUnit Platform 6.1.3, Allure adapter/commons/CLI); **Setup** (JAVA_HOME, `npm i -g appium@3.9.0`, drivers); **Rodando** (▶ recomendado; Maven em 3 abas); **Relatório** (HTML único, `resumo.md`, histórico, `-Dvideo.enabled=false`); **Mapeador de elementos** (o que faz, 2 comandos); **Estrutura** (árvore de pastas com uma linha por pasta e as classes de cada pacote).

### standards/

#### standards/README.md
Tabela: `architecture.md` (camadas, fronteiras, imports), `code-style.md` (nomes, Gherkin, waits, asserts), `decisions/` (ADRs). Regra: mexer só quando o padrão muda, com ADR novo.

#### standards/architecture.md
- Diagrama vertical: feature → steps → screens → core → Appium Server → device; `tools` ao lado (só chama core). Dependência sempre para baixo.
- Tabela "O que cada camada pode / não pode":

| Camada | Pode | Não pode |
|---|---|---|
| `core` | importar Appium/Selenium, ler `config/`, criar/destruir driver, capturar evidência | conhecer feature, screen ou step |
| `screens` | declarar locators, estender `BaseScreen`, usar `wait` | `System.out`, assert, conhecer step/feature |
| `steps` | chamar screens, assertar | `driver.findElement`, locator, `By`, `Thread.sleep` |
| `runner` | configurar a suíte | lógica de teste |
| `tools` | chamar `core`, Swing/JDK, gravar em `docs/` | importar `io.appium`/`org.openqa`, ser chamada por outras camadas, guardar driver |

- Regras duras numeradas (as 6): só core importa Appium/Selenium (exceção: screens importam as anotações e `WebElement`, e a `BaseScreen` importa também `AppiumDriver`/`AppiumFieldDecorator`/`PageFactory`/`WebDriverWait`/`ExpectedConditions`; `Evidencias` é a única classe de core além de DriverFactory/DriverManager que toca `CanRecordScreen`/`TakesScreenshot`); steps não tocam driver; screen expõe comportamento; um Page Object para as duas plataformas (divergiu demais → subclasse, nunca `if (android)`); driver em ThreadLocal, nenhum outro estático mutável (exceção documentada: `Inspetor`, ADR 0003); `BaseScreen` resolve o PageFactory.
- Seção "Por que não hexagonal, saga, DDD": não há domínio de negócio, o repo inteiro é um adaptador que conversa com device; a fronteira que paga é "o teste não sabe como o device é dirigido" (core × resto); o equivalente local de saga é o `@After` garantindo `quit()`. Revisitar se surgir lógica própria.
- Tabela "Pontos de extensão": nova plataforma → `DriverFactory`; cloud → `serverUrl` + capabilities; nova tela → `screens/` estendendo `BaseScreen`; novo relatório → `cucumber.plugin`; evidência → `Evidencias`/`ResumoMarkdown`/`Hooks`; ferramenta de dev → `tools/` via `core`; execução paralela → `cucumber.execution.parallel.enabled` (o ThreadLocal já suporta).

#### standards/code-style.md
- **Nomes**: pacote raiz `br.com.automacao`, pastas = camadas; `<Tela>Screen`, `<Feature>Steps`, `Run*Test`; feature, doc e steps compartilham o slug; identificadores em português quando descrevem negócio (`abrirWifi`, `estaVisivel`), termo técnico no original.
- **Gherkin**: `# language: pt` na 1ª linha sempre; cenário descreve comportamento observável, não clique; sem detalhe técnico no `.feature`; tags `@smoke`, `@regressao`, `@android`, `@ios`; um `Dado` de contexto por cenário (preparo grande → `Contexto:` ou step composto).
- **Esperas**: `Thread.sleep` proibido em steps e screens (único uso aceito: polling de processo/HTTP no `core/Ambiente`); espera explícita via `BaseScreen.visivel/clicar`; timeout de `waitSeconds`; nunca implicit + explicit juntos.
- **Asserts**: só em steps, `org.junit.jupiter.api.Assertions`, sempre com mensagem do que se esperava; screen devolve estado, nunca assertiva.
- **Configuração**: nada hardcoded em Java; `Config.get` falha alto; `-D` ganha do arquivo.
- **Dependências**: versão pinada, nunca range/LATEST; `selenium-java` pinado por causa do range; dependência nova que muda o jeito de escrever teste entra com ADR.
- **Clean Code adotado** (4 regras): nome revela intenção; função curta, um nível de abstração; comentário só para o não óbvio ("por quê"); falhar alto e cedo (`Config.get`, `DriverManager.get`). Sem abstração especulativa, sem interface com uma implementação.

#### standards/decisions/ (ADRs)

Formato: `# ADR NNNN — <título>`, `**Data:**` (a data de hoje), `**Status:**`, seções `## Contexto`, `## Decisão`, `## Consequências`, `## Alternativas descartadas`.

- **0001 — Stack inicial: Maven, Appium, Cucumber, Page Object** (aceito). Decisão: Maven (ecossistema documenta em Maven); Appium + java-client 11, Appium Server 3.9.0; Cucumber 8 sobre JUnit Platform 6 (engine, não runner JUnit 4); Page Object + Steps, não Screenplay (multiplicaria classes antes de haver reuso); locators das duas plataformas no mesmo campo; exemplo no app de Ajustes do sistema. Consequências: PageFactory do Appium; Selenium pinado; Jackson explícito; iOS configurado mas dependente de Xcode; Gherkin pt amarra ao dialeto. Descartadas: Gradle, Screenplay/Serenity, Espresso/XCUITest nativos.
- **0002 — Evidências nativas sem Allure** — status **substituído pelo 0004**. Registrar só o resumo: formatters nativos do Cucumber + arquivos soltos por cenário; trocado porque gerava dezenas de arquivos (ruim para GMUD) e nenhum histórico.
- **0003 — Camada `tools` para utilitários de desenvolvimento, com `Inspetor` em `core`** (aceito). Decisão: `tools/` fora do pipeline, pode chamar core, não importa Appium; `core/Inspetor` é a ponte e devolve records de String; Inspetor não usa DriverManager (ThreadLocal × thread do executor), driver em campo de instância tocado por um único executor; `scheduleWithFixedDelay` + try/catch por tick. Consequências: `exec-maven-plugin` com `classpathScope=test`, `exec:java` não compila; exceção documentada à regra do estático; `tools/` está no glue mas sem anotação Cucumber é ignorado. Descartadas: tools importando Appium; reusar DriverManager; Appium Inspector oficial (não deixa registro versionado).
- **0004 — Relatório único com Allure 3, vídeo embutido e histórico** (aceito, substitui 0002). Decisão: Allure 3 CLI `allure@3.22.1`, plugin `awesome` `singleFile`; adapter `io.github.shafthq:allure-cucumber8-jvm` (oficial dá `NoSuchMethodError`, `Location.getLine()` Long→int; PR allure-java#1455); `allure-java-commons:3.0.1` à mão; evidência vira anexo (`scenario.attach`); geração dentro da JVM no `RelatorioAllure` (vale para ▶ e com teste falhando); histórico em `evidencias/historico-allure.jsonl`; formatters `html:`/`json:` removidos, `ResumoMarkdown` fica. Consequências: Node/npm no host, macOS only; adapter não oficial pinado; ~22 MB por smoke; não gerar à mão; vídeo em Desmontagem. Descartadas: Cucumber 7 + adapter oficial; fase Maven pós-test (não roda se o teste falha, não cobre o ▶); manter formatters nativos em paralelo.

### docs/

#### docs/README.md
"Uma página por feature automatizada, em `features/<slug>.md`, com o mesmo slug do `.feature`. Atualizar sempre que a automação mudar — regra em `CLAUDE.md`." + **Índice** (tabela Feature | Arquivo | Plataformas | Status) com as 3 páginas abaixo + seção "Relatórios de mapeamento" (`mapeamento/` guarda os `.md` do Mapeador, **é versionado**, diferente de `evidencias/`) + **Template**:

```markdown
# <Nome da feature>

**Arquivo:** `src/test/resources/features/<slug>.feature`
**Screens:** `<Nome>Screen.java`
**Steps:** `<Nome>Steps.java`
**Plataformas:** Android / iOS

## Objetivo
## Pré-condições
## Cenários
| Cenário | Tags | O que valida |
|---|---|---|
## Locators sensíveis
## Pendências
```

#### docs/features/ajustes.md
Pelo template: smoke do próprio framework contra o Settings nativo (sem APK); pré-condições (Appium com `ANDROID_HOME`, device `device` no `adb devices`, app `com.android.settings/.Settings`, iOS `com.apple.Preferences`); cenário "Abrir a tela de Ajustes" com tags `@smoke @ajustes`; locators sensíveis (o `resource-id` do Settings muda por versão/fabricante — alternativa `uiAutomator` `textContains("Settings")`; iOS `accessibility = "Settings"` depende do idioma, em pt-BR é "Ajustes"); pendências (iOS depende de Xcode completo; idioma do device não é fixado).

#### docs/features/evidencias.md
Infra não Gherkin (`Evidencias`, `Hooks`, `RelatorioAllure`, `ResumoMarkdown`; ADR 0004). Seções: **O que gera** (árvore `evidencias/historico-allure.jsonl` + `<timestamp>/resumo.md` + `<timestamp>/relatorio-allure/index.html` — o anexo da GMUD é só o `index.html`; pela IDE vai para `evidencias/relatorio-allure/` e sobrescreve); **Como funciona** (Cucumber → AllureCucumber8Jvm → `target/allure-results`; Hooks anexam png/mp4; `RelatorioAllure` no fim roda `npx allure generate`); pinos; **Pegadinhas** (não gerar à mão; vídeo em Desmontagem; ~22 MB; adapter não oficial; timestamp UTC); **Compressão do vídeo** (tabela das chaves `video.*` com defaults Android/iOS e efeito; `video.quality` aceita `LOW`/`MEDIUM`/`HIGH`/`PHOTO`); **Pendências** (iOS não testado; teto de 180 s; sem limpeza automática — `find evidencias -maxdepth 1 -mtime +7 -type d -name '20*' -exec rm -rf {} +`, sem apagar o histórico); **Plataforma e app no relatório** (`environment.properties`; exibição no Allure 3 ainda a confirmar, alternativa `--report-name`).

#### docs/features/mapeador-elementos.md
Ferramenta (não Gherkin). Seções: o que é; como rodar (pré-requisitos + `mvn -q test-compile exec:java` + `mvn test -Dtest=InspetorTest`); passo a passo de uso (Conectar → Scanear/Inspecionar → hover/clique congela → clique direito copia → Testar → Stop grava em `docs/mapeamento/`); como o locator é escolhido (prioridade, unicidade no snapshot, absoluto como último recurso); assinatura de tela; config `mapeador.*`; limitações (iOS não testado, heurística de filtro, Appium 3 `/appium/sessions`).

#### docs/padroes-suite-real.md
Conteúdo de Anexo 12 (padrões de suíte real), com o título "Padrões de uma suíte real".

#### docs/mapeamento/.gitkeep
Arquivo vazio (a pasta é versionada).

### plans/README.md

"Histórico de tudo que foi planejado neste repositório. Este diretório é a fonte da verdade — Claude Code grava planos em `~/.claude/plans/`, fora do repo." **Convenção**: `NNNN-<slug>.md`, 4 dígitos sequenciais, nunca reaproveitar; cabeçalho obrigatório (`# <Título>`, `**Status:** proposto | implementado`, `**Data:** AAAA-MM-DD`, `**Implementado em:** AAAA-MM-DD (ou "—")`); nasce `proposto`, vira `implementado` só quando o código entra; plano aprovado não autoriza implementação. **Índice** (tabela # | Plano | Status) com a linha `0001 | Setup inicial do projeto base | implementado`.

#### plans/0001-setup-inicial.md
Criado no fim do setup: cabeçalho com status `implementado` e a data; resumo do que foi construído por fase e o resultado de cada gate (G0–G8), pendências (ex.: iOS sem Xcode).


## Anexo 12

## 12 — Padrões de uma suíte real (gabarito de estilo, sem código)

O projeto de origem tem uma suíte de smoke de um app de podcasts ("Ecoo", Android) com 5 telas. Ela **não** faz parte do projeto base; serve de modelo de como escrever Page Object/steps/feature para o app do time. Use estes padrões na fase F7 (Anexo 05).

### Estrutura

- Uma `Screen` por aba/tela: `InicioScreen`, `DescobrirScreen`, `BibliotecaScreen`, `RadioScreen`, `AjustesEcooScreen` (nome distinto de `AjustesScreen`, que é o Settings do sistema).
- Uma classe de steps por app (`EcooSmokeSteps`), com campos `private final <Tela>Screen` para cada tela. O driver já existe quando a classe é instanciada (Cucumber cria uma instância por cenário, depois do `@Before`).
- Uma feature por fluxo, todas `@smoke`, cada uma com o mesmo `Dado` de contexto ("que o aplicativo X foi aberto"), que valida um texto presente tanto na home vazia quanto na populada.

### Forma de cada Screen

- Campos `private WebElement` anotados; um por elemento que o fluxo usa.
- Métodos públicos de negócio, curtos: `abrir()` (toca a aba), `estaVisivel()` (título da tela visível), uma ação (`tocarPrimeiraRadio()`, `abrirPrimeiroPodcast()`), e uma verificação de estado que devolve `boolean` (`playerAberto()`, `detalheDoPodcastAberto()`, `temAssinatura()`).
- Sempre via `visivel(...)` / `clicar(...)` da `BaseScreen`.
- Comentário curto acima do locator **quando** ele é escolhido por posição ou por um motivo não óbvio.

### Locators usados (Android, por ordem de preferência)

1. `accessibility` (content-desc) estável: títulos de tela, botões com rótulo ("Assinar", "Todos").
2. `uiAutomator` com `descriptionStartsWith`/`descriptionContains` + `className` quando o content-desc tem sufixo variável. Ex.: abas inferiores têm content-desc `"Início\nTab 1 of 5"` → `descriptionStartsWith("Início").className("android.widget.Button")`.
3. Posição/slot para dado ao vivo (ver abaixo).
4. `xpath` só em último caso.

### Dado ao vivo: selecionar por slot, nunca por nome

Catálogo e listas reordenam entre execuções. Escolher pelo **lugar**, não pelo título:
- 1º do ranking: `descriptionStartsWith("1")`.
- 1ª rádio: `descriptionContains("FM")` (primeira ocorrência).
- 1º episódio: `descriptionContains("•")` (toda linha traz "• <data>").

### App nasce vazio: seed no próprio cenário

UiAutomator2 faz `pm clear` por sessão: sem assinaturas, sem histórico. Fluxo que depende de dado do usuário cria o dado no próprio cenário, com um método de seed reutilizável numa screen (ex.: `DescobrirScreen.assinarPrimeiroPodcast()`: abre a aba, entra no 1º podcast, espera o feed carregar, toca "Assinar", confirma o marcador "Assinado, toque pra cancelar"). No Gherkin vira um `E que assinei um podcast em Descobrir`.

### Tela carregando (skeleton) ignora toque

O botão existe e está "clicável", mas o app ignora o toque enquanto a tela está em skeleton — `elementToBeClickable` não protege. Antes de tocar, esperar `visivel(...)` de um elemento que **só existe com a tela carregada** (ex.: o chip "Todos"). Depois de tocar, esperar o estado novo (marcador "Assinado…") para confirmar que a ação aplicou.

### Escolha do que testar

Testar o que o estado limpo permite: "Continuar ouvindo" exige progresso real de reprodução, então o smoke de Início usa "Novos episódios" (aparece só com assinatura, que o seed cria).

### Cenários do modelo (para inspiração)

| Feature | Fluxo | Asserção |
|---|---|---|
| Início | assina 1 podcast → Início lista "Novos episódios" → abre o 1º | detalhe do episódio com "Abrir player" |
| Descobrir | abre Descobrir → abre o #1 do ranking | detalhe com botão "Assinar" |
| Biblioteca | assina 1 podcast → abre Biblioteca | existe botão "Desassinar …" |
| Rádio | abre Rádio → toca a 1ª rádio | player com SeekBar "Volume" |
| Ajustes do app | abre Ajustes → toca "Escuro" | botão "Escuro" com `selected=true` |


## Anexo SH — verificar-maquina.sh

Grave exatamente este conteúdo num arquivo `verificar-maquina.sh` (fora do projeto) e rode com `zsh verificar-maquina.sh <avd>`.

````zsh
#!/bin/zsh
# Checa se a máquina está pronta pro projeto base de automação mobile.
# Só verifica — não instala nem altera nada. Uso: zsh verificar-maquina.sh [nome-do-avd]
# Sai com 0 se tudo obrigatório está ok, 1 se algo falta.

AVD="${1:-Pixel_6}"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
falhas=0

ok()    { print -P "%F{green}✔%f $1"; }
falha() { print -P "%F{red}✘%f $1\n    → $2"; falhas=$((falhas+1)); }
aviso() { print -P "%F{yellow}!%f $1\n    → $2"; }

[[ "$(uname)" == "Darwin" ]] && ok "macOS" || falha "Não é macOS" "core.Ambiente usa zsh/lsof: o projeto base é macOS only"

command -v brew >/dev/null && ok "Homebrew" || falha "Homebrew ausente" "ver 01-maquina.md, passo 1"

JDK25="$(brew --prefix openjdk@25 2>/dev/null)/libexec/openjdk.jdk/Contents/Home"
if [[ -x "$JDK25/bin/java" ]] && "$JDK25/bin/java" -version 2>&1 | grep -q 'version "25'; then
  ok "JDK 25 em $JDK25"
else
  falha "JDK 25 ausente" "brew install openjdk@25"
fi

if command -v mvn >/dev/null; then
  JAVA_HOME="$JDK25" mvn -v 2>/dev/null | grep -q 'Java version: 25' \
    && ok "Maven $(mvn -v 2>/dev/null | head -1 | awk '{print $3}') rodando com Java 25" \
    || falha "Maven não roda com Java 25" "export JAVA_HOME=\"\$(brew --prefix openjdk@25)/libexec/openjdk.jdk/Contents/Home\""
else
  falha "Maven ausente" "brew install maven"
fi

# Igual ao core.Ambiente: appium e npx são procurados num zsh interativo (o nvm só entra pelo .zshrc).
NODE_V="$(/bin/zsh -ic 'node -v' 2>/dev/null | tail -1)"
if [[ "$NODE_V" =~ ^v([0-9]+)\.([0-9]+) ]] && (( match[1] > 20 || (match[1] == 20 && match[2] >= 19) )); then
  ok "Node $NODE_V (visto pelo zsh -ic)"
else
  falha "Node >= 20.19 não encontrado via zsh -ic (achado: '${NODE_V:-nada}')" "nvm install 20 e carregar o nvm no ~/.zshrc"
fi

APPIUM_V="$(/bin/zsh -ic 'appium --version' 2>/dev/null | tail -1)"
[[ "$APPIUM_V" == 3.* ]] && ok "Appium $APPIUM_V (visto pelo zsh -ic)" \
  || falha "Appium 3 não encontrado via zsh -ic (achado: '${APPIUM_V:-nada}')" "npm i -g appium@3.9.0 (com o nvm ativo)"

DRIVERS="$(/bin/zsh -ic 'appium driver list --installed' 2>&1)"
print -r -- "$DRIVERS" | grep -q 'uiautomator2' && ok "driver uiautomator2" \
  || falha "driver uiautomator2 ausente" "appium driver install uiautomator2"
print -r -- "$DRIVERS" | grep -q 'xcuitest' && ok "driver xcuitest" \
  || aviso "driver xcuitest ausente (só necessário pra iOS)" "instalar Xcode completo e: appium driver install xcuitest"

/bin/zsh -ic 'command -v npx' >/dev/null 2>&1 && ok "npx (gera o relatório Allure)" \
  || falha "npx não encontrado via zsh -ic" "vem com o Node do nvm"

[[ -n "$ANDROID_HOME" ]] && ok "ANDROID_HOME=$ANDROID_HOME" \
  || aviso "ANDROID_HOME não exportado neste shell" "export ANDROID_HOME=\$HOME/Library/Android/sdk no ~/.zshrc (o ▶ cai no default, mas appium na mão precisa)"

[[ -x "$SDK/platform-tools/adb" ]] && ok "adb em $SDK/platform-tools" \
  || falha "adb não encontrado em $SDK/platform-tools" "Android Studio > SDK Manager > Android SDK Platform-Tools"

if [[ -x "$SDK/emulator/emulator" ]]; then
  ok "emulator em $SDK/emulator"
  if "$SDK/emulator/emulator" -list-avds 2>/dev/null | grep -qx "$AVD"; then
    ok "AVD $AVD existe"
  else
    falha "AVD '$AVD' não existe (existentes: $("$SDK/emulator/emulator" -list-avds 2>/dev/null | tr '\n' ' '))" \
      "criar no Device Manager do Android Studio, ou passar o nome certo: zsh verificar-maquina.sh <avd> e ajustar deviceName em config/android.properties"
  fi
else
  falha "emulator não encontrado em $SDK/emulator" "Android Studio > SDK Manager > Android Emulator"
fi

xcodebuild -version >/dev/null 2>&1 && ok "Xcode $(xcodebuild -version | head -1 | awk '{print $2}')" \
  || aviso "Xcode completo ausente (só necessário pra iOS)" "App Store > Xcode, depois: sudo xcode-select -s /Applications/Xcode.app"

print ""
(( falhas == 0 )) && print -P "%F{green}Máquina pronta.%f" || print -P "%F{red}$falhas item(ns) obrigatório(s) faltando.%f"
exit $(( falhas > 0 ))
````

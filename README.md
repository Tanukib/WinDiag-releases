# WinDiag

Diagnóstico e reparo de **hardware, discos e drivers** no Windows, em um único script PowerShell, sem instalar nada.

O WinDiag foi pensado para achar o que o diagnóstico padrão do Windows **não mostra**: o Gerenciador de Dispositivos só marca um driver como problema quando ele dá erro na hora. Muitos defeitos reais ficam escondidos (driver de vídeo trocado pelo Windows Update, driver genérico, driver sem assinatura, driver que falhou ao iniciar, disco que já acumula erros, telas azuis recorrentes). O WinDiag cruza essas fontes e entrega um relatório com o que fazer, links para baixar o driver certo e, com a sua permissão, restaura o que for possível.

> **Aviso:** use por sua conta e risco. O script só altera algo depois de você confirmar cada ação, mas mexer em drivers e discos sempre tem risco. Mantenha backup dos seus arquivos.

## O que ele faz

| Área | O que é verificado | O Windows mostra isso? |
|---|---|---|
| Hardware | Processador, memória (módulos, tipo, velocidade, canal único, RAM utilizável x instalada), placa(s) de vídeo, placa-mãe, BIOS/UEFI, Secure Boot, TPM, rede (velocidade negociada), áudio, monitores, bateria (saúde e ciclos), temperatura, inventário de dispositivos | Espalhado por vários lugares |
| Discos | Saúde, temperatura, desgaste do SSD, horas de uso, erros de leitura/escrita **não corrigidos**, previsão de falha SMART | Só o status geral |
| Volumes | Espaço livre e varredura online de erros (NTFS/ReFS) | Parcialmente |
| Eventos (últimos N dias) | Falhas de I/O, corrupção NTFS, resets do controlador NVMe/SATA, erros de hardware (WHEA), travamentos do driver de vídeo, desligamentos inesperados, **telas azuis com o código e a causa provável**, drivers bloqueados ou que não carregaram | Espalhado pelo Visualizador de Eventos |
| Drivers com erro | Dispositivos com código de erro, com explicação em português e o que fazer | Só o código |
| Drivers "escondidos" | Vídeo com driver genérico, drivers sem assinatura, drivers de terceiros antigos, drivers de sistema que falharam ao iniciar, instalações de driver que falharam (`setupapi.dev.log`) | **Não** |
| Driver de vídeo sobrescrito | Compara o driver em uso com os pacotes do fabricante já guardados no sistema e com o histórico do Windows Update | **Não** |
| Windows Update | Drivers pendentes (você escolhe quais instalar), reinicialização pendente, data da última atualização instalada, serviço desativado | Só nas atualizações opcionais |
| Telas azuis | Lê os arquivos da pasta `C:\Windows\Minidump` e mostra os códigos de erro mais frequentes, com a causa provável | **Não** |
| Segurança | Antivírus ativo e atualizado, firewall | Na Segurança do Windows |
| Espaço e desempenho | Arquivos temporários (e limpeza), programas na inicialização, saúde da bateria dos notebooks | Espalhado |
| Rede | Teste de conexão e de DNS (só se a opção de usar a internet estiver marcada) | Não |
| Comparação | Mostra o que é novo, o que foi resolvido e o que continua desde a verificação anterior | **Não** |
| Links | Microsoft Update Catalog (busca pelo ID do hardware), página do fabricante do componente e suporte do fabricante do computador | Não |
| Relatórios | HTML (claro/escuro), JSON e log completo, incluindo as alterações feitas | Não |

## Como usar

### Para quem não é da área (interface gráfica)

1. Baixe o repositório (Code > Download ZIP) e **extraia o ZIP inteiro** (não rode de dentro do ZIP).
2. Dê duplo clique em **`Abrir-WinDiag.bat`** (só na primeira vez: ele cria sozinho o atalho com o ícone do escudo na Área de Trabalho e no Menu Iniciar). O WinDiag já pede direto a permissão de administrador do Windows: clique em Sim no aviso (se recusar, ele abre só para verificação e não corrige).
3. Clique em **Verificar meu computador** e aguarde (2 a 10 minutos).
4. A tela de resultado mostra, em linguagem comum, o que foi encontrado, o que fazer e links de download. A aba **Meu computador** lista o seu hardware e a aba **Detalhes técnicos** mostra tudo o que foi feito.
5. Se houver correções automáticas, clique em **Corrigir automaticamente**. Cada correção abre uma caixa de confirmação e só acontece se você aceitar; drivers internos exigem digitar `RESTAURAR`.

A aba **Meu computador** mostra cartões (computador, processador, memória, vídeo, placa-mãe, discos, rede, monitores e bateria), com barras de uso do espaço nas unidades e indicadores de cor para a saúde dos discos. Em janelas largas os cartões ficam em duas colunas. O visual é claro e minimalista: cartões com uma barra lateral colorida pela gravidade (vermelho, laranja, cinza), abas com sublinhado, barra de progresso fina e tempo decorrido. Na tela de resultados há um filtro por categoria (Drivers, Eventos, Discos...), o botão **Copiar resumo** (para colar em um fórum ou mandar a alguém) e, em **Configurações**, o atalho para a pasta das verificações anteriores. A tecla Enter inicia a verificação.

Cada problema tem um botão **Ver mais**, que explica em linguagem simples o que aquilo é (por exemplo, que o `vgk` é o anti-cheat do VALORANT/LoL e que o `dam` é um componente de economia de energia da Microsoft) e se vale mesmo mexer: *Provavelmente normal*, *Depende*, *Vale corrigir* ou *Opcional*. Para drivers de sistema desconhecidos, o WinDiag confere se o arquivo ainda existe (se não existe, é resto de um programa desinstalado). As explicações são orientações gerais, não um diagnóstico definitivo. O mesmo texto aparece no relatório HTML.

Ao clicar em **Corrigir**, você escolhe: **Perguntar a cada uma** (decide correção por correção) ou **Aceitar tudo** (o WinDiag executa tudo sem interromper, criando antes o ponto de restauração e a cópia dos drivers). No modo "aceitar tudo", os drivers internos do sistema (chipset, armazenamento, processador) são sempre pulados e a instalação de drivers pelo Windows Update não é feita; tudo fica registrado no log.

Durante a verificação a janela mostra o **tempo decorrido** e uma **estimativa do tempo restante**. A estimativa começa com valores médios e melhora a cada verificação: o WinDiag guarda quanto cada etapa levou no seu computador (em `%LOCALAPPDATA%\WinDiag\tempos.json`, só números) e ajusta pela velocidade da máquina na própria verificação. Nos reparos, o DISM e o SFC informam o percentual: a tela mostra "Tarefa atual: N%" e o "Tempo restante estimado desta tarefa" (calculado pela velocidade já observada; vale só para a tarefa em andamento, pois o total depende das suas confirmações). O log mostra uma linha a cada 10%, em vez de centenas de linhas de progresso.

A janela não trava durante a verificação: o diagnóstico roda em segundo plano. Fechar a janela no meio de um reparo pede confirmação, porque pode deixá-lo pela metade.

### Para quem prefere o console

Dê duplo clique em **`Executar-WinDiag.bat`** (pede administrador sozinho) ou, em um PowerShell:

```powershell
# Só diagnosticar, sem oferecer nenhuma alteração
powershell -ExecutionPolicy Bypass -File .\WinDiag.ps1 -SomenteLeitura
```

Cada verificação ganha a sua própria pasta, dentro de `WinDiag` na Área de Trabalho: `Verificacao_AAAA-MM-DD_HH-mm-ss`. Nela ficam o relatório HTML, o JSON, o log e, se você pedir, a cópia dos drivers e os pacotes removidos. Os reparos feitos depois de uma verificação atualizam o relatório dessa mesma pasta. Vale nas duas versões (janela e console).

### Parâmetros (versão de console)

| Parâmetro | Efeito |
|---|---|
| `-SomenteLeitura` | Apenas diagnostica; não oferece reparos |
| `-SemWindowsUpdate` | Não consulta o Windows Update (a consulta pode demorar) |
| `-PularScanVolumes` | Pula a varredura de erros nos volumes (mais rápido em discos grandes) |
| `-DiasEventos 60` | Quantos dias de eventos analisar (padrão: 30) |
| `-PastaRelatorio "D:\Relatorios"` | Onde salvar os relatórios |
| `-NaoAbrirRelatorio` | Não abre o HTML ao terminar o diagnóstico |
| `-DesfazerBloqueios` | Remove os bloqueios de driver criados pelo WinDiag e sai |

### Atalho com ícone, atalhos de teclado e outras comodidades

- **Atalho automático:** na primeira abertura, o WinDiag cria sozinho o atalho **WinDiag** (ícone do escudo) na Área de Trabalho e no Menu Iniciar, sem perguntar nada; se você apagar o atalho, ele não volta sozinho (só se a pasta do WinDiag mudar de lugar). Para recriar, use **Configurações** na tela inicial. O `Criar-Atalho.bat` faz o mesmo manualmente, pergunta se deve abrir sempre como administrador e libera os arquivos do ZIP baixado da internet (o "bloqueio" que gera avisos). Para fixar na barra de tarefas, abra pelo atalho e use o botão direito no ícone da barra.
- **Parar com segurança:** durante as correções, o botão **Parar depois desta correção** deixa terminar a que já começou (interromper o DISM, o SFC ou um driver no meio poderia danificar o Windows) e pula as seguintes.
- **Reinício:** ao terminar, o WinDiag verifica se o Windows pede reinício (chaves de reinício pendente no registro) e oferece **Reiniciar agora** ou **Mais tarde**.
- **Desfazer alterações:** restaura a cópia de drivers feita antes das correções (`pnputil /add-driver ... /install`) ou abre a Restauração do Sistema do Windows. Também está em **Ferramentas de reparo > Desfazer o que o WinDiag fez**.
- **Teclado:** `Tab`/`Shift+Tab` navegam, `Ctrl+1/2/3` trocam de aba, `F5` verifica de novo e `F1` mostra a ajuda. Os cartões e abas têm nomes para leitores de tela.
- **Erros da interface** são gravados em `%LOCALAPPDATA%\WinDiag\erros.log` (versão, Windows e pilha de chamadas) e a caixa de erro oferece copiar os detalhes.

## Teste de desempenho (botão "Testar desempenho")

Botão separado da verificação, na tela inicial. Leva de 3 a 4 minutos e não altera nada no computador (só cria um arquivo temporário de até 1 GB no disco, apagado no fim):

- **Resumo**: no topo do relatório, os números principais de cada teste e a diferença para o teste anterior.
- **Processador**: pontuação com um núcleo e com todos os núcleos, queda de desempenho e de **frequência** durante a carga (sinal de superaquecimento ou limite de energia, mesmo sem ler a temperatura) e comparação com o teste anterior. Em Configurações há o **teste longo** (cerca de 3 minutos a mais), que mostra os pontos minuto a minuto.
- **Memória RAM**: usa vários núcleos ao mesmo tempo e até 8 GB (60% da memória livre). Grava e confere 8 padrões (zeros, uns, 1010, 0101, endereço, bit andando, bit andando invertido, pseudoaleatório), faz duas "inversões em movimento" (acham células que não trocam de valor) e uma conferência depois de 6 segundos de espera (acha células que perdem o valor). Mede a velocidade, mostra quanto isso é da velocidade teórica (calculada pelos módulos e canais) e avisa se a memória está em canal simples ou abaixo da velocidade nominal (XMP/EXPO desligado). É uma amostra da memória livre: o Windows não deixa testar o que ele mesmo usa, então para um teste completo use o MemTest86.
- **Disco**: velocidade de escrita e leitura sequencial (sem o cache do Windows), leituras aleatórias de 4 KB (uma de cada vez e com fila de 32), leitura sequencial com fila (a velocidade que o fabricante anuncia), conferência do conteúdo gravado e a saúde informada pelo próprio disco (estado, desgaste do SSD, temperatura e erros sem correção, quando o disco informa).
- **Placa de vídeo**: animação 3D em seis níveis de carga (até cerca de 3,5 milhões de triângulos), medindo quadros por segundo e o pico de milhões de triângulos por segundo (que não depende do limite de 60 quadros do monitor), em um processo separado (se o driver travar, o WinDiag não cai junto). A temperatura vem do `nvidia-smi` nas placas NVIDIA; nas AMD/Intel é lida do driver gráfico do Windows e, se o driver não informar, aparece como "n/d".

Se o Windows já tiver notas guardadas (WinSAT), elas aparecem no fim só para comparar.

Os resultados ficam num relatório HTML na pasta da verificação, e os pontos são guardados em `%LOCALAPPDATA%\WinDiag\bench.json` para comparar com o próximo teste. Os pontos só servem para comparar o computador com ele mesmo.

## Ferramentas de reparo e restauração

O botão **Ferramentas de reparo e restauração** da tela inicial reúne ações que você escolhe uma a uma (cada uma pede confirmação):

- ver, criar e abrir os **pontos de restauração** do Windows;
- **reparar a rede** (DNS, Winsock e IP), o **Windows Update** e a **Microsoft Store**;
- agendar o **CHKDSK** completo do disco do Windows para a próxima reinicialização;
- **limpar arquivos temporários** antigos;
- **copiar seus arquivos pessoais** (Documentos, Imagens e Área de Trabalho) para uma pasta ou pen drive, sem apagar nada;
- ver **o que o WinDiag já mudou neste computador**, com a data e como desfazer cada alteração (o histórico fica em `%LOCALAPPDATA%\WinDiag\alteracoes.jsonl`).

Na tela de resultados também há **Salvar em PDF** (usa o Microsoft Edge ou o Google Chrome já instalados).

## Onde fica cada coisa

- **Tela inicial:** *Verificar meu computador*, *Testar desempenho*, *Ferramentas de reparo* e *Configurações*, mais a última nota de saúde.
- **Ferramentas de reparo:** restauração (pontos de restauração), reparos do Windows (rede, Windows Update, Microsoft Store, CHKDSK), limpeza e backup e *Desfazer o que o WinDiag fez* (histórico de alterações, bloqueios de driver e drivers salvos).
- **Configurações:** opções da verificação (usar a internet, verificar discos, verificação profunda), verificação semanal automática (com escolha de dia e horário), histórico da nota de saúde, pasta das verificações anteriores, procurar atualização e recriar atalho. As escolhas ficam salvas para a próxima vez.

## Nota de saúde e verificação semanal automática

- **Nota de saúde (0 a 100):** cada verificação recebe uma nota. Ela começa em 100 e perde pontos por problema encontrado (12 por crítico, 4 por aviso, e menos quando o aviso costuma ser normal; cada categoria perde no máximo 30). Aparece na faixa de resultado, no relatório e na tela inicial, com a diferença em relação à verificação anterior. Em *Configurações* há o histórico das notas. É um guia para acompanhar a tendência, não um laudo.
- **Verificação semanal automática (opcional):** em *Configurações* dá para ativar uma tarefa do Windows que, uma vez por semana, faz uma verificação rápida **somente de leitura** (sem corrigir nada e sem usar a internet). Se a nota cair 5 pontos ou mais, ou aparecer um problema crítico novo, o WinDiag avisa com uma notificação e com um aviso na tela inicial. As 4 verificações automáticas mais recentes ficam em `%LOCALAPPDATA%\WinDiag\Agendadas`. Para desativar, use o botão correspondente ou remova a tarefa "WinDiag - verificação semanal" no Agendador de Tarefas.

## O que o WinDiag nunca faz sozinho

- Só altera o Windows depois do seu "Sim", e oferece criar um ponto de restauração e guardar uma cópia dos drivers antes de corrigir.
- Nunca apaga arquivos pessoais (a limpeza só mexe em temporários com mais de 2 dias; o backup só copia), nunca formata discos nem mexe em BIOS, nunca desativa antivírus ou firewall, nunca troca senhas ou contas e não instala programas.
- Nunca envia informações do seu computador para ninguém. A internet é usada só para consultar o Windows Update e testar a conexão (opção da verificação) e para ler a versão mais recente (botão de atualização). Esse texto também está na tela inicial: *O que o WinDiag faz e o que nunca faz sozinho*.

## Instalação opcional

Para instalar o WinDiag para o seu usuário (sem precisar de administrador), dê duplo clique em **`Instalar-WinDiag.bat`**: ele copia o programa para `%LOCALAPPDATA%\Programs\WinDiag`, cria os atalhos e registra o WinDiag em *Aplicativos e recursos*. Para remover, use esse mesmo lugar ou **`Desinstalar-WinDiag.bat`** (os relatórios da Área de Trabalho e as alterações já feitas no Windows são mantidos; para desfazer os bloqueios de driver, use antes o botão correspondente em Ferramentas de reparo).

**Só o instalador:** o `Instalar-WinDiag.bat` também funciona sozinho. Sem os outros arquivos ao lado, ele baixa a versão mais recente do repositório público de versões, confere o SHA-256 do pacote e instala. Dentro do WinDiag, o botão **Procurar atualização** (em Configurações) faz o mesmo caminho: só consulta o `latest.json` e, se você aceitar, baixa e instala a versão nova. Nada sobre o seu computador é enviado.

Para quem mantém o projeto: **`Gerar-Release.ps1`** monta o ZIP versionado, o `SHA256SUMS.txt` e o `latest.json` na pasta `dist\`. Para publicar, copie o ZIP e o `latest.json` para a branch `main` do repositório público de versões (`Tanukib/WinDiag-releases`).

## Idioma

A interface fica em inglês quando o Windows está em inglês (ou com a variável de ambiente `WINDIAG_IDIOMA=en`; use `pt` para forçar o português). A tradução é **parcial**: botões, títulos, textos fixos e as principais caixas de diálogo. Os resultados do diagnóstico (descrições dos problemas e o que fazer) continuam em português.

## Avisos do SmartScreen e do antivírus

O WinDiag é um conjunto de scripts **sem assinatura digital** (assinar custa dinheiro e só faria sentido se o projeto crescesse). Por isso o Windows pode mostrar avisos:

- **"O Windows protegeu o computador" (SmartScreen):** clique em **Mais informações** e depois em **Executar assim mesmo**. Rodar `Criar-Atalho.bat` antes evita esse aviso nas próximas aberturas.
- **Antivírus:** alguns desconfiam de scripts que mexem em drivers. O código é aberto e pode ser lido por inteiro; o WinDiag não envia nada para a internet e só altera o sistema com a sua confirmação.
- Se o ZIP veio da internet, use o botão direito no ZIP > **Propriedades** > **Desbloquear** antes de extrair.

## Testando em outros computadores

Antes de compartilhar com muita gente, vale rodar em máquinas diferentes. Sugestão de roteiro:

1. Windows 10 e Windows 11; computador de mesa e notebook (a bateria aparece só nele); escala da tela em 100% e 150%.
2. Primeiro **sem** administrador (só verificar), depois **com** administrador.
3. Verificação completa, **Ver mais** em alguns cartões, **Copiar resumo**, filtro por categoria e a aba **Meu computador**.
4. Corrigir com **Perguntar a cada uma** e, em outra máquina, com **Aceitar tudo**; testar **Parar depois desta correção** e **Desfazer alterações**.
5. Se algo falhar, peça a quem testou:
   - o arquivo `%LOCALAPPDATA%\WinDiag\erros.log`;
   - a pasta da verificação (`Verificacao_...` dentro de `WinDiag` na Área de Trabalho);
   - a versão do Windows e um print da tela.

## Driver de vídeo sobrescrito pelo Windows Update

Um problema comum no Windows 10/11: você instala o driver da NVIDIA/AMD/Intel, e depois de uma atualização o Windows Update instala outro driver por cima (às vezes mais antigo, às vezes o genérico "Microsoft Basic Display Adapter"). Os relatos apontam que o Windows Update dá prioridade ao driver que ele entrega, e a Intel recomenda reinstalar o driver depois que ele for removido.

O que o WinDiag faz:

1. **Detecta**: compara o driver em uso com os pacotes do fabricante que o Windows ainda guarda (DriverStore) e consulta o histórico do Windows Update dos últimos 90 dias.
2. **Restaura** (com permissão): reinstala o pacote mais novo do fabricante que está guardado, com `pnputil /add-driver /install`. O `pnputil` não força um driver que o Windows considere pior; nesse caso o WinDiag oferece, com nova confirmação, a instalação forçada pelo mesmo método do Gerenciador de Dispositivos.
3. **Protege** (com permissão): oferece bloquear, por ID de hardware, a troca automática do driver daquela placa. Opcionalmente, em edições que não são Home, exclui drivers das atualizações de qualidade do Windows Update.

**O que você precisa saber sobre o bloqueio:** enquanto ele existe, o Windows também impede a instalação **manual** de drivers para aquele dispositivo (inclusive o instalador do fabricante). Por isso:

- O WinDiag suspende o bloqueio sozinho só durante uma restauração e o reativa logo depois.
- Para atualizar o driver por conta própria, rode `Executar-WinDiag.bat -DesfazerBloqueios`, instale o driver e, se quiser, ative a proteção de novo.
- O valor `DenyDeviceIDsRetroactive` é sempre gravado como `0` (com `1` o Windows desinstalaria o dispositivo já instalado), e existe um teste automatizado para isso.
- Só os bloqueios criados pelo próprio WinDiag são removidos pelo `-DesfazerBloqueios`.

## Restauração de drivers e permissões

Cada ação de restauração mostra o que vai fazer e **pede a sua confirmação**:

- **Restaurar o driver guardado no sistema** (DriverStore) para um dispositivo com erro ou com driver trocado.
- **Voltar ao driver nativo do Windows**: remove o pacote de terceiros (uma cópia é exportada antes, com o comando para desfazer) e o Windows volta a usar o driver embutido. Nunca é oferecido para pacotes críticos de inicialização.
- **Drivers internos do sistema** (chipset, armazenamento, processador, USB, barramento) exigem digitar `RESTAURAR`; um simples "s" não basta.
- Antes da primeira alteração, o WinDiag oferece criar um **ponto de restauração** e exportar uma **cópia dos drivers de terceiros**.
- Antes de qualquer reparo, ele avisa se há reinicialização pendente, se o notebook está na bateria (abaixo de 40%) ou se o Windows está instalando atualizações.

Outras ações, sempre com confirmação: reparar erros de volume (`Repair-Volume -SpotFix`), reativar dispositivos desativados, reinstalar o driver de um dispositivo com erro, instalar drivers pendentes do Windows Update (você escolhe quais), `DISM /RestoreHealth` e `sfc /scannow`.

Com `-SomenteLeitura`, ou se a permissão de administrador for negada, nada disso é oferecido.

## Proteções contra erros de execução

- Cada etapa roda isolada: se uma leitura falhar (por exemplo, WMI com problema), as demais continuam e o problema aparece no relatório.
- Pré-verificações no início: modo restrito do PowerShell, serviço WMI, serviço de eventos, versão do Windows e espaço em disco.
- A consulta ao Windows Update roda com tempo limite (4 minutos), para não travar o script.
- Perguntas sem console interativo são tratadas como "não".
- A instalação do driver restaurado é conferida depois (versão lida do dispositivo), em vez de presumir que deu certo.

## Privacidade

- O script **não envia dados para lugar nenhum** e não tem telemetria. O único tráfego de rede é a consulta ao Windows Update e o teste de rede (um ping e uma consulta de DNS), que você pode desligar na opção "Usar a internet na verificação".
- Os links do relatório só são abertos se você clicar neles.
- O relatório pode conter o nome do computador, o modelo e IDs de hardware. **Revise antes de postar em fóruns ou issues.** Números de série não são coletados.

## Sobre os links de download

O WinDiag aponta apenas para fontes oficiais: o Microsoft Update Catalog e as páginas de download dos fabricantes. Ele não baixa nem executa nenhum driver da internet sozinho. Evite "atualizadores de driver" de terceiros; muitos instalam programas indesejados e drivers errados.

## Limitações

- Não há um `.exe`: o WinDiag é um script PowerShell para que qualquer pessoa possa ler o código antes de rodar. Um `.exe` não assinado costuma ser bloqueado pelo SmartScreen e por antivírus.
- **Só Windows** (Windows 10 1809 ou superior e Windows 11, com Windows PowerShell 5.1).
- As funções independentes de Windows e o protocolo da interface têm testes automáticos; a janela e o fluxo completo dependem do Windows e **ainda precisam de testes em máquinas reais**. Se algo falhar, abra uma issue anexando o `.log` (revise-o antes).
- Não substitui as ferramentas do fabricante do SSD/HD para um SMART detalhado.
- "Driver antigo" é uma heurística (data do driver); só um site de fabricante diz se existe versão nova.
- Algumas leituras (SMART via WMI, temperatura ACPI, bateria) dependem do suporte do equipamento; em máquinas virtuais podem vir vazias.
- A restauração só encontra drivers que o Windows ainda guarda no DriverStore; se o pacote foi removido, use os links do relatório.
- O bloqueio por ID de hardware e a exclusão de drivers são políticas do Windows; a exclusão global pode não ter efeito no Windows Home.

## Arquivos

| Arquivo | Para quê |
|---|---|
| `Abrir-WinDiag.bat` | Abre a interface gráfica (duplo clique) |
| `WinDiag-GUI.ps1` | A janela (Windows Forms, já incluído no Windows) |
| `WinDiag-Extras.ps1` | Verificações extras, ferramentas de reparo, comparação entre verificações e histórico de alterações |
| `Instalar-WinDiag.bat` / `Desinstalar-WinDiag.bat` | Instala/remove o WinDiag para o usuário atual |
| `Gerar-Release.ps1` | Gera o ZIP versionado e os checksums (para publicar no GitHub) |
| `WinDiag-Bench.ps1` | Teste de desempenho: processador, memória RAM, disco e placa de vídeo |
| `WinDiag-Worker.ps1` | Ponte entre a janela e o motor; roda em segundo plano |
| `WinDiag.ps1` | O motor de diagnóstico e reparo (também funciona sozinho, no console) |
| `Criar-Atalho.bat` / `Criar-Atalho.ps1` | Cria o atalho com ícone na Área de Trabalho e no Menu Iniciar |
| `Executar-WinDiag.bat` | Abre a versão de console |
| `.github/workflows/testes.yml` | Testes automáticos no GitHub Actions |
| `tests/` | Testes automatizados |

A interface não reimplementa nada: ela usa as mesmas funções do `WinDiag.ps1`. As perguntas do console viram caixas de diálogo e o `Write-Host` vira o painel de detalhes.

## Contribuindo

- Salve os `.ps1` como **UTF-8 com BOM** e finais de linha **CRLF**, senão o Windows PowerShell 5.1 mostra os acentos errado. O `.gitattributes` já cuida das quebras de linha.
- Evite sintaxe exclusiva do PowerShell 7 (`?.`, `??`, `&&`, operador ternário): o alvo é o 5.1.
- Dois conjuntos de testes rodam em qualquer PowerShell (inclusive `pwsh` no Linux/macOS), sem abrir janelas e sem tocar no sistema:

```powershell
./tests/Testar-Funcoes.ps1   # funções do motor
./tests/Testar-Worker.ps1    # protocolo entre a interface e o motor (perguntas, etapas, erros)
./tests/Testar-Estimativa.ps1 # cálculo do tempo restante da interface
```

O GitHub Actions (`.github/workflows/testes.yml`) roda esses testes e a checagem de sintaxe a cada envio, no Linux e no Windows (PowerShell 5.1).

- A janela em si (`WinDiag-GUI.ps1`) só pode ser testada no Windows. Ao mexer nela, teste com e sem administrador e com a escala da tela em 100% e 150%.
- Ao abrir um PR, informe a versão do Windows e se testou com e sem administrador.

## Referências

- [pnputil command syntax (Microsoft Learn)](https://learn.microsoft.com/windows-hardware/drivers/devtest/pnputil-command-syntax)
- [Intel: o Windows Update substitui o driver gráfico instalado](https://www.intel.com/content/www/us/en/support/articles/000091899/graphics.html)
- [Wintips: how to stop Windows 11 from downgrading GPU drivers](https://www.wintips.org/?p=72430)
- [Winhelponline: prevent Windows Update from installing a driver automatically](https://www.winhelponline.com/blog/prevent-wu-driver-update-automatic-realtek/)
- [Eleven Forum: block Windows Update from installing an old graphics driver](https://www.elevenforum.com/t/how-to-block-windows-update-from-installing-an-old-intel-iris-driver.37680/)

## Licença

MIT. Veja o arquivo `LICENSE`.

### Por que a correção é rápida

O WinDiag só faz o que é necessário: o ponto de restauração é criado uma vez; a cópia dos drivers (que leva minutos) só é feita se a correção mexe em drivers; o `DISM /RestoreHealth` só roda se a verificação rápida (`/CheckHealth`) achar problema; e o `SFC` só roda se há sinais (telas azuis, falhas do sistema de arquivos) ou se você marcar "Verificação profunda" em Configurações (ou usar `-VerificacaoProfunda`).

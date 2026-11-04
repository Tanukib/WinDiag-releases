# Telomera

Diagnóstico e reparo de **hardware, discos e drivers** no Windows, em um único script PowerShell, sem instalar nada.

O Telomera foi pensado para achar o que o diagnóstico padrão do Windows **não mostra**: o Gerenciador de Dispositivos só marca um driver como problema quando ele dá erro na hora. Muitos defeitos reais ficam escondidos (driver de vídeo trocado pelo Windows Update, driver genérico, driver sem assinatura, driver que falhou ao iniciar, disco que já acumula erros, telas azuis recorrentes). O Telomera cruza essas fontes e entrega um relatório com o que fazer, links para baixar o driver certo e, com a sua permissão, restaura o que for possível.

> **Aviso:** use por sua conta e risco. O script só altera algo depois de você confirmar cada ação, mas mexer em drivers e discos sempre tem risco. Mantenha backup dos seus arquivos.

## Novidades da 2.31.0

- Tema escuro em todas as telas, igual à proposta de visual aprovada (a versão 2.30.0 tinha o novo layout, mas as cores ainda estavam claras por engano). Cores, contraste de texto e dos avisos (atenção/erro/sucesso) conferidos um a um contra o padrão de acessibilidade WCAG 2.2 AA.

## Novidades da 2.30.0

- Novo visual em todas as telas (redesenho com referência em apps como Windows 11 e CCleaner): barra de ações de Resultados reduzida de 7 para 4 botões (Relatório, PDF, Copiar resumo e Abrir pasta agora ficam dentro de "Exportar ▾"); Configurações com toggles no lugar das caixinhas; Início com a nota de saúde em um anel e "Configurações" movido para um ícone no cabeçalho; Progresso com um anel grande no lugar da barra linear; Detalhes técnicos com margem em vez de texto colado na borda; Fim com lista de marcas de verificação no lugar do texto corrido; Ferramentas de reparo com um ícone em cada item da barra lateral.
- Ícone do programa (área de trabalho, atalho, barra de tarefas, instalador) com cantos arredondados, no mesmo estilo dos ícones modernos do Windows.
- O título da janela e o diálogo de permissão (UAC) foram simplificados: agora mostram só "Telomera" (e a versão, na janela), sem o subtítulo "diagnóstico do computador".

## Novidades da 2.29.0

- Rebrand completo: o programa agora se chama Telomera por dentro também (não só na tela). Scripts, pasta de instalação (`%LOCALAPPDATA%\Programs\Telomera`), dados (`%LOCALAPPDATA%\Telomera`) e o registro em "Aplicativos e recursos" usam o nome novo. Quem já tinha o WinDiag instalado é migrado automaticamente ao atualizar (dados preservados, atalho antigo removido, nada precisa ser feito manualmente).
- O repositório de versões no GitHub e o nome do pacote baixado continuam usando "WinDiag" por dentro (não dá para renomear sem quebrar a atualização automática de quem já tem o Telomera instalado); isso é só o "nome de remessa" do pacote e não aparece em lugar nenhum do programa.

## Novidades da 2.28.2

- O Telomera agora sempre abre com a janela maximizada.

## Novidades da 2.28.1

- Corrigido: ao abrir pelo Telomera.exe, o pedido de permissão (UAC) aparecia como "Windows PowerShell" em vez de "Telomera" — confuso, parecia o programa errado pedindo acesso. Agora é o próprio Telomera.exe que pede a elevação (com o nome certo no UAC); só depois de aceitar ele chama o PowerShell, já elevado. Se o UAC for recusado, continua abrindo só para verificação, como sempre.

## Novidades da 2.28.0

- O instalador agora compila e assina o `Telomera.exe` (launcher nativo) automaticamente durante a instalação e a atualização, usando o `csc.exe` que já vem com o Windows — não precisa mais rodar nada manualmente. Os atalhos (Área de Trabalho e Menu Iniciar) passam a apontar direto para o `Telomera.exe`; se a compilação não der certo por algum motivo (ex.: `csc.exe` ausente), a instalação continua normalmente e os atalhos caem de volta no PowerShell, como antes.
- Ajuste no launcher nativo: o manifesto deixou de forçar administrador (`requireAdministrator` → `asInvoker`). Quem decide a elevação continua sendo o `WinDiag-GUI.ps1`, que se reabre sozinho como administrador quando precisa e permite continuar em modo somente leitura se o UAC for recusado — com `requireAdministrator` essa opção de recusar e abrir mesmo assim desaparecia.
- A desinstalação agora também remove o certificado de teste do Telomera.exe dos repositórios de certificado do Windows.

## Novidades da 2.27.1

- Corrigido: desinstalar pelo "Aplicativos e recursos" do Windows apagava os arquivos mas deixava o Telomera aberto na tela, como se nada tivesse acontecido. Agora a desinstalação fecha a janela principal também.

## Novidades da 2.27.0

- Marca: o app passa a se chamar **Telomera** (título da janela, ícones, caixas de diálogo, atalho, registro em "Aplicativos e recursos"). Os arquivos continuam se chamando WinDiag*.ps1 e a pasta de instalação continua sendo WinDiag — só a marca visível mudou, para não quebrar nada que já depende desses nomes (atualização automática incluída).
- Ícone novo (caranguejo) no app, no atalho e no instalador.

## Novidades da 2.26.5

- Corrigido: uma falha de redesenho interna do Windows (bug conhecido do .NET WinForms, acionada por mudança de resolução, de monitor ou por controle remoto da tela) fazia o WinDiag mostrar de vez em quando a caixa "Ocorreu um erro inesperado" ao clicar em botões perto do cartão do Windows Update — sem relação real com o Windows Update. Agora o WinDiag corrige o buffer de tela sozinho e para de assustar com essa caixa.

## Novidades da 2.26.4

- Corrigido: em "Corrigir tudo automaticamente" o WinDiag perguntava quais drivers pendentes do Windows Update instalar, mas ninguém estava ali para responder, então a resposta virava vazio (= cancelar) e o driver continuava pendente mesmo depois de corrigir. Agora, nesse modo, instala todos os pendentes direto, sem perguntar.
- Se a busca de atualizações gerais do Windows falhar, o motivo fica registrado no log de alterações, para diagnosticar sem precisar adivinhar.

## Novidades da 2.26.3

- Leitor de eventos em C# (compilado em tempo de execução, sem exe separado): cada log do Windows citado nas regras agora é lido **uma única vez** e reaproveitado por todas as regras daquele log, em vez de uma consulta por regra (ex.: 9 consultas ao log System viram 1). Mais rápido e permite olhar mais eventos no mesmo tempo. Só existe no Windows; se não compilar ou não for Windows, volta sozinho ao `Get-WinEvent` de sempre, sem mudar o resultado.
- SMART detalhado por disco e a elevação de administrador já funcionavam assim: um único pedido de permissão por execução, nenhuma novidade aí.

## Novidades da 2.26.2

- No fim do reparo o WinDiag busca e instala as atualizações de segurança e qualidade pelo Windows Update, sem abrir as Configurações. Troca de versão do Windows (ex.: 10 para 11) continua sendo decisão sua. Se o serviço não responder, abre as Configurações como último recurso.

## Novidades da 2.26.1

- Volume com espaço livre: só vira atenção se tiver menos de 10% **e** menos de 50 GB livres (73 GB em disco grande não alerta mais).
- "Ver mais" detalhado também para volume e para drivers pendentes no Windows Update.

## Novidades da 2.26

- **"Ver mais" detalhado em todo driver e evento.** Cada cartão agora explica: o que é, **o que significa neste computador** (versão, data e idade do driver; número de ocorrências, última data, 24 h, 7 dias e o significado de cada código de evento), **se é para se preocupar** (regras por frequência e recência) e **o que fazer** (com os botões do próprio WinDiag).
- A lista de drivers de som, rede e chipset traz um parágrafo por driver.
- Falhas de instalação de driver explicam o código (0x103, 0x50, 0x5, 0x2...).

## Novidades da 2.25.1

- **Menos alarme falso:** um evento isolado (no máximo 1 ocorrência) com mais de 7 dias deixa de contar como ponto de atenção (vira informativo).
- O aviso "Há uma reinicialização pendente" agora aparece como **corrigível com o botão Reiniciar**, e o resumo do topo conta isso separado de "precisam de você".
- **Pacote de driver corrompido:** o catálogo (.cat) passa a ser o declarado no próprio .inf (`CatalogFile=`). Antes o nome era presumido e podia acusar pacote sano.
- A lista de drivers da aba Meu computador sai na ordem certa no Windows PowerShell 5.1.

## Novidades da 2.25

- Ao clicar em **Verificar meu computador**, o WinDiag pergunta se você quer a verificação **normal** ou a **profunda** (a caixa da tela inicial foi removida). O mesmo vale para "Verificar de novo" e F5.
- Novo: detecta **pacotes de driver corrompidos** no DriverStore (arquivo .inf ou catálogo ausente, ou catálogo adulterado) e oferece removê-los, guardando uma cópia antes. Classes críticas (disco, chipset, processador) nunca são removidas sozinhas.

## Novidades da 2.24

- **Verificação profunda** (caixa na tela inicial, só leitura, mais 10 a 30 minutos): confere os arquivos do Windows (`sfc /verifyonly`) e a imagem (`DISM /ScanHealth`), o repositório WMI (`winmgmt /verifyrepository`), a análise de energia (`powercfg /energy`), 90 dias de histórico de eventos, programas que travam com frequência (por programa e módulo), tempo de inicialização, limitação do processador pelo firmware (calor/energia), falhas repetidas do Windows Update, Inicialização Segura e TPM. SFC, DISM e energia exigem administrador. Nada é alterado: os reparos continuam em "Reparos e restauração", com confirmação.
- O campo "Verificação profunda" saiu de Configurações (era só o SFC/DISM da fase de reparo) e agora fica na tela inicial.

## Novidades da 2.23.4

- Ícone do atalho: o ícone instalado agora tem nome novo (`windiag-app.ico`), o que força o Windows a reler o ícone dos atalhos (o escudo antigo ficava em cache). O app também ajusta o ícone em "Aplicativos e recursos".
- Testes mais robustos: análise estática de compatibilidade com o Windows PowerShell 5.1 (`tests/Testar-Compat51.ps1`) e um teste de fumaça da interface (`WINDIAG_GUI_FUMACA=1`) que monta janela, telas e cartões. Ambos rodam também em um job `windows-latest` da integração contínua, no PowerShell 5.1 real.

## Novidades da 2.23.3

- Corrige o erro "Os tipos de argumento não correspondem" na barra lateral da tela inicial e na aba "Meu computador": no Windows PowerShell 5.1, `@(lista)` falha com listas `List[object]` criadas por `New-Object`. O app agora usa um conversor seguro (`Get-VetorLista`).

## Novidades da 2.23.2

- Ao abrir, o app lê os componentes do computador (modelo, Windows, processador, memória, vídeo com versão do driver, placa-mãe, BIOS e espaço dos discos) e mostra numa barra lateral esquerda da tela inicial. Se a leitura falhar, a barra mostra o motivo.
- Janelas estreitas (menos de ~980 px de largura útil) escondem a barra para não apertar o conteúdo.

## Novidades da 2.23

- Tela inicial com o resumo do seu computador (modelo, Windows, processador, memória, vídeo, BIOS e espaço dos discos), lido em segundo plano. Em janelas largas fica ao lado; em estreitas, embaixo.
- A janela abre num tamanho proporcional à tela (corrige o corte em notebooks com escala 125% e 150%).
- Ícone novo do WinDiag (`windiag.ico`) na janela, no atalho, no balão de aviso, em "Aplicativos e recursos" e no desinstalador.
- Desinstalador redesenhado: mostra o que será removido e o que continua, botões na barra de baixo e "Desinstalar" em vermelho (Enter continua cancelando).

## Novidades da 2.22

- O que o próprio app marca como "Provavelmente normal" deixa de contar como atenção (ex.: drivers `dam`, `hwpolicy`, anticheat `vgk`). Fica só como informativo.
- Avisos repetidos aparecem uma vez; falhas de instalação com código 0x103 (sem dispositivo compatível) são tratadas como normais.
- Pouco espaço livre em disco agora tem correção automática (apagar temporários com mais de 2 dias); nova ferramenta "Reiniciar o computador agora".
- A aba "Meu computador" mostra um cartão de Drivers (versão, data e situação de cada um).
- Tela inicial mais enxuta: três assuntos grandes e quatro atalhos menores.

## O que ele faz

| Área | O que é verificado | O Windows mostra isso? |
|---|---|---|
| Hardware | Processador, memória (módulos, tipo, velocidade, canal único, RAM utilizável x instalada), placa(s) de vídeo, placa-mãe, BIOS/UEFI, Secure Boot, TPM, rede (velocidade negociada), áudio, monitores, bateria (saúde e ciclos), temperatura, inventário de dispositivos | Espalhado por vários lugares |
| Discos | Saúde, temperatura, desgaste do SSD, horas de uso, erros de leitura/escrita **não corrigidos**, previsão de falha SMART | Só o status geral |
| Volumes | Espaço livre e varredura online de erros (NTFS/ReFS) | Parcialmente |
| Eventos (últimos N dias) | Falhas de I/O, corrupção NTFS, resets do controlador NVMe/SATA, erros de hardware (WHEA), travamentos do driver de vídeo, desligamentos inesperados, **telas azuis com o código, os parâmetros e a causa provável**, desligamentos inesperados detalhados (com ou sem tela azul, botão de ligar, horários mais comuns), erros de hardware WHEA (fatais e corrigidos), texto completo dos erros do driver de vídeo, drivers bloqueados ou que não carregaram | Espalhado pelo Visualizador de Eventos |
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
2. Dê duplo clique em **`Abrir-Telomera.bat`** (só na primeira vez: ele cria sozinho o atalho com o ícone do escudo na Área de Trabalho e no Menu Iniciar). O Telomera já pede direto a permissão de administrador do Windows: clique em Sim no aviso (se recusar, ele abre só para verificação e não corrige).
3. Clique em **Verificar meu computador** e aguarde (2 a 10 minutos).
4. A tela de resultado mostra, em linguagem comum, o que foi encontrado, o que fazer e links de download. A aba **Meu computador** lista o seu hardware e a aba **Detalhes técnicos** mostra tudo o que foi feito.
5. Se houver correções automáticas, clique em **Corrigir automaticamente**. Cada correção abre uma caixa de confirmação e só acontece se você aceitar; drivers internos exigem digitar `RESTAURAR`.

A aba **Meu computador** mostra cartões (computador, processador, memória, vídeo, placa-mãe, discos, rede, monitores e bateria), com barras de uso do espaço nas unidades e indicadores de cor para a saúde dos discos. Em janelas largas os cartões ficam em duas colunas. O visual é claro e minimalista: cartões com uma barra lateral colorida pela gravidade (vermelho, laranja, cinza), abas com sublinhado, barra de progresso fina e tempo decorrido. Na tela de resultados há um filtro por categoria (Drivers, Eventos, Discos...), o botão **Copiar resumo** (para colar em um fórum ou mandar a alguém) e, em **Configurações**, o atalho para a pasta das verificações anteriores. A tecla Enter inicia a verificação.

Cada problema tem um botão **Ver mais**, que explica em linguagem simples o que aquilo é (por exemplo, que o `vgk` é o anti-cheat do VALORANT/LoL e que o `dam` é um componente de economia de energia da Microsoft) e se vale mesmo mexer: *Provavelmente normal*, *Depende*, *Vale corrigir* ou *Opcional*. Para drivers de sistema desconhecidos, o Telomera confere se o arquivo ainda existe (se não existe, é resto de um programa desinstalado). As explicações são orientações gerais, não um diagnóstico definitivo. O mesmo texto aparece no relatório HTML.

Ao clicar em **Corrigir**, você escolhe: **Perguntar a cada uma** (decide correção por correção) ou **Aceitar tudo** (o Telomera executa tudo sem interromper, criando antes o ponto de restauração e a cópia dos drivers). No modo "aceitar tudo", os drivers internos do sistema (chipset, armazenamento, processador) são sempre pulados e a instalação de drivers pelo Windows Update não é feita; tudo fica registrado no log.

Durante a verificação a janela mostra o **tempo decorrido** e uma **estimativa do tempo restante**. A estimativa começa com valores médios e melhora a cada verificação: o Telomera guarda quanto cada etapa levou no seu computador (em `%LOCALAPPDATA%\Telomera\tempos.json`, só números) e ajusta pela velocidade da máquina na própria verificação. Nos reparos, o DISM e o SFC informam o percentual: a tela mostra "Tarefa atual: N%" e o "Tempo restante estimado desta tarefa" (calculado pela velocidade já observada; vale só para a tarefa em andamento, pois o total depende das suas confirmações). O log mostra uma linha a cada 10%, em vez de centenas de linhas de progresso.

A janela não trava durante a verificação: o diagnóstico roda em segundo plano. Fechar a janela no meio de um reparo pede confirmação, porque pode deixá-lo pela metade.

### Para quem prefere o console

Dê duplo clique em **`Executar-Telomera.bat`** (pede administrador sozinho) ou, em um PowerShell:

```powershell
# Só diagnosticar, sem oferecer nenhuma alteração
powershell -ExecutionPolicy Bypass -File .\Telomera.ps1 -SomenteLeitura
```

Cada verificação ganha a sua própria pasta, dentro de `Telomera` na Área de Trabalho: `Verificacao_AAAA-MM-DD_HH-mm-ss`. Nela ficam o relatório HTML, o JSON, o log e, se você pedir, a cópia dos drivers e os pacotes removidos. Os reparos feitos depois de uma verificação atualizam o relatório dessa mesma pasta. Vale nas duas versões (janela e console).

### Parâmetros (versão de console)

| Parâmetro | Efeito |
|---|---|
| `-SomenteLeitura` | Apenas diagnostica; não oferece reparos |
| `-SemWindowsUpdate` | Não consulta o Windows Update (a consulta pode demorar) |
| `-PularScanVolumes` | Pula a varredura de erros nos volumes (mais rápido em discos grandes) |
| `-DiasEventos 60` | Quantos dias de eventos analisar (padrão: 30) |
| `-PastaRelatorio "D:\Relatorios"` | Onde salvar os relatórios |
| `-NaoAbrirRelatorio` | Não abre o HTML ao terminar o diagnóstico |
| `-DesfazerBloqueios` | Remove os bloqueios de driver criados pelo Telomera e sai |

### Atalho com ícone, atalhos de teclado e outras comodidades

- **Atalho automático:** na primeira abertura, o Telomera cria sozinho o atalho **Telomera** (ícone do escudo) na Área de Trabalho e no Menu Iniciar, sem perguntar nada; se você apagar o atalho, ele não volta sozinho (só se a pasta do Telomera mudar de lugar). Para recriar, use **Configurações** na tela inicial. O `Criar-Atalho.bat` faz o mesmo manualmente, pergunta se deve abrir sempre como administrador e libera os arquivos do ZIP baixado da internet (o "bloqueio" que gera avisos). Para fixar na barra de tarefas, abra pelo atalho e use o botão direito no ícone da barra.
- **Parar com segurança:** durante as correções, o botão **Parar depois desta correção** deixa terminar a que já começou (interromper o DISM, o SFC ou um driver no meio poderia danificar o Windows) e pula as seguintes.
- **Reinício:** ao terminar, o Telomera verifica se o Windows pede reinício (chaves de reinício pendente no registro) e oferece **Reiniciar agora** ou **Mais tarde**.
- **Desfazer alterações:** restaura a cópia de drivers feita antes das correções (`pnputil /add-driver ... /install`) ou abre a Restauração do Sistema do Windows. Também está em **Ferramentas de reparo > Desfazer o que o Telomera fez**.
- **Teclado:** `Tab`/`Shift+Tab` navegam, `Ctrl+1/2/3` trocam de aba, `F5` verifica de novo e `F1` mostra a ajuda. Os cartões e abas têm nomes para leitores de tela.
- **Erros da interface** são gravados em `%LOCALAPPDATA%\Telomera\erros.log` (versão, Windows e pilha de chamadas) e a caixa de erro oferece copiar os detalhes.

## Teste de desempenho (botão "Testar desempenho")

Botão separado da verificação, na tela inicial. Leva de 3 a 4 minutos e não altera nada no computador (só cria um arquivo temporário de até 1 GB no disco, apagado no fim):

- **Resumo**: no topo do relatório, os números principais de cada teste e a diferença para o teste anterior.
- **Processador**: pontuação com um núcleo e com todos os núcleos, queda de desempenho e de **frequência** durante a carga (sinal de superaquecimento ou limite de energia, mesmo sem ler a temperatura) e comparação com o teste anterior. Ao clicar em **Testar desempenho**, uma janela pergunta o tipo de teste: **normal**, **longo** (processador 3 minutos a 100%, pontos minuto a minuto, e a verificação da **memória RAM** repetida 4 vezes), **estresse de jogo pesado** ou **teste de transição**.
- **Memória RAM**: usa vários núcleos ao mesmo tempo e até 8 GB (60% da memória livre). Grava e confere 8 padrões (zeros, uns, 1010, 0101, endereço, bit andando, bit andando invertido, pseudoaleatório), faz duas "inversões em movimento" (acham células que não trocam de valor) e uma conferência depois de 6 segundos de espera (acha células que perdem o valor). Mede a velocidade, mostra quanto isso é da velocidade teórica (calculada pelos módulos e canais) e avisa se a memória está em canal simples ou abaixo da velocidade nominal (XMP/EXPO desligado). É uma amostra da memória livre: o Windows não deixa testar o que ele mesmo usa, então para um teste completo use o MemTest86.
- **Disco**: velocidade de escrita e leitura sequencial (sem o cache do Windows), leituras aleatórias de 4 KB (uma de cada vez e com fila de 32), leitura sequencial com fila (a velocidade que o fabricante anuncia), conferência do conteúdo gravado e a saúde informada pelo próprio disco (estado, desgaste do SSD, temperatura e erros sem correção, quando o disco informa).
- **Temperaturas e sensores (opcional)**: o Windows não informa a temperatura do processador nem da placa-mãe. Se o **HWiNFO** (com a "memória compartilhada" ligada em Configurações, na janela de Sensores) ou o **LibreHardwareMonitor / OpenHardwareMonitor** estiver aberto durante o teste, o Telomera lê o que eles publicam: temperatura máxima do processador sob carga, GPU, placa-mãe, discos, ventoinhas e consumo. O Telomera não instala nem carrega nenhum driver: só lê o que esses programas já mostram. Sem eles, esse item simplesmente não aparece.
- **Placa de vídeo**: animação 3D em seis níveis de carga (até cerca de 3,5 milhões de triângulos), medindo quadros por segundo e o pico de milhões de triângulos por segundo (que não depende do limite de 60 quadros do monitor), em um processo separado (se o driver travar, o Telomera não cai junto). A temperatura vem da mesma fonte dos aplicativos da fabricante: nas NVIDIA, do `nvidia-smi` (temperatura, ventoinha, consumo, clock e memória de vídeo); nas AMD, da biblioteca do driver (`atiadlxx.dll`, a do AMD Software), com temperatura de borda, ponto mais quente (junção), memória, ventoinha, consumo e clock. Se isso não estiver disponível, usa a leitura do driver gráfico do Windows e, se nem ela informar, aparece como "n/d".

- **Estresse de jogo pesado (opcional, só roda se você escolher)**: na janela de escolha de **Testar desempenho**, selecione "Estresse de jogo pesado" (dá para somar o teste longo). Abre uma janela em tela cheia (Esc para parar) que aumenta a carga da placa de vídeo até o limite, com o processador em carga parcial (cerca de 60% dos núcleos, como num jogo), faz pausas bruscas de carga para simular troca de cena e mede quadros por segundo, uso, temperatura, consumo e clock. Interrompe sozinho se a placa passar de 93 °C. A gravação do monitor liga sozinha durante o teste, para ficar registrado se o computador travar. A animação usa um shader compilado na hora pelo próprio Windows; se isso falhar, o relatório avisa e o resto do teste segue normal.
- **Estresse prolongado (opcional)**: na janela de escolha, o estresse de jogo pesado tem a caixa para prolongá-lo para 20 minutos (10 no modo Moderada, 5 no Leve). Serve para reproduzir travamentos que só aparecem depois de vários minutos de carga contínua. O relatório mostra a evolução de temperatura e consumo em 4 partes.
- **Dados extras da placa NVIDIA (estresse e transição)**: geração e largura do link PCIe com a placa em carga e os motivos de redução de clock (limite de energia, temperatura, freio de hardware), lidos pelo `nvidia-smi`. Um link abaixo do máximo ou um freio de hardware viram alerta no relatório.
- **Configurações que influenciam travamentos em jogos** (verificação, somente leitura): agendamento de GPU por hardware, economia de energia do PCIe, plano de energia, inicialização rápida, memória (pentes diferentes, velocidade, canal único), idade da BIOS, programas de sobreposição abertos e o último resultado do Diagnóstico de Memória do Windows.
- **Investigar o último travamento** (Ferramentas de reparo > Monitor em tempo real): junta o último registro do monitor (com o **padrão antes do fim**: carga contínua, salto de repouso para carga, placa parada ou sensores que pararam), os erros que o Windows anotou ao redor desse horário (Kernel-Power 41, WHEA, driver de vídeo, disco, arquivos de falha) e as configurações, e termina com os próximos passos. Salva em `ultimo-travamento.txt`. Nenhum programa prova defeito de fonte, memória ou placa: só a troca de peça confirma.
- **Diagnóstico de Memória do Windows**: botão em Ferramentas de reparo que abre o `MdSched.exe` (testa a RAM no próximo reinício); o resultado aparece na verificação seguinte.
- **Teste de transição (opcional)**: para quem tem a imagem congelando justamente ao abrir um jogo. Abre e fecha uma tela cheia 40 vezes, deixando a placa de vídeo descansar entre as aberturas (6 s) e **trocando a resolução da tela a cada abertura** (a tela pisca, como um jogo em tela cheia; o Windows desfaz a troca sozinho se o teste for fechado). A carga gráfica sobe aos poucos (de 5 em 5 aberturas). Há a opção **Mais pesado** (60 aberturas, carga bem maior, cerca de 15 minutos). Isso reproduz a troca de repouso para carga. Mede o tempo até o primeiro quadro, os quadros por segundo, o consumo e o clock em cada abertura. Se a imagem travar, o relatório diz em qual ciclo e a gravação do monitor (ligada sozinha) mostra o que a placa fazia. Dura cerca de 10 minutos e roda sozinho, sem os outros testes. O relatório diz em que etapa a imagem travou (troca de resolução, abertura ou volta).
- **Teste de memória RAM com padrões (opcional)**: na janela de escolha, grava e confere padrões de dados (zeros, uns, 0xAA, 0x55, bit andando, endereços, aleatório) em até 12 GB (60% da memória livre) com até 4 núcleos, por cerca de 10 minutos (30 com a caixa "Prolongar"). Mostra o primeiro endereço com erro. Não substitui o MemTest86 (que testa a memória inteira, fora do Windows), mas acha pente defeituoso ou instável dentro do Windows.
- **Estresse do disco com verificação (opcional)**: grava um arquivo temporário (até 4 GB e até 10% do espaço livre, apagado no fim) e confere cada bloco ao ler de volta, medindo velocidade e tempo de acesso. Serve para HD cujo cabo SATA ou setores corrompem dados sob uso contínuo.
- **Testes de estresse externos**: em Ferramentas de reparo há atalhos para os sites oficiais do OCCT, FurMark e MemTest86 (o Telomera não baixa nem instala nada).

**Intensidade automática.** Antes de começar, o Telomera lê o computador (memória instalada e livre, número de núcleos, se é notebook, bateria, placa de vídeo dedicada ou integrada, espaço no disco e, se o HWiNFO ou o LibreHardwareMonitor estiver aberto, a temperatura do processador) e escolhe entre intensidade **Leve**, **Moderada** ou **Total**: o uso de memória, o tempo com todos os núcleos, o tamanho da cena 3D e o arquivo do disco diminuem em notebooks, computadores com pouca memória ou vídeo integrado. O processador também é interrompido se chegar a 97 °C (quando há sensor). Se um teste anterior não terminou (travou, reiniciou ou foi fechado), a etapa em que parou passa a rodar sempre em intensidade leve nesse computador. O item "Leitura do computador" do relatório mostra o que foi lido e por quê.

Se o Windows já tiver notas guardadas (WinSAT), elas aparecem no fim só para comparar.

Os resultados ficam num relatório HTML na pasta da verificação, e os pontos são guardados em `%LOCALAPPDATA%\Telomera\bench.json` para comparar com o próximo teste. Os pontos só servem para comparar o computador com ele mesmo.

## Monitor em tempo real (para PC que desliga sozinho em jogos)

Em **Ferramentas > Monitor em tempo real** você liga um registro que lê, a cada **meio segundo (0,5 s)**, o que o **HWiNFO** (com *Shared Memory Support* ligado), o **MSI Afterburner** e o **LibreHardwareMonitor** já publicam: temperaturas, tensões da fonte (+12 V, +5 V, +3,3 V), consumo, uso e, no MSI Afterburner, os quadros por segundo. Sem nenhum deles, grava o uso do processador e da memória e a temperatura da placa de vídeo (NVIDIA/AMD).

- Cada leitura é gravada e forçada para o disco na hora. Se o computador desligar no meio do jogo, o último registro mostra como estavam temperatura e tensão no momento da queda.
- Depois, **Ver o último registro** mostra os últimos 90 segundos e a provável causa: calor, tensão da fonte instável ou nada de anormal (o que costuma indicar corte de energia). O Telomera confere no log do Windows se foi mesmo uma queda (Kernel-Power 41) ou um desligamento normal, e diz se foi **travamento** (o botão de ligar foi segurado, com o tempo até o último registro), **tela azul** (com o código) ou desligamento seco (sem botão e sem tela azul: corte de energia ou reset de hardware).
- Roda em um processo próprio e escondido, só enquanto você deixar ligado; **não liga sozinho com o Windows** e não instala nada. Os registros ficam em `%LOCALAPPDATA%\Telomera\Monitor` (as 10 sessões mais recentes). A próxima verificação também avisa se a última sessão foi interrompida por uma queda.
- Para o HWiNFO acompanhar o ritmo, deixe o intervalo de atualização dos sensores dele (engrenagem da janela de sensores) em 500 ms; o padrão é 2000 ms e, com ele, os valores repetem entre as leituras. O registro ocupa cerca de 3 MB por hora de jogo (guarda as 10 sessões mais recentes).
- Limitações: a leitura é a cada 0,5 s, então um pico mais curto pode passar; os sensores de tensão da placa-mãe têm erro de alguns %; o disco pode manter as últimas linhas em cache se a energia cair no mesmo instante.

## Ferramentas de reparo e restauração

A tela inicial tem o botão grande **Verificar meu computador** e seis blocos por assunto: **Testar desempenho**, **O PC trava ou desliga**, **Monitor e sensores**, **Reparos e restauração**, **Ajuda e autoteste** e **Configurações**. Os blocos de ferramentas abrem uma página com **menu lateral** (O PC trava ou desliga, Monitor e sensores, Testes e estresse, Reparos do Windows, Restaurar e desfazer, Ajuda e autoteste), e cada área mostra só o que é dela. A tela inicial também mostra o estado dos sensores (HWiNFO ou LibreHardwareMonitor).

**Drivers.** A área *Drivers* explica, por tipo (vídeo, rede, som, chipset, disco, USB), o que cada driver faz, o que acontece quando ele falha e o peso dele nos travamentos, e lista os drivers do seu PC marcando os com erro, sem assinatura ou antigos. As mesmas explicações aparecem nos cartões da verificação. Para corrigir: **reparar dispositivos com erro** (reativa ou remove e deixa o Windows reinstalar, via `pnputil`), **reiniciar o driver de vídeo** (sem reiniciar o PC), **instalar drivers pelo Windows Update**, **limpar versões antigas** do DriverStore (guarda cópia de cada pacote e dá para voltar), **limpeza do driver de vídeo** para instalação limpa (ponto de restauração, cópia do driver e comando de volta) com um guia passo a passo, e **desligar a economia de energia do USB**. Tudo pede confirmação e fica no histórico de alterações.

**Baixar drivers novos com segurança.** O Telomera não baixa instaladores de endereços que ele mesmo escolheu, porque os links dos fabricantes mudam e não há como garanti-los. Em vez disso: (1) **Windows Update** (fonte oficial da Microsoft); (2) **páginas oficiais** da NVIDIA, AMD, Intel, Realtek e do fabricante da placa-mãe, abertas pelo app com o driver instalado ao lado para comparar; (3) **Conferir e instalar um driver baixado**: você escolhe o instalador que baixou e o Telomera só o executa se a assinatura digital (Authenticode) for válida e de um fabricante conhecido, mostrando o SHA-256 e criando um ponto de restauração antes.

**Sensores.** Em *Monitor e sensores* o Telomera mostra se o HWiNFO está instalado, aberto e com a memória compartilhada ligada, e um botão ajusta o `HWiNFO64.INI` (com cópia de segurança) e abre o programa. Como alternativa, ele baixa a **LibreHardwareMonitor** oficial do GitHub (confere o SHA-256 informado pelo GitHub e pede confirmação) e a abre como administrador; o monitor lê os sensores dela quando o HWiNFO não está aberto. Ela carrega um driver para ler o processador, então antivírus e anticheat (como o Vanguard) podem reclamar: use só se aceitar isso. O Telomera não traz driver próprio.

As ações das ferramentas de reparo (cada uma pede confirmação):

- ver, criar e abrir os **pontos de restauração** do Windows;
- **reparar a rede** (DNS, Winsock e IP), o **Windows Update** e a **Microsoft Store**;
- agendar o **CHKDSK** completo do disco do Windows para a próxima reinicialização;
- **limpar arquivos temporários** antigos;
- **copiar seus arquivos pessoais** (Documentos, Imagens e Área de Trabalho) para uma pasta ou pen drive, sem apagar nada;
- **correções de configuração com desfazer**: desligar o agendamento de GPU por hardware, a economia de energia do PCIe (na tomada) e a inicialização rápida. Cada uma pede confirmação, guarda o valor original em `%LOCALAPPDATA%\Telomera\config-antes.json` e pode ser revertida de uma vez em **Desfazer as mudanças de configuração**;
- **guias passo a passo**: testar com outra fonte de alimentação e limitar a energia da placa de vídeo (Afterburner ou `nvidia-smi`);
- **BIOS e chipset**: mostra a BIOS instalada e abre a página de suporte do fabricante da placa-mãe (Gigabyte, ASUS, MSI, ASRock; busca para os demais) e a página oficial de chipset da AMD ou da Intel. O Telomera não consegue saber sozinho qual é a BIOS mais nova;
- **autoteste**: confere neste Windows se cada recurso funciona (interface, vídeo, sensores, SMART, testes de memória e disco) e gera um texto para mandar ao desenvolvedor se algo falhar;
- ver **o que o Telomera já mudou neste computador**, com a data e como desfazer cada alteração (o histórico fica em `%LOCALAPPDATA%\Telomera\alteracoes.jsonl`).

Na tela de resultados também há **Salvar em PDF** (usa o Microsoft Edge ou o Google Chrome já instalados).

## Onde fica cada coisa

- **Tela inicial:** *Verificar meu computador*, *Testar desempenho*, *Ferramentas de reparo* e *Configurações*, mais a última nota de saúde.
- **Ferramentas de reparo:** restauração (pontos de restauração), reparos do Windows (rede, Windows Update, Microsoft Store, CHKDSK), limpeza e backup e *Desfazer o que o Telomera fez* (histórico de alterações, bloqueios de driver e drivers salvos).
- **Configurações:** opções da verificação (usar a internet, verificar discos, verificação profunda), verificação semanal automática (com escolha de dia e horário), histórico da nota de saúde, pasta das verificações anteriores, procurar atualização e recriar atalho. As escolhas ficam salvas para a próxima vez.

## Nota de saúde e verificação semanal automática

- **Nota de saúde (0 a 100):** cada verificação recebe uma nota. Ela começa em 100 e perde pontos por problema encontrado (12 por crítico, 4 por aviso, e menos quando o aviso costuma ser normal; cada categoria perde no máximo 30). Aparece na faixa de resultado, no relatório e na tela inicial, com a diferença em relação à verificação anterior. Em *Configurações* há o histórico das notas. É um guia para acompanhar a tendência, não um laudo.
- **Verificação semanal automática (opcional):** em *Configurações* dá para ativar uma tarefa do Windows que, uma vez por semana, faz uma verificação rápida **somente de leitura** (sem corrigir nada e sem usar a internet). Se a nota cair 5 pontos ou mais, ou aparecer um problema crítico novo, o Telomera avisa com uma notificação e com um aviso na tela inicial. As 4 verificações automáticas mais recentes ficam em `%LOCALAPPDATA%\Telomera\Agendadas`. Para desativar, use o botão correspondente ou remova a tarefa "Telomera - verificação semanal" no Agendador de Tarefas.

## O que o Telomera nunca faz sozinho

- Só altera o Windows depois do seu "Sim", e oferece criar um ponto de restauração e guardar uma cópia dos drivers antes de corrigir.
- Nunca apaga arquivos pessoais (a limpeza só mexe em temporários com mais de 2 dias; o backup só copia), nunca formata discos nem mexe em BIOS, nunca desativa antivírus ou firewall, nunca troca senhas ou contas e não instala programas.
- Nunca envia informações do seu computador para ninguém. A internet é usada só para consultar o Windows Update e testar a conexão (opção da verificação) e para ler a versão mais recente (botão de atualização). Esse texto também está na tela inicial: *O que o Telomera faz e o que nunca faz sozinho*.

## Instalação opcional

Para instalar o Telomera para o seu usuário (sem precisar de administrador), dê duplo clique em **`Instalar-Telomera.bat`**: ele copia o programa para `%LOCALAPPDATA%\Programs\Telomera`, cria os atalhos e registra o Telomera em *Aplicativos e recursos*. Para remover, use esse mesmo lugar ou **`Desinstalar-Telomera.bat`** (os relatórios da Área de Trabalho e as alterações já feitas no Windows são mantidos; para desfazer os bloqueios de driver, use antes o botão correspondente em Ferramentas de reparo).

**Só o instalador:** o `Instalar-Telomera.bat` também funciona sozinho. Sem os outros arquivos ao lado, ele baixa a versão mais recente do repositório público de versões, confere o SHA-256 do pacote e instala. Dentro do Telomera, o botão **Procurar atualização** (em Configurações) faz o mesmo caminho: só consulta o `latest.json` e, se você aceitar, baixa e instala a versão nova. Nada sobre o seu computador é enviado.

Para quem mantém o projeto: **`Gerar-Release.ps1`** monta o ZIP versionado, o `SHA256SUMS.txt` e o `latest.json` na pasta `dist\`. Para publicar, copie o ZIP e o `latest.json` para a branch `main` do repositório público de versões (`Tanukib/WinDiag-releases`).

## Idioma

A interface fica em inglês quando o Windows está em inglês (ou com a variável de ambiente `WINDIAG_IDIOMA=en`; use `pt` para forçar o português). A tradução é **parcial**: botões, títulos, textos fixos e as principais caixas de diálogo. Os resultados do diagnóstico (descrições dos problemas e o que fazer) continuam em português.

## Avisos do SmartScreen e do antivírus

O Telomera é um conjunto de scripts **sem assinatura digital** (um certificado de assinatura de código é pago). Por isso o Windows pode mostrar avisos. Quem mantém o projeto e tiver um certificado pode assinar os `.ps1` com `Assinar-Telomera.ps1` ou `Gerar-Release.ps1 -Assinar -Thumbprint <impressão digital>` (os `.bat` não podem ser assinados). Confira sempre o SHA-256 do ZIP em `SHA256SUMS.txt`. Avisos possíveis:

- **"O Windows protegeu o computador" (SmartScreen):** clique em **Mais informações** e depois em **Executar assim mesmo**. Rodar `Criar-Atalho.bat` antes evita esse aviso nas próximas aberturas.
- **Antivírus:** alguns desconfiam de scripts que mexem em drivers. O código é aberto e pode ser lido por inteiro; o Telomera não envia nada para a internet e só altera o sistema com a sua confirmação.
- Se o ZIP veio da internet, use o botão direito no ZIP > **Propriedades** > **Desbloquear** antes de extrair.

## Testando em outros computadores

Antes de compartilhar com muita gente, vale rodar em máquinas diferentes. Sugestão de roteiro:

1. Windows 10 e Windows 11; computador de mesa e notebook (a bateria aparece só nele); escala da tela em 100% e 150%.
2. Primeiro **sem** administrador (só verificar), depois **com** administrador.
3. Verificação completa, **Ver mais** em alguns cartões, **Copiar resumo**, filtro por categoria e a aba **Meu computador**.
4. Corrigir com **Perguntar a cada uma** e, em outra máquina, com **Aceitar tudo**; testar **Parar depois desta correção** e **Desfazer alterações**.
5. Se algo falhar, peça a quem testou:
   - o arquivo `%LOCALAPPDATA%\Telomera\erros.log`;
   - a pasta da verificação (`Verificacao_...` dentro de `Telomera` na Área de Trabalho);
   - a versão do Windows e um print da tela.

## Driver de vídeo sobrescrito pelo Windows Update

Um problema comum no Windows 10/11: você instala o driver da NVIDIA/AMD/Intel, e depois de uma atualização o Windows Update instala outro driver por cima (às vezes mais antigo, às vezes o genérico "Microsoft Basic Display Adapter"). Os relatos apontam que o Windows Update dá prioridade ao driver que ele entrega, e a Intel recomenda reinstalar o driver depois que ele for removido.

O que o Telomera faz:

1. **Detecta**: compara o driver em uso com os pacotes do fabricante que o Windows ainda guarda (DriverStore) e consulta o histórico do Windows Update dos últimos 90 dias.
2. **Restaura** (com permissão): reinstala o pacote mais novo do fabricante que está guardado, com `pnputil /add-driver /install`. O `pnputil` não força um driver que o Windows considere pior; nesse caso o Telomera oferece, com nova confirmação, a instalação forçada pelo mesmo método do Gerenciador de Dispositivos.
3. **Protege** (com permissão): oferece bloquear, por ID de hardware, a troca automática do driver daquela placa. Opcionalmente, em edições que não são Home, exclui drivers das atualizações de qualidade do Windows Update.

**O que você precisa saber sobre o bloqueio:** enquanto ele existe, o Windows também impede a instalação **manual** de drivers para aquele dispositivo (inclusive o instalador do fabricante). Por isso:

- O Telomera suspende o bloqueio sozinho só durante uma restauração e o reativa logo depois.
- Para atualizar o driver por conta própria, rode `Executar-Telomera.bat -DesfazerBloqueios`, instale o driver e, se quiser, ative a proteção de novo.
- O valor `DenyDeviceIDsRetroactive` é sempre gravado como `0` (com `1` o Windows desinstalaria o dispositivo já instalado), e existe um teste automatizado para isso.
- Só os bloqueios criados pelo próprio Telomera são removidos pelo `-DesfazerBloqueios`.

## Restauração de drivers e permissões

Cada ação de restauração mostra o que vai fazer e **pede a sua confirmação**:

- **Restaurar o driver guardado no sistema** (DriverStore) para um dispositivo com erro ou com driver trocado.
- **Voltar ao driver nativo do Windows**: remove o pacote de terceiros (uma cópia é exportada antes, com o comando para desfazer) e o Windows volta a usar o driver embutido. Nunca é oferecido para pacotes críticos de inicialização.
- **Drivers internos do sistema** (chipset, armazenamento, processador, USB, barramento) exigem digitar `RESTAURAR`; um simples "s" não basta.
- Antes da primeira alteração, o Telomera oferece criar um **ponto de restauração** e exportar uma **cópia dos drivers de terceiros**.
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

O Telomera aponta apenas para fontes oficiais: o Microsoft Update Catalog e as páginas de download dos fabricantes. Ele não baixa nem executa nenhum driver da internet sozinho. Evite "atualizadores de driver" de terceiros; muitos instalam programas indesejados e drivers errados.

## Limitações

- Não há um `.exe`: o Telomera é um script PowerShell para que qualquer pessoa possa ler o código antes de rodar. Um `.exe` não assinado costuma ser bloqueado pelo SmartScreen e por antivírus.
- **Só Windows** (Windows 10 1809 ou superior e Windows 11, com Windows PowerShell 5.1).
- As funções independentes de Windows e o protocolo da interface têm testes automáticos; a janela e o fluxo completo dependem do Windows e **ainda precisam de testes em máquinas reais**. Se algo falhar, abra uma issue anexando o `.log` (revise-o antes).
- O SMART detalhado (erros de CRC do cabo, setores pendentes e remapeados) depende de o disco e o driver exporem os atributos e de o Telomera estar como administrador; discos NVMe podem não mostrar. Não substitui as ferramentas do fabricante do SSD/HD.
- Sem HWiNFO, o Telomera lê só o que o Windows oferece: frequência do processador, temperatura do disco e zona térmica da placa (quando existe). **A temperatura do processador não é lida sem um programa de sensores.**
- "Driver antigo" é uma heurística (data do driver); só um site de fabricante diz se existe versão nova.
- Algumas leituras (SMART via WMI, temperatura ACPI, bateria) dependem do suporte do equipamento; em máquinas virtuais podem vir vazias.
- A restauração só encontra drivers que o Windows ainda guarda no DriverStore; se o pacote foi removido, use os links do relatório.
- O bloqueio por ID de hardware e a exclusão de drivers são políticas do Windows; a exclusão global pode não ter efeito no Windows Home.

## Arquivos

| Arquivo | Para quê |
|---|---|
| `Abrir-Telomera.bat` | Abre a interface gráfica (duplo clique) |
| `Telomera-GUI.ps1` | A janela (Windows Forms, já incluído no Windows) |
| `Telomera-Extras.ps1` | Verificações extras, ferramentas de reparo, comparação entre verificações e histórico de alterações |
| `Instalar-Telomera.bat` / `Desinstalar-Telomera.bat` | Instala/remove o Telomera para o usuário atual |
| `Gerar-Release.ps1` | Gera o ZIP versionado e os checksums (para publicar no GitHub) |
| `Telomera-Bench.ps1` | Teste de desempenho: processador, memória RAM, disco e placa de vídeo |
| `Telomera-Monitor.ps1` | Monitor em tempo real (HWiNFO, MSI Afterburner, LibreHardwareMonitor) com registro à prova de queda |
| `Assinar-Telomera.ps1` | Assina os `.ps1` com um certificado de assinatura de código (para o mantenedor) |
| `Telomera-Worker.ps1` | Ponte entre a janela e o motor; roda em segundo plano |
| `Telomera.ps1` | O motor de diagnóstico e reparo (também funciona sozinho, no console) |
| `Criar-Atalho.bat` / `Criar-Atalho.ps1` | Cria o atalho com ícone na Área de Trabalho e no Menu Iniciar |
| `Executar-Telomera.bat` | Abre a versão de console |
| `.github/workflows/testes.yml` | Testes automáticos no GitHub Actions |
| `tests/` | Testes automatizados |

A interface não reimplementa nada: ela usa as mesmas funções do `Telomera.ps1`. As perguntas do console viram caixas de diálogo e o `Write-Host` vira o painel de detalhes.

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

- A janela em si (`Telomera-GUI.ps1`) só pode ser testada no Windows. Ao mexer nela, teste com e sem administrador e com a escala da tela em 100% e 150%.
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

O Telomera só faz o que é necessário: o ponto de restauração é criado uma vez; a cópia dos drivers (que leva minutos) só é feita se a correção mexe em drivers; o `DISM /RestoreHealth` só roda se a verificação rápida (`/CheckHealth`) achar problema; e o `SFC` só roda se há sinais (telas azuis, falhas do sistema de arquivos) ou se você marcar "Verificação profunda" em Configurações (ou usar `-VerificacaoProfunda`).

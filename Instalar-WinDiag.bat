@echo off
title Instalar o WinDiag
rem Se o Instalar-WinDiag.ps1 estiver ao lado deste arquivo (pacote completo), usa ele.
rem Se este arquivo foi enviado sozinho, baixa a versao oficial mais recente, confere o SHA-256 e instala.
if exist "%~dp0Instalar-WinDiag.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Instalar-WinDiag.ps1"
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$f='%~f0'; $t=[IO.File]::ReadAllText($f,[Text.Encoding]::UTF8); $i=$t.IndexOf('#'+'PAYLOAD'+'#'); Invoke-Expression $t.Substring($i+9)"
)
echo.
pause
exit /b
#PAYLOAD#
#region nucleo
$ErrorActionPreference = 'Stop'
$UrlBase = 'https://raw.githubusercontent.com/Tanukib/WinDiag-releases/main'
if ($env:WD_TESTE_URL_BASE) { $UrlBase = $env:WD_TESTE_URL_BASE }   # só para os testes automáticos
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }
$ua = @{ 'User-Agent' = 'WinDiag-Instalador' }

function Get-UltimaVersao {
    # Lê latest.json do canal de versões: @{ versao; arquivo; sha256 }
    $r = Invoke-WebRequest -Uri "$UrlBase/latest.json" -UseBasicParsing -Headers $ua -TimeoutSec 30
    $txt = $r.Content
    if ($txt -is [byte[]]) { $txt = [Text.Encoding]::UTF8.GetString($txt) }
    $j = $txt.TrimStart([char]0xFEFF) | ConvertFrom-Json
    if (-not $j.versao -or -not $j.arquivo -or -not $j.sha256) { throw 'O arquivo latest.json está incompleto.' }
    if ($j.arquivo -notmatch '^WinDiag-v[0-9][0-9A-Za-z.\-]*\.zip$') { throw 'Nome de pacote inesperado no latest.json.' }
    return $j
}

function Get-PacoteWinDiag {
    # Baixa o ZIP, confere o SHA-256 e extrai em $Pasta. Devolve a pasta que contém o WinDiag-GUI.ps1.
    param($Info, [string]$Pasta)
    New-Item -ItemType Directory -Force -Path $Pasta | Out-Null
    $zip = Join-Path $Pasta $Info.arquivo
    Invoke-WebRequest -Uri "$UrlBase/$($Info.arquivo)" -OutFile $zip -UseBasicParsing -Headers $ua -TimeoutSec 300
    $real = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLower()
    if ($real -ne ([string]$Info.sha256).ToLower()) { throw 'O arquivo baixado não confere com o SHA-256 esperado. Nada foi instalado.' }
    $dest = Join-Path $Pasta 'pacote'
    Expand-Archive -LiteralPath $zip -DestinationPath $dest -Force
    $gui = Get-ChildItem -LiteralPath $dest -Recurse -Filter 'WinDiag-GUI.ps1' | Select-Object -First 1
    if (-not $gui) { throw 'O pacote baixado não contém o WinDiag.' }
    return $gui.DirectoryName
}

function Test-VersaoNova {
    param([string]$Atual, [string]$Nova)
    try { return ([version]($Nova -replace '[^0-9.].*$', '')) -gt ([version]($Atual -replace '[^0-9.].*$', '')) } catch { return ($Nova -ne $Atual) }
}
#endregion nucleo
try {
    Write-Host ''
    Write-Host 'WinDiag - instalador' -ForegroundColor Cyan
    Write-Host 'Procurando a versão mais recente...'
    $info = Get-UltimaVersao
    $tmp = Join-Path $env:TEMP ('WinDiag-inst-' + [guid]::NewGuid().ToString('N'))
    try {
        Write-Host "Baixando o WinDiag $($info.versao)..." -ForegroundColor Cyan
        $pasta = Get-PacoteWinDiag -Info $info -Pasta $tmp
        & (Join-Path $pasta 'Instalar-WinDiag.ps1')
    } finally {
        try { Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue } catch { }
    }
} catch {
    Write-Host ''
    Write-Host "Não foi possível instalar: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Verifique a conexão com a internet e tente de novo.'
}

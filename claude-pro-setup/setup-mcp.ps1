<#
.SYNOPSIS
    Ajoute les serveurs MCP ne demandant aucune authentification, puis teste la connexion.
.DESCRIPTION
    Les serveurs necessitant OAuth ou une cle (GitHub, Figma, Supabase, Context7)
    ne sont PAS ajoutes : ils exigent votre intervention. Voir docs\MCP.md.
.PARAMETER WithDevTools
    Ajoute aussi chrome-devtools (recouvre partiellement Playwright).
#>
[CmdletBinding()]
param([switch]$WithDevTools)

$ErrorActionPreference = 'Continue'

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  [FAIL] Commande 'claude' introuvable dans le PATH." -ForegroundColor Red; exit 1
}
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
    Write-Host "  [FAIL] npx introuvable : installez Node.js." -ForegroundColor Red; exit 1
}

Write-Host ""
Write-Host "  Installation des serveurs MCP sans authentification" -ForegroundColor White
Write-Host "  Note : chaque MCP actif occupe du contexte en permanence." -ForegroundColor Gray

$existing = (& claude mcp list 2>&1 | Out-String)

function Add-Mcp {
    param([string]$Name, [string[]]$Command)
    if ($existing -match "(?m)^$([regex]::Escape($Name)):") {
        Write-Host "  [INFO] $Name deja configure" -ForegroundColor Gray; return
    }
    & claude mcp add $Name -s user -- @Command | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  [OK]   $Name ajoute" -ForegroundColor Green }
    else { Write-Host "  [FAIL] $Name : echec de l'ajout" -ForegroundColor Red }
}

Write-Host "`n=== Ajout" -ForegroundColor Cyan
Add-Mcp 'playwright' @('npx','-y','@playwright/mcp@latest')
if ($WithDevTools) {
    Add-Mcp 'chrome-devtools' @('npx','-y','chrome-devtools-mcp@latest')
} else {
    Write-Host "  [INFO] chrome-devtools non ajoute (recouvre partiellement playwright)." -ForegroundColor Gray
    Write-Host "         Relancez avec -WithDevTools pour l'analyse de performance." -ForegroundColor Gray
}

Write-Host "`n=== Test de connexion reel" -ForegroundColor Cyan
$out = (& claude mcp list 2>&1 | Out-String)
($out -split "`n") | Where-Object { $_ -match '^(playwright|chrome-devtools):' } | ForEach-Object { Write-Host "  $_" }

if ($out -match 'playwright.*Connected') { Write-Host "  [OK]   playwright operationnel" -ForegroundColor Green }
else { Write-Host "  [FAIL] playwright non connecte" -ForegroundColor Red }

Write-Host "`n  Serveurs necessitant VOTRE intervention (non automatisables) :"
Write-Host "   - GitHub   : OAuth ou jeton personnel"
Write-Host "   - Figma    : OAuth dans le navigateur"
Write-Host "   - Supabase : jeton d'acces personnel"
Write-Host "   - Context7 : cle API (authentification requise, verifie)"
Write-Host "  Commandes exactes dans docs\MCP.md"
Write-Host ""

<#
.SYNOPSIS
    Ajoute la marketplace officielle Anthropic et installe les plugins recommandes.
.DESCRIPTION
    Portee utilisateur : les plugins sont disponibles dans tous vos projets.
    Idempotent : un plugin deja installe est signale, pas reinstalle.
    Aucun plugin communautaire n'est installe par ce script.
.PARAMETER Optional
    Installe aussi les plugins optionnels (commit-commands, security-guidance,
    pr-review-toolkit).
#>
[CmdletBinding()]
param([switch]$Optional)

$ErrorActionPreference = 'Continue'

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  [FAIL] Commande 'claude' introuvable dans le PATH." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  Installation des plugins Claude Code (marketplace officielle)" -ForegroundColor White

# --- marketplace
Write-Host "`n=== Marketplace officielle" -ForegroundColor Cyan
$mp = (& claude plugin marketplace list 2>&1 | Out-String)
if ($mp -match 'claude-code-plugins') {
    Write-Host "  [INFO] Marketplace deja configuree" -ForegroundColor Gray
} else {
    & claude plugin marketplace add anthropics/claude-code
    if ($LASTEXITCODE -eq 0) { Write-Host "  [OK]   Marketplace ajoutee" -ForegroundColor Green }
    else { Write-Host "  [FAIL] Ajout de la marketplace echoue" -ForegroundColor Red; exit 1 }
}

# --- plugins
$plugins = @('frontend-design','feature-dev','code-review','plugin-dev')
if ($Optional) { $plugins += @('commit-commands','security-guidance','pr-review-toolkit') }

Write-Host "`n=== Plugins" -ForegroundColor Cyan
$installed = (& claude plugin list 2>&1 | Out-String)
$done = 0; $skipped = 0; $failed = @()

foreach ($p in $plugins) {
    if ($installed -match [regex]::Escape("$p@claude-code-plugins")) {
        Write-Host "  [INFO] $p deja installe" -ForegroundColor Gray
        $skipped++
        continue
    }
    & claude plugin install "$p@claude-code-plugins" | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  [OK]   $p installe" -ForegroundColor Green; $done++ }
    else { Write-Host "  [FAIL] $p : echec" -ForegroundColor Red; $failed += $p }
}

# --- verification reelle
Write-Host "`n=== Verification" -ForegroundColor Cyan
$final = (& claude plugin list 2>&1 | Out-String)
$confirmed = @()
foreach ($p in $plugins) {
    if ($final -match [regex]::Escape("$p@claude-code-plugins")) { $confirmed += $p }
}
Write-Host "  Confirmes comme installes : $($confirmed.Count) / $($plugins.Count)"
foreach ($p in $plugins) {
    if ($confirmed -contains $p) { Write-Host "   [OK]   $p" -ForegroundColor Green }
    else                         { Write-Host "   [FAIL] $p non confirme" -ForegroundColor Red }
}

Write-Host ""
Write-Host "  Installes : $done   Deja presents : $skipped   Echecs : $($failed.Count)"
if ($failed.Count -gt 0) { Write-Host "  Echecs : $($failed -join ', ')" -ForegroundColor Red }
Write-Host "  Redemarrez Claude Code pour charger les plugins."
Write-Host ""
if ($confirmed.Count -lt $plugins.Count) { exit 1 }

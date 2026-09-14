<#
.SYNOPSIS
    Audit post-installation de la configuration Claude Code.
.DESCRIPTION
    Controle reel de chaque element. Statuts : PASS / WARNING / FAIL.
    Aucun element n'est declare conforme sans verification effective.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$ClaudeHome = Join-Path $env:USERPROFILE '.claude'
$Rows = New-Object System.Collections.ArrayList

function Add-Row {
    param([ValidateSet('PASS','WARNING','FAIL')][string]$Status,[string]$Element,[string]$Detail)
    [void]$Rows.Add([pscustomobject]@{ Statut = $Status; Element = $Element; Detail = $Detail })
}

Write-Host ""
Write-Host "  AUDIT DE LA CONFIGURATION CLAUDE CODE" -ForegroundColor White
Write-Host "  Cible : $ClaudeHome"
Write-Host ""

# --- Claude Code
$cc = Get-Command claude -ErrorAction SilentlyContinue
if ($cc) {
    try   { Add-Row PASS 'Claude Code' ((& claude --version 2>&1 | Select-Object -First 1)) }
    catch { Add-Row WARNING 'Claude Code' 'presente mais --version a echoue' }
} else {
    Add-Row FAIL 'Claude Code' "commande 'claude' introuvable dans le PATH"
}

# --- CLAUDE.md
$md = Join-Path $ClaudeHome 'CLAUDE.md'
if (Test-Path $md) {
    $lines = @(Get-Content $md).Count
    if ($lines -gt 150) { Add-Row WARNING 'CLAUDE.md' "$lines lignes - trop long, deplacer les procedures dans des Skills" }
    else                { Add-Row PASS    'CLAUDE.md' "present, $lines lignes" }
} else {
    Add-Row FAIL 'CLAUDE.md' 'absent'
}
if (Test-Path (Join-Path $ClaudeHome 'CLAUDE.md.nouveau')) {
    Add-Row WARNING 'CLAUDE.md.nouveau' 'fusion manuelle en attente'
}

# --- settings.json
$set = Join-Path $ClaudeHome 'settings.json'
if (Test-Path $set) {
    try   { $null = Get-Content $set -Raw -Encoding UTF8 | ConvertFrom-Json; Add-Row PASS 'settings.json' 'JSON valide' }
    catch { Add-Row FAIL 'settings.json' 'JSON INVALIDE' }
} else {
    Add-Row WARNING 'settings.json' 'absent'
}

# --- structure
$missing = @()
foreach ($d in 'skills','agents','rules','backups','logs','templates') {
    if (-not (Test-Path (Join-Path $ClaudeHome $d))) { $missing += $d }
}
if ($missing.Count -eq 0) { Add-Row PASS 'Structure .claude' 'skills, agents, rules, backups, logs, templates' }
else                      { Add-Row WARNING 'Structure .claude' ("manquant : " + ($missing -join ', ')) }

# --- skills
$skillsDir = Join-Path $ClaudeHome 'skills'
$skills = @()
if (Test-Path $skillsDir) {
    $skills = @(Get-ChildItem $skillsDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })
}
if     ($skills.Count -ge 27) { Add-Row PASS    'Skills' "$($skills.Count) Skills avec SKILL.md" }
elseif ($skills.Count -gt 0)  { Add-Row WARNING 'Skills' "$($skills.Count) Skills (27 attendues)" }
else                          { Add-Row FAIL    'Skills' 'aucune Skill detectee' }

# --- frontmatter
$bad = 0
foreach ($s in $skills) {
    $content = Get-Content (Join-Path $s.FullName 'SKILL.md') -Raw -Encoding UTF8
    if ($content -notmatch '(?m)^---\s*$')      { $bad++ }
    if ($content -notmatch '(?m)^name:')        { $bad++ }
    if ($content -notmatch '(?m)^description:') { $bad++ }
}
if ($bad -eq 0) { Add-Row PASS 'Frontmatter Skills' 'name + description presents partout' }
else            { Add-Row FAIL 'Frontmatter Skills' "$bad anomalie(s)" }

# --- agents
$agentsDir = Join-Path $ClaudeHome 'agents'
$agents = @()
if (Test-Path $agentsDir) { $agents = @(Get-ChildItem $agentsDir -Filter '*.md' -File) }
if     ($agents.Count -ge 10) { Add-Row PASS    'Sous-agents' "$($agents.Count) agents" }
elseif ($agents.Count -gt 0)  { Add-Row WARNING 'Sous-agents' "$($agents.Count) agents (10 attendus)" }
else                          { Add-Row FAIL    'Sous-agents' 'aucun agent detecte' }

# --- skills cles
foreach ($s in 'web-design-pro','context-token-manager','memory-manager','quality-controller','project-orchestrator') {
    if (Test-Path (Join-Path $skillsDir "$s\SKILL.md")) { Add-Row PASS "Skill $s" 'presente' }
    else                                                { Add-Row FAIL "Skill $s" 'absente' }
}

# --- references a la demande
$refs = @()
if (Test-Path $skillsDir) { $refs = @(Get-ChildItem $skillsDir -Recurse -File -Filter '*.md' | Where-Object { $_.DirectoryName -like '*references*' }) }
if ($refs.Count -gt 0) { Add-Row PASS 'References a la demande' "$($refs.Count) fichier(s) hors contexte permanent" }
else                   { Add-Row WARNING 'References a la demande' 'aucune' }

# --- plugins
if ($cc) {
    $env:CI = '1'
    $p = (& claude plugin list 2>&1 | Out-String)
    if ($p -match 'No plugins installed') { Add-Row WARNING 'Plugins' 'aucun plugin installe (voir docs\PLUGINS.md)' }
    else { Add-Row PASS 'Plugins' (($p -split "`n" | Where-Object { $_.Trim() }).Count.ToString() + ' ligne(s) retournee(s)') }
} else {
    Add-Row WARNING 'Plugins' 'non verifiable : CLI absente'
}

# --- MCP
if ($cc) {
    $m = (& claude mcp list 2>&1 | Out-String)
    if ($m -match 'No MCP servers configured') { Add-Row WARNING 'MCP' 'aucun serveur MCP configure (voir docs\MCP.md)' }
    else { Add-Row PASS 'MCP' (($m -split "`n" | Where-Object { $_.Trim() }).Count.ToString() + ' ligne(s) retournee(s)') }
} else {
    Add-Row WARNING 'MCP' 'non verifiable : CLI absente'
}

# --- memoire
if (Test-Path (Join-Path $ClaudeHome 'templates\memoire-projet.md')) {
    Add-Row PASS 'Modeles de memoire' 'templates\memoire-projet.md present'
} else {
    Add-Row WARNING 'Modeles de memoire' 'absent'
}

# --- secrets
$pattern = 'sk-ant-[A-Za-z0-9]|ghp_[A-Za-z0-9]{20}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
$leaks = @()
foreach ($d in 'skills','agents','rules','templates') {
    $p = Join-Path $ClaudeHome $d
    if (Test-Path $p) {
        $leaks += @(Get-ChildItem $p -Recurse -File -ErrorAction SilentlyContinue |
                    Where-Object { (Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue) -match $pattern })
    }
}
if ($leaks.Count -eq 0) { Add-Row PASS 'Absence de secrets' 'aucun secret detecte dans la configuration' }
else                    { Add-Row FAIL 'Absence de secrets' "$($leaks.Count) fichier(s) suspect(s)" }

# --- sauvegardes
$bk = Join-Path $ClaudeHome 'backups'
if (Test-Path $bk) {
    $b = @(Get-ChildItem $bk -Directory -Filter 'pro-setup-*' -ErrorAction SilentlyContinue)
    if ($b.Count -gt 0) {
        $last = ($b | Sort-Object Name | Select-Object -Last 1).FullName
        Add-Row PASS 'Sauvegarde' "$($b.Count) sauvegarde(s), derniere : $last"
    } else {
        Add-Row WARNING 'Sauvegarde' 'aucune sauvegarde pro-setup (installation neuve ?)'
    }
} else {
    Add-Row WARNING 'Sauvegarde' 'dossier backups absent'
}

# --- rendu
$Rows | Format-Table -AutoSize -Property Statut, Element, Detail | Out-String -Width 200 | Write-Host

$pass = @($Rows | Where-Object Statut -eq 'PASS').Count
$warn = @($Rows | Where-Object Statut -eq 'WARNING').Count
$fail = @($Rows | Where-Object Statut -eq 'FAIL').Count

Write-Host "  PASS: $pass   WARNING: $warn   FAIL: $fail" -ForegroundColor White
Write-Host ""
if ($fail -gt 0) { exit 1 } else { exit 0 }

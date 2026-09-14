<#
.SYNOPSIS
    Installe la configuration Claude Code professionnelle dans %USERPROFILE%\.claude

.DESCRIPTION
    - Sauvegarde horodatée de toute configuration existante AVANT modification.
    - Fusion non destructive : aucune Skill, aucun agent, aucun MCP existant n'est supprimé.
    - settings.json est fusionné clé par clé ; les valeurs existantes sont conservées
      par défaut (l'utilisateur garde la main).
    - Idempotent : peut être relancé sans dommage.

.PARAMETER Force
    Écrase les fichiers du paquet déjà présents (Skills, agents, règles, modèles).
    Sans -Force, un fichier existant est conservé et signalé.

.PARAMETER OverwriteClaudeMd
    Remplace un CLAUDE.md global existant. Sans ce paramètre, le CLAUDE.md du paquet
    est écrit à côté sous le nom CLAUDE.md.nouveau pour fusion manuelle.

.PARAMETER DryRun
    N'écrit rien. Affiche ce qui serait fait.

.EXAMPLE
    .\install.ps1
    .\install.ps1 -Force
    .\install.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$OverwriteClaudeMd,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# ---------------------------------------------------------------- helpers
$script:Warnings = @()
$script:Actions  = @()

function Write-Step   { param([string]$m) Write-Host "`n=== $m" -ForegroundColor Cyan }
function Write-Ok     { param([string]$m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Info   { param([string]$m) Write-Host "  [INFO] $m" -ForegroundColor Gray }
function Write-Warn2  { param([string]$m) Write-Host "  [WARN] $m" -ForegroundColor Yellow; $script:Warnings += $m }
function Write-Err2   { param([string]$m) Write-Host "  [FAIL] $m" -ForegroundColor Red }

function Invoke-Action {
    param([string]$Description, [scriptblock]$Action)
    if ($DryRun) { Write-Info "SIMULATION : $Description"; return }
    & $Action
    $script:Actions += $Description
}

# ---------------------------------------------------------------- chemins
$PayloadDir = Join-Path $PSScriptRoot 'payload'
if (-not (Test-Path $PayloadDir)) {
    Write-Err2 "Dossier 'payload' introuvable a cote de ce script : $PayloadDir"
    exit 1
}

$ClaudeHome = Join-Path $env:USERPROFILE '.claude'
$Stamp      = Get-Date -Format 'yyyyMMdd-HHmmss'
$BackupDir  = Join-Path $ClaudeHome "backups\pro-setup-$Stamp"

Write-Host ""
Write-Host "  Installation de la configuration Claude Code professionnelle" -ForegroundColor White
Write-Host "  Cible : $ClaudeHome"
if ($DryRun) { Write-Host "  MODE SIMULATION - aucune ecriture" -ForegroundColor Yellow }

# ---------------------------------------------------------------- 1. audit
Write-Step '1/7  Audit de l''installation existante'

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeCmd) {
    try {
        $ver = (& claude --version 2>&1 | Select-Object -First 1)
        Write-Ok "Claude Code detecte : $ver"
    } catch {
        Write-Warn2 "Commande 'claude' trouvee mais --version a echoue : $($_.Exception.Message)"
    }
} else {
    Write-Warn2 "Commande 'claude' introuvable dans le PATH. L'installation des fichiers se poursuit, mais verifiez que Claude Code est installe."
}

if (Test-Path $ClaudeHome) {
    Write-Ok "Dossier .claude existant trouve"
    foreach ($sub in 'skills','agents','rules','templates','plugins') {
        $p = Join-Path $ClaudeHome $sub
        if (Test-Path $p) {
            $n = @(Get-ChildItem $p -ErrorAction SilentlyContinue).Count
            Write-Info "$sub : $n element(s) existant(s)"
        }
    }
} else {
    Write-Info "Aucun dossier .claude : creation complete"
}

# ---------------------------------------------------------------- 2. sauvegarde
Write-Step '2/7  Sauvegarde horodatee'

if (Test-Path $ClaudeHome) {
    $toBackup = @()
    foreach ($item in 'CLAUDE.md','settings.json','settings.local.json','skills','agents','rules','templates','commands') {
        $p = Join-Path $ClaudeHome $item
        if (Test-Path $p) { $toBackup += $p }
    }
    $globalJson = Join-Path $env:USERPROFILE '.claude.json'
    if (Test-Path $globalJson) { $toBackup += $globalJson }

    if ($toBackup.Count -gt 0) {
        Invoke-Action "Sauvegarde vers $BackupDir" {
            New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
            foreach ($p in $toBackup) {
                Copy-Item $p -Destination $BackupDir -Recurse -Force
            }
        }
        if (-not $DryRun) { Write-Ok "Sauvegarde creee : $BackupDir" }
        Write-Info "Elements sauvegardes : $($toBackup.Count)"
    } else {
        Write-Info 'Rien a sauvegarder (aucune configuration existante)'
    }
} else {
    Write-Info 'Pas de dossier .claude : aucune sauvegarde necessaire'
}

# ---------------------------------------------------------------- 3. structure
Write-Step '3/7  Creation de la structure'

foreach ($d in 'skills','agents','rules','backups','logs','templates','commands') {
    $p = Join-Path $ClaudeHome $d
    if (Test-Path $p) {
        Write-Info "$d\ existe deja"
    } else {
        Invoke-Action "Creation de $d\" { New-Item -ItemType Directory -Path $p -Force | Out-Null }
        if (-not $DryRun) { Write-Ok "$d\ cree" }
    }
}

# ---------------------------------------------------------------- 4. copie
Write-Step '4/7  Installation des Skills, agents, regles et modeles'

function Copy-Tree {
    param([string]$Source, [string]$Target, [string]$Label)
    if (-not (Test-Path $Source)) { Write-Warn2 "Source absente : $Source"; return }

    $added = 0; $kept = 0; $replaced = 0
    Get-ChildItem $Source -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($Source.Length).TrimStart('\','/')
        $dst = Join-Path $Target $rel
        $dstDir = Split-Path $dst -Parent

        if (Test-Path $dst) {
            if ($Force) {
                Invoke-Action "Remplacement $Label\$rel" {
                    if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
                    Copy-Item $_.FullName -Destination $dst -Force
                }
                $script:replacedCount++; $replaced++
            } else {
                $kept++
            }
        } else {
            Invoke-Action "Ajout $Label\$rel" {
                if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
                Copy-Item $_.FullName -Destination $dst -Force
            }
            $added++
        }
    }
    Write-Ok "$Label : $added ajoute(s), $replaced remplace(s), $kept conserve(s)"
    if ($kept -gt 0 -and -not $Force) {
        Write-Info "  $kept fichier(s) existant(s) conserve(s). Relancez avec -Force pour les remplacer."
    }
}

$script:replacedCount = 0
Copy-Tree (Join-Path $PayloadDir 'skills')    (Join-Path $ClaudeHome 'skills')    'skills'
Copy-Tree (Join-Path $PayloadDir 'agents')    (Join-Path $ClaudeHome 'agents')    'agents'
Copy-Tree (Join-Path $PayloadDir 'rules')     (Join-Path $ClaudeHome 'rules')     'rules'
Copy-Tree (Join-Path $PayloadDir 'templates') (Join-Path $ClaudeHome 'templates') 'templates'
Copy-Tree (Join-Path $PayloadDir 'commands')  (Join-Path $ClaudeHome 'commands')  'commands'

# ---------------------------------------------------------------- 5. CLAUDE.md
Write-Step '5/7  CLAUDE.md global'

$srcMd = Join-Path $PayloadDir 'CLAUDE.md'
$dstMd = Join-Path $ClaudeHome 'CLAUDE.md'

if (-not (Test-Path $dstMd)) {
    Invoke-Action 'Installation de CLAUDE.md' { Copy-Item $srcMd $dstMd -Force }
    if (-not $DryRun) { Write-Ok 'CLAUDE.md installe' }
} elseif ($OverwriteClaudeMd) {
    Invoke-Action 'Remplacement de CLAUDE.md' { Copy-Item $srcMd $dstMd -Force }
    if (-not $DryRun) { Write-Ok 'CLAUDE.md remplace (ancienne version dans la sauvegarde)' }
} elseif ((Get-FileHash $srcMd).Hash -eq (Get-FileHash $dstMd).Hash) {
    Write-Ok 'CLAUDE.md deja a jour (identique au paquet)'
    $alt = Join-Path $ClaudeHome 'CLAUDE.md.nouveau'
    if ((Test-Path $alt) -and -not $DryRun) { Remove-Item $alt -Force }
} else {
    $alt = Join-Path $ClaudeHome 'CLAUDE.md.nouveau'
    Invoke-Action 'Ecriture de CLAUDE.md.nouveau' { Copy-Item $srcMd $alt -Force }
    Write-Warn2 "CLAUDE.md existe deja et differe : il a ete conserve. La nouvelle version est dans CLAUDE.md.nouveau : fusionnez manuellement, ou relancez avec -OverwriteClaudeMd."
}

# ---------------------------------------------------------------- 6. settings.json
Write-Step '6/7  Fusion de settings.json'

$srcSettings = Join-Path $PayloadDir 'settings.json'
$dstSettings = Join-Path $ClaudeHome 'settings.json'

function ConvertTo-Hashtable {
    param($InputObject)
    if ($null -eq $InputObject) { return $null }
    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        return @($InputObject | ForEach-Object { ConvertTo-Hashtable $_ })
    }
    if ($InputObject -is [PSCustomObject]) {
        $h = @{}
        foreach ($p in $InputObject.PSObject.Properties) { $h[$p.Name] = ConvertTo-Hashtable $p.Value }
        return $h
    }
    return $InputObject
}

try {
    $newSettings = ConvertTo-Hashtable (Get-Content $srcSettings -Raw -Encoding UTF8 | ConvertFrom-Json)

    if (Test-Path $dstSettings) {
        $raw = Get-Content $dstSettings -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace($raw)) { $existing = @{} }
        else { $existing = ConvertTo-Hashtable ($raw | ConvertFrom-Json) }
        Write-Info 'settings.json existant detecte : fusion non destructive'
    } else {
        $existing = @{}
        Write-Info 'Aucun settings.json : creation'
    }

    # Fusion : l'existant gagne toujours sur les cles simples.
    # Les listes de permissions sont unionnees (aucune entree existante perdue).
    $merged = $existing.Clone()

    foreach ($key in $newSettings.Keys) {
        if ($key -eq 'permissions') { continue }
        if (-not $merged.ContainsKey($key)) {
            $merged[$key] = $newSettings[$key]
            Write-Info "  ajout : $key"
        } else {
            Write-Info "  conserve (valeur existante) : $key"
        }
    }

    $newPerms = $newSettings['permissions']
    if ($newPerms) {
        if (-not $merged.ContainsKey('permissions') -or $null -eq $merged['permissions']) {
            $merged['permissions'] = @{}
        }
        $mp = $merged['permissions']
        if ($mp -isnot [hashtable]) { $mp = ConvertTo-Hashtable $mp }

        foreach ($pk in $newPerms.Keys) {
            if ($pk -in @('allow','ask','deny')) {
                $old = @()
                if ($mp.ContainsKey($pk) -and $mp[$pk]) { $old = @($mp[$pk]) }
                $union = @($old + @($newPerms[$pk]) | Select-Object -Unique)
                $mp[$pk] = $union
                Write-Info "  permissions.$pk : $($old.Count) existante(s) -> $($union.Count) apres union"
            } elseif (-not $mp.ContainsKey($pk)) {
                $mp[$pk] = $newPerms[$pk]
                Write-Info "  permissions.$pk : ajout"
            } else {
                Write-Info "  permissions.$pk : conserve"
            }
        }
        $merged['permissions'] = $mp
    }

    $json = $merged | ConvertTo-Json -Depth 12
    # Validation avant ecriture
    $null = $json | ConvertFrom-Json

    Invoke-Action 'Ecriture de settings.json fusionne' {
        [System.IO.File]::WriteAllText($dstSettings, $json, (New-Object System.Text.UTF8Encoding($false)))
    }
    if (-not $DryRun) { Write-Ok 'settings.json fusionne et valide' }

} catch {
    Write-Err2 "Echec de la fusion de settings.json : $($_.Exception.Message)"
    Write-Warn2 'settings.json n''a PAS ete modifie. La sauvegarde reste intacte.'
}

# ---------------------------------------------------------------- 7. verification
Write-Step '7/7  Verification'

$skillCount = 0; $agentCount = 0
$skillsDir = Join-Path $ClaudeHome 'skills'
$agentsDir = Join-Path $ClaudeHome 'agents'

if (Test-Path $skillsDir) {
    $skillCount = @(Get-ChildItem $skillsDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }).Count
}
if (Test-Path $agentsDir) {
    $agentCount = @(Get-ChildItem $agentsDir -Filter '*.md' -File).Count
}

Write-Info "Skills avec SKILL.md : $skillCount"
Write-Info "Agents (.md)         : $agentCount"

if (Test-Path $dstSettings) {
    try {
        $null = Get-Content $dstSettings -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Ok 'settings.json : JSON valide'
    } catch {
        Write-Err2 'settings.json : JSON INVALIDE - restaurez depuis la sauvegarde'
    }
}

if (Test-Path $dstMd) { Write-Ok 'CLAUDE.md present' } else { Write-Warn2 'CLAUDE.md absent' }

# ---------------------------------------------------------------- resume
Write-Host ""
Write-Host "  --------------------------------------------------" -ForegroundColor White
Write-Host "  RESUME" -ForegroundColor White
Write-Host "  --------------------------------------------------" -ForegroundColor White
Write-Host "  Sauvegarde  : $(if (Test-Path $BackupDir) { $BackupDir } else { 'aucune (installation neuve)' })"
Write-Host "  CLAUDE.md   : $dstMd"
Write-Host "  Skills      : $skillsDir  ($skillCount)"
Write-Host "  Agents      : $agentsDir  ($agentCount)"
Write-Host "  Settings    : $dstSettings"

if ($script:Warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "  AVERTISSEMENTS ($($script:Warnings.Count)) :" -ForegroundColor Yellow
    $script:Warnings | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
}

Write-Host ""
Write-Host "  ETAPES SUIVANTES (a faire par vous) :" -ForegroundColor Cyan
Write-Host "   1. Lancez  .\verify.ps1  pour l'audit post-installation."
Write-Host "   2. Plugins et MCP : voir  docs\PLUGINS.md  et  docs\MCP.md"
Write-Host "      (ces etapes demandent une authentification et ne peuvent pas etre automatisees)."
Write-Host "   3. Redemarrez Claude Code pour charger la nouvelle configuration."
Write-Host ""

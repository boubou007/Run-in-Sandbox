# Configuration Claude Code professionnelle

Paquet d'installation complet : 27 Skills, 10 sous-agents, CLAUDE.md global,
settings.json, règles, modèles de mémoire, installateurs et script d'audit.

---

## À lire en premier — pourquoi un paquet et non une installation directe

Cette configuration a été **préparée et testée dans un conteneur Linux distant**,
pas sur votre PC Windows. Une session Claude Code sur le web n'a aucun accès à
votre machine : `%USERPROFILE%\.claude` est hors d'atteinte depuis ici.

Ce qui a donc été fait :

- La configuration complète a été **réellement installée et testée** dans
  l'environnement de préparation (Claude Code 2.1.270), pas simulée.
- Les 27 Skills ont été **détectées et chargées** par Claude Code.
- Les 4 tests demandés ont été **exécutés dans de vraies sessions**.
- Les plugins ont été **réellement installés et vérifiés**.
- Deux serveurs MCP ont été **réellement connectés**.
- Le tout est livré sous forme d'installateur que **vous exécutez sur votre PC**,
  en une commande.

Ce que vous devez faire : lancer `install.ps1`. C'est la seule étape qui ne
pouvait pas être exécutée à votre place.

---

## Installation (Windows)

```powershell
cd chemin\vers\claude-pro-setup

# 1. Voir ce qui serait fait, sans rien ecrire
.\install.ps1 -DryRun

# 2. Installer
.\install.ps1

# 3. Auditer le resultat
.\verify.ps1
```

Si PowerShell bloque l'exécution des scripts :

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Puis **redémarrez Claude Code** pour charger la configuration.

### Linux / macOS

```bash
./install.sh --dry-run
./install.sh
./verify.sh
```

### Options

| Option | Effet |
|---|---|
| `-DryRun` / `--dry-run` | Simulation, aucune écriture |
| `-Force` / `--force` | Remplace les fichiers du paquet déjà présents |
| `-OverwriteClaudeMd` / `--overwrite-claude-md` | Remplace un CLAUDE.md global existant |

---

## Garanties de sécurité de l'installateur

- **Sauvegarde horodatée** de toute configuration existante avant modification,
  dans `~/.claude/backups/pro-setup-AAAAMMJJ-HHMMSS/`.
- **Aucune suppression** : Skills, agents et MCP existants sont conservés.
- **Fusion de settings.json non destructive** : vos valeurs existantes gagnent,
  les listes de permissions sont unionnées (aucune entrée perdue).
- **CLAUDE.md existant préservé** : la nouvelle version est déposée à côté sous
  `CLAUDE.md.nouveau` pour fusion manuelle, sauf si vous demandez le remplacement.
- **Validation JSON avant écriture** : en cas d'erreur, `settings.json` n'est pas
  touché et la sauvegarde reste intacte.
- **Idempotent** : relançable sans dommage.

---

## Contenu

```
claude-pro-setup/
├─ install.ps1 / install.sh     installateurs
├─ verify.ps1  / verify.sh      audit post-installation (PASS/WARNING/FAIL)
├─ docs/
│  ├─ PLUGINS.md                catalogue réel et commandes vérifiées
│  └─ MCP.md                    serveurs MCP, authentification, impact contexte
└─ payload/
   ├─ CLAUDE.md                 instructions globales (45 lignes, volontairement court)
   ├─ settings.json             clés vérifiées contre le binaire Claude Code
   ├─ skills/                   27 Skills
   ├─ agents/                   10 sous-agents
   ├─ rules/                    règles chargées à la demande
   └─ templates/                modèles de mémoire et de CLAUDE.md projet
```

### Les 27 Skills

**Recherche et décision** — `research-verification`, `market-intelligence`,
`trend-radar`, `decision-gate`, `competitive-intelligence`

**Business et marketing** — `business-builder`, `marketing-strategist`,
`seo-expert`, `copywriting-pro`, `social-media-strategist`, `youtube-strategist`

**Commerce** — `ecommerce-research`, `etsy-digital-products`, `pod-strategist`

**Produit et technique** — `product-manager`, `app-architect`, `qa-debugging`,
`automation-architect`, `prompt-engineer`

**Design** — `web-design-pro`, `ui-ux-audit`, `design-system`,
`landing-page-conversion`

**Système** — `memory-manager`, `context-token-manager`, `project-orchestrator`,
`quality-controller`

Chaque Skill contient : déclencheurs, conditions de non-usage, procédure,
contrôles qualité, critères de fin et format de livrable.

### Les 10 sous-agents

`research-agent`, `market-agent`, `design-agent`, `frontend-agent`,
`backend-agent`, `debug-agent`, `qa-agent`, `security-review-agent`,
`seo-agent`, `business-agent`

---

## Après l'installation

### Plugins (commandes vérifiées)

```powershell
claude plugin marketplace add anthropics/claude-code
claude plugin install frontend-design@claude-code-plugins
claude plugin install feature-dev@claude-code-plugins
claude plugin install code-review@claude-code-plugins
claude plugin install plugin-dev@claude-code-plugins
claude plugin list
```

Détails et correspondance avec votre demande initiale : `docs/PLUGINS.md`.

### MCP (commandes vérifiées)

```powershell
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
claude mcp add chrome-devtools -s user -- npx -y chrome-devtools-mcp@latest
claude mcp list
```

Les serveurs nécessitant une authentification (GitHub, Figma, Supabase, Context7)
sont documentés dans `docs/MCP.md` : ces connexions exigent votre intervention.

### Mémoire projet

Au démarrage d'un projet, copiez la structure décrite dans
`payload/templates/memoire-projet.md` vers `<projet>/.claude/memory/`.
La Skill `memory-manager` s'en charge si vous le lui demandez.

---

## Utilisation

Les Skills se déclenchent automatiquement selon le contexte, ou explicitement :

```
Utilise la Skill web-design-pro pour concevoir ma landing page.
Fais un audit de contexte avec context-token-manager.
Mets à jour la mémoire du projet.
```

**Point de conception important** : les Skills ne chargent leur contenu que
lorsqu'elles sont invoquées. Seuls leur nom et leur description occupent le
contexte en permanence. C'est pourquoi CLAUDE.md reste court et les procédures
longues vivent dans les Skills — et non l'inverse.

---

## Désinstallation / retour arrière

```powershell
# Restaurer depuis une sauvegarde
Copy-Item "$env:USERPROFILE\.claude\backups\pro-setup-<horodatage>\*" `
          "$env:USERPROFILE\.claude\" -Recurse -Force
```

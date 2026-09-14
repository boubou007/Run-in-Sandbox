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
├─ install.ps1 / install.sh        installateurs
├─ verify.ps1  / verify.sh         audit post-installation (PASS/WARNING/FAIL)
├─ setup-plugins.ps1 / .sh         marketplace + plugins, en une commande
├─ setup-mcp.ps1     / .sh         MCP sans authentification + test de connexion
├─ tools/
│  └─ verify-page.mjs              vérification d'une page dans un vrai navigateur
├─ examples/
│  └─ landing-demo.html            landing page de référence (16 PASS, 0 FAIL)
├─ docs/
│  ├─ PLUGINS.md                   catalogue réel et commandes vérifiées
│  ├─ MCP.md                       serveurs MCP, authentification, impact contexte
│  └─ VERIFICATION-VISUELLE.md     outil de contrôle navigateur et ses pièges
└─ payload/
   ├─ CLAUDE.md                    instructions globales (45 lignes, volontairement court)
   ├─ settings.json                clés vérifiées contre le binaire Claude Code
   ├─ skills/                      27 Skills
   ├─ agents/                      10 sous-agents
   ├─ commands/                    3 commandes slash
   ├─ rules/                       règles chargées à la demande
   └─ templates/                   modèles de mémoire et de CLAUDE.md projet
```

### Commandes slash installées

| Commande | Effet |
|---|---|
| `/token-audit` | Audit du contexte, verdict KEEP / COMPACT / CLEAR |
| `/reprise` | Résumé de reprise du projet depuis la mémoire |
| `/sauvegarde-memoire` | Enregistre état, décisions et erreurs de la session |

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

### Plugins — une commande

```powershell
.\setup-plugins.ps1              # marketplace officielle + 4 plugins recommandes
.\setup-plugins.ps1 -Optional    # + commit-commands, security-guidance, pr-review-toolkit
```

Le script est idempotent et **vérifie réellement** que chaque plugin apparaît
comme installé avant de conclure. Détails et correspondance avec votre demande
initiale : `docs/PLUGINS.md`.

### MCP — une commande

```powershell
.\setup-mcp.ps1                  # playwright + test de connexion reel
.\setup-mcp.ps1 -WithDevTools    # + chrome-devtools
```

Seuls les serveurs **sans authentification** sont automatisés. GitHub, Figma,
Supabase et Context7 exigent votre intervention (OAuth ou clé) : commandes
exactes dans `docs/MCP.md`. Context7 a été testé : il **requiert une clé API**.

### Vérification visuelle d'une page

```powershell
npm install -g playwright && npx playwright install chromium
node tools\verify-page.mjs http://localhost:8099/ma-page.html .\verification
```

16 contrôles : responsive, accessibilité, console, mode sombre, captures desktop
et mobile. Voir `docs/VERIFICATION-VISUELLE.md`, qui documente aussi un piège
important : les captures pleine page peuvent afficher du **texte fantôme** quand
la page utilise `backdrop-filter`. Confirmez toujours dans le DOM avant de corriger.

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

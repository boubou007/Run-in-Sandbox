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

### Les scripts PowerShell ont été réellement exécutés

PowerShell 7.4.6 a été installé dans l'environnement de préparation afin de tester
les `.ps1` pour de vrai, et non seulement par relecture. Ce qui a été exécuté :

| Test | Résultat |
|---|---|
| Analyse syntaxique des 4 scripts par le parseur PowerShell | 0 erreur |
| `install.ps1 -DryRun` sur profil vierge | aucune écriture, sortie conforme |
| `install.ps1` sur profil vierge | 29 fichiers Skills, 10 agents, 3 commandes copiés |
| `install.ps1` sur configuration **existante** | 10 contrôles de non-destruction passés |
| `install.ps1` relancé (idempotence) | 0 ajout, 0 remplacement, tout conservé |
| Test négatif : sauvegarde impossible | arrêt code 1 **avant** toute modification, `settings.json` intact |
| `verify.ps1` | 19 PASS, 0 WARNING, 0 FAIL |
| `setup-plugins.ps1` | 4/4 plugins confirmés |
| `setup-mcp.ps1` | Playwright `Connected` |

Ces tests ont révélé un défaut critique que la relecture seule n'avait pas vu
(voir « Revue de sécurité » ci-dessous). Il est corrigé et vérifié.

Réserve honnête : les tests ont tourné sous PowerShell **Linux**. Le moteur, la
syntaxe et la logique sont les mêmes que sous Windows ; ce qui n'a pas pu être
exercé est spécifique à Windows — les ACL du dossier de sauvegarde (`Get-Acl` /
`Set-Acl`, entourées d'un `try/catch` qui dégrade en avertissement) et les chemins
à antislash. **Lancez tout de même `.\install.ps1 -DryRun` en premier** : c'est
dix secondes, et le script n'écrit rien.

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
- **Arrêt si la sauvegarde échoue** : si le dossier de sauvegarde ne peut pas être
  créé, si la copie échoue ou si le dossier est vide après copie, le script
  s'arrête avec le code 1 **avant toute modification**. Vérifié par test négatif.
- **Sauvegarde à accès restreint** : le dossier est créé en `0700` (Linux/macOS)
  ou avec une ACL limitée à votre compte (Windows), car il peut contenir
  `.claude.json`, qui porte des données de compte.

---

## Revue de sécurité des installateurs

Les scripts s'exécutent sur votre machine et manipulent vos fichiers. Ils ont été
audités puis exécutés ; **quatre défauts** ont été trouvés et corrigés. Le plus
grave n'a été révélé que par l'exécution réelle, pas par la relecture.

| Défaut | Gravité | Correction |
|---|---|---|
| `install.sh` : échec de sauvegarde silencieux (`2>/dev/null`, aucun contrôle). La configuration pouvait être modifiée **sans sauvegarde**, ce qui annulait la garantie principale du script. | Élevée | Contrôle du code de retour de `mkdir` et `cp`, plus vérification que le dossier n'est pas vide. Arrêt immédiat sinon. Vérifié par test négatif. |
| `install.ps1` : `Copy-Tree` passait un bloc de script à `Invoke-Action`, qui l'exécutait via `& $Action`. Le bloc y référençait `$_`, variable **automatique de pipeline** non liée hors de son pipeline : la copie des Skills et agents pouvait ne rien copier. | Élevée | L'indirection par bloc de script a été supprimée. La copie se fait dans une boucle `foreach` explicite, avec vérification de l'existence du fichier après copie. |
| Dossier de sauvegarde créé en `0755` alors qu'il contient `.claude.json` (données de compte). Sur un poste partagé, son contenu était listable. | Moyenne | `chmod 700` sur Linux/macOS ; ACL sans héritage, limitée au compte courant, sur Windows. |
| `install.ps1` : `ConvertTo-Hashtable` testait `-is [PSCustomObject]`. En PowerShell, **presque tout objet satisfait ce test**, y compris une chaîne, car tout transite par un `PSObject`. Chaque chaîne de permission était donc convertie en `Hashtable` : `settings.json` aurait été écrit **corrompu** (permissions en objets vides au lieu de chaînes), et l'union des permissions réduisait 16 entrées à 1. | **Critique** | Test sur le type réel (`.GetType()`) avec traitement explicite des chaînes, primitives, dictionnaires, tableaux, puis `PSCustomObject`. Vérifié : `allow`=16, `ask`=4, `deny`=7, toutes de type chaîne. |

Aucun secret n'est écrit, lu ou transmis par ces scripts. Aucune connexion réseau
n'est établie par `install.ps1` / `install.sh` — seuls `setup-plugins` et
`setup-mcp` appellent la CLI `claude`, qui gère elle-même ses accès.

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
├─ tests/
│  ├─ declenchement-skills.md      27 cas de test de déclenchement des Skills
│  └─ resistance-fabrication.md    3 cas adversariaux anti-invention de données
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

### Qualité de déclenchement : 27 / 27

Une Skill inutile est une Skill qui ne se déclenche pas, ou qui se déclenche à la
place d'une autre. C'est mesuré, pas supposé.

- Audit structurel : les 6 sections obligatoires présentes dans les 27 Skills,
  descriptions entre 315 et 483 caractères, **aucun recouvrement** détecté entre
  descriptions (indice de Jaccard maximal sous le seuil), aucun renvoi croisé cassé.
- Audit comportemental : **27 scénarios sur 27** déclenchent la bonne Skill,
  dont 10 cas volontairement ambigus (`design-system` vs `web-design-pro` vs
  `ui-ux-audit`, `competitive-intelligence` vs `market-intelligence`,
  `copywriting-pro` vs `social-media-strategist`, `trend-radar` vs
  `market-intelligence`). Le cas « créer un site vitrine » choisit bien
  `web-design-pro` et non le plugin `frontend-design` : pas de collision.

Les cas sont figés dans `tests/declenchement-skills.md`, avec la discrimination
que chacun teste. Relancez-le après toute modification d'une description.

### Résistance à la fabrication de données

Votre règle « ne jamais inventer une donnée manquante » a été testée en
adversarial : demander des chiffres de marché sans aucune source, un verdict
d'engagement sur des données non sourcées, et une validation sans livrable.

Ces tests ont trouvé **deux défauts réels**, corrigés :

- **Vocabulaire de verdict contaminé.** `quality-controller` rendait « NON
  LIVRABLE » puis « NO » au lieu de `NON VALIDÉ`. Cause racine : la règle
  GO/WAIT/NO du `CLAUDE.md` global était trop large et débordait sur tous les
  verdicts. Corrigé des deux côtés.
- **Ancrage d'estimation non signalé.** `market-intelligence` étiquetait bien ses
  estimations, mais bâtissait toute la chaîne sur un nombre inventé sans le
  signaler comme point de rupture unique.

Après correction : verdict `NON VALIDÉ` motivé « vérification impossible »,
et estimations qui nomment leur hypothèse d'ancrage, sa sensibilité, le signal
qui la vérifierait, et l'insuffisance pour décider. Non-régression vérifiée sur
`decision-gate` (WAIT) et `context-token-manager` (KEEP).

Cas figés dans `tests/resistance-fabrication.md`. **Un conflit entre `CLAUDE.md`
et une Skill ne se voit pas en relisant les fichiers : il n'apparaît qu'à
l'exécution.** Relancez ces tests après toute modification du CLAUDE.md global.

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

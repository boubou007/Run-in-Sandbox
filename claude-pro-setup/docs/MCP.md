# Serveurs MCP

Un **serveur MCP** donne à Claude Code des outils supplémentaires (navigateur,
base de données, API tierce). Ce n'est pas la même chose qu'un plugin.

Toutes les commandes de ce document respectent la syntaxe réelle de
`claude mcp add` sur Claude Code 2.1.270, vérifiée via `claude mcp add --help`.

## Syntaxe

```powershell
# Serveur local (stdio)
claude mcp add <nom> -s user -- <commande> <arguments>

# Serveur distant (HTTP)
claude mcp add --transport http <nom> -s user <url>

# Avec en-tete d'authentification
claude mcp add --transport http <nom> -s user <url> --header "Authorization: Bearer VOTRE_CLE"
```

`-s user` installe le serveur pour **tous vos projets**. Sans ce paramètre, la
portée par défaut est `local` (projet courant uniquement).

## Coût en contexte — à lire avant d'installer

Chaque serveur MCP actif injecte la définition de **tous ses outils** dans le
contexte, en permanence, même si vous ne les appelez jamais. Un serveur riche
peut coûter plusieurs milliers de tokens par session.

**Règle** : n'activez que ce que vous utilisez réellement. Deux serveurs qui font
la même chose (par exemple deux pilotes de navigateur) ne doivent pas être actifs
en même temps sans raison.

---

## 1. Navigateur automatisé — testé et fonctionnel

Nécessaire pour la vérification visuelle de la Skill `web-design-pro`.

```powershell
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
```

- **Fonction** : piloter un navigateur, naviguer, cliquer, remplir, capturer.
- **Origine** : Microsoft, paquet officiel `@playwright/mcp`.
- **Authentification** : aucune.
- **Impact contexte** : moyen.
- **Statut vérifié** : `√ Connected` sur `claude mcp list`.

## 2. Chrome DevTools — testé et fonctionnel

```powershell
claude mcp add chrome-devtools -s user -- npx -y chrome-devtools-mcp@latest
```

- **Fonction** : inspection DevTools, performance, réseau, console, Core Web Vitals.
- **Origine** : Google, paquet officiel `chrome-devtools-mcp`.
- **Authentification** : aucune.
- **Impact contexte** : moyen.
- **Statut vérifié** : `√ Connected` sur `claude mcp list`.

> Playwright et Chrome DevTools se recouvrent partiellement. Playwright convient
> mieux au pilotage et aux tests ; Chrome DevTools à l'analyse de performance.
> Si vous voulez limiter le coût en contexte, gardez-en un seul actif.

## 3. GitHub

Deux voies, selon votre environnement :

**a) Connecteur intégré** — si vous utilisez Claude Code sur le web ou le bureau,
GitHub est proposé comme connecteur et s'authentifie en OAuth depuis l'interface.
C'est la voie la plus simple. **Action requise de votre part** : autoriser la
connexion dans l'interface.

**b) Serveur MCP distant** :

```powershell
claude mcp add --transport http github -s user https://api.githubcopilot.com/mcp/
```

- **Fonction** : dépôts, issues, pull requests, revues, Actions.
- **Authentification** : OAuth ou jeton personnel. **Action manuelle obligatoire.**
- **Impact contexte** : élevé (beaucoup d'outils exposés).
- **Permissions** : n'accordez que les portées nécessaires (`repo` en lecture si
  vous ne faites que consulter).

## 4. Documentation technique à jour (Context7)

```powershell
claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp
```

- **Fonction** : documentation de bibliothèques à jour, contre les APIs obsolètes.
- **Origine** : Upstash.
- **Authentification** : **requise — vérifié.** Ajouté sans clé, le serveur répond
  `! Needs authentication` sur `claude mcp list`. Créez un compte sur context7.com,
  puis ajoutez l'en-tête :
  ```powershell
  claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: VOTRE_CLE"
  ```
- **Impact contexte** : faible (peu d'outils).
- **Statut vérifié** : ajouté avec succès, mais `! Needs authentication` sans clé.
  Le serveur n'est donc pas utilisable tant que vous n'avez pas fourni la vôtre.

## 5. Figma

```powershell
claude mcp add --transport http figma -s user https://mcp.figma.com/mcp
```

- **Fonction** : lire des fichiers Figma, extraire composants et jetons de design.
- **Authentification** : OAuth. **Action manuelle obligatoire** dans le navigateur.
- **Prérequis** : compte Figma ; certaines fonctions exigent un plan payant.
- **Impact contexte** : moyen.
- **Statut** : non testé ici (authentification requise).

## 6. Supabase

```powershell
claude mcp add supabase -s user -e SUPABASE_ACCESS_TOKEN=VOTRE_JETON -- npx -y @supabase/mcp-server-supabase@latest
```

- **Fonction** : base de données, tables, requêtes, migrations, Edge Functions.
- **Authentification** : jeton d'accès personnel Supabase. **Action manuelle.**
- **Impact contexte** : élevé.
- **Risque à signaler** : ce serveur peut modifier votre base. Utilisez de
  préférence un jeton limité à un projet de développement, et ajoutez
  `--read-only` si le paquet le propose pour vos usages de consultation.
- **Statut** : non testé ici (jeton requis).

---

## Piège connu : Playwright MCP et le canal navigateur

Par défaut, `@playwright/mcp` cherche **Google Chrome installé sur le système**.
Sur une machine sans Chrome (conteneur, poste sous Chromium seul), il échoue avec :

```
Chromium distribution 'chrome' is not found at /opt/google/chrome/chrome
```

Ce n'est pas un défaut de configuration : c'est le canal par défaut. Deux remèdes :

```powershell
# a) utiliser le Chromium fourni par Playwright plutot que Chrome
claude mcp remove playwright
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest --browser chromium

# b) ou installer le canal Chrome
npx playwright install chrome
```

Sur un poste Windows où Chrome est installé, la configuration par défaut fonctionne
sans modification. Le problème ne se pose que sur des environnements sans Chrome.

---

## Gestion et vérification

```powershell
claude mcp list              # teste la connexion reelle de chaque serveur
claude mcp get <nom>         # detail d'un serveur
claude mcp remove <nom>      # supprimer
```

Un serveur n'est opérationnel que s'il affiche `√ Connected` dans `claude mcp list`.
Un serveur ajouté mais non connecté ne fonctionne pas.

## Sécurité

- Ne mettez jamais un jeton en clair dans un fichier versionné.
- Préférez les variables d'environnement (`-e CLE=valeur`) aux jetons en dur.
- Accordez à chaque jeton la portée minimale nécessaire.
- Un serveur MCP exécute du code sur votre machine : n'installez que des sources
  dont vous avez vérifié l'origine.
- Révoquez les jetons que vous n'utilisez plus.

## Tableau de suivi

| Serveur | Fonction | Origine | Authentification | Impact contexte | Statut |
|---|---|---|---|---|---|
| playwright | Pilotage navigateur | Microsoft | aucune | moyen | **Testé ✅ Connected** |
| chrome-devtools | Perf, réseau, console | Google | aucune | moyen | **Testé ✅ Connected** |
| github | Dépôts, PR, issues | GitHub | OAuth / jeton | élevé | Action manuelle requise |
| context7 | Documentation à jour | Upstash | **clé requise (vérifié)** | faible | Ajouté, `Needs authentication` |
| figma | Design, composants | Figma | OAuth | moyen | Action manuelle requise |
| supabase | Base de données | Supabase | jeton | élevé | Action manuelle requise |

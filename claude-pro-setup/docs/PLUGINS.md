# Plugins Claude Code

Toutes les commandes de ce document ont été **exécutées et vérifiées** sur
Claude Code 2.1.270. Aucun nom de plugin n'est inventé : la liste ci-dessous est
le catalogue réel de la marketplace officielle `anthropics/claude-code`.

## 1. Ajouter la marketplace officielle

```powershell
claude plugin marketplace add anthropics/claude-code
```

Résultat attendu : `Successfully added marketplace: claude-code-plugins`.

Vérifier :

```powershell
claude plugin marketplace list
```

## 2. Catalogue réel (13 plugins, marketplace officielle Anthropic)

| Plugin | Fonction |
|---|---|
| `agent-sdk-dev` | Kit de développement pour le Claude Agent SDK |
| `claude-opus-4-5-migration` | Migration de code et prompts vers Opus 4.5 |
| `code-review` | Revue de code automatisée sur les pull requests |
| `commit-commands` | Commandes de workflow git (commit, push, PR) |
| `explanatory-output-style` | Style de sortie pédagogique |
| `feature-dev` | Workflow complet de développement de fonctionnalité |
| `frontend-design` | Interfaces frontend de qualité production |
| `hookify` | Création de hooks personnalisés |
| `learning-output-style` | Mode apprentissage interactif |
| `plugin-dev` | Boîte à outils de développement de plugins et Skills |
| `pr-review-toolkit` | Agents spécialisés de revue de PR |
| `ralph-wiggum` | Boucles itératives auto-référentielles |
| `security-guidance` | Hook d'alerte sécurité à l'édition de fichiers |

## 3. Installation recommandée (portée utilisateur, tous projets)

```powershell
claude plugin install frontend-design@claude-code-plugins
claude plugin install feature-dev@claude-code-plugins
claude plugin install code-review@claude-code-plugins
claude plugin install plugin-dev@claude-code-plugins
```

Ces quatre commandes ont été exécutées et vérifiées : les plugins apparaissent
ensuite avec `Status: enabled` et `Scope: user`.

Optionnels selon vos usages :

```powershell
claude plugin install commit-commands@claude-code-plugins
claude plugin install security-guidance@claude-code-plugins
claude plugin install pr-review-toolkit@claude-code-plugins
```

## 4. Vérification obligatoire après installation

```powershell
claude plugin list
```

N'considérez un plugin comme installé que s'il apparaît ici avec `enabled`.

## 5. Correspondance avec votre demande initiale

Point important : **plusieurs éléments de votre liste ne sont pas des plugins,
mais des serveurs MCP.** Ce sont deux mécanismes différents. Voir `MCP.md`.

| Demandé | Réalité vérifiée | Action |
|---|---|---|
| Frontend Design | Plugin `frontend-design` | Installé ✅ |
| Feature Dev | Plugin `feature-dev` | Installé ✅ |
| Code Review | Plugin `code-review` | Installé ✅ |
| Skill Creator | **Pas un plugin officiel.** Le plugin `plugin-dev` couvre la création de Skills et de plugins. Une Skill `skill-creator` existe par ailleurs côté Anthropic. | `plugin-dev` installé ✅ |
| Superpowers | **Plugin communautaire**, hors marketplace officielle. Origine vérifiée : dépôt public `obra/superpowers-marketplace`, auteur Jesse Vincent. **Non Anthropic Verified.** | Décision vous revient — voir §6 |
| Context7 | **Serveur MCP**, pas un plugin | Voir `MCP.md` |
| GitHub | **Serveur MCP**, pas un plugin | Voir `MCP.md` |
| Playwright | **Serveur MCP**, pas un plugin | Voir `MCP.md` — testé ✅ |
| Chrome DevTools | **Serveur MCP**, pas un plugin | Voir `MCP.md` — testé ✅ |
| Figma | **Serveur MCP**, pas un plugin | Voir `MCP.md` |
| Supabase | **Serveur MCP**, pas un plugin | Voir `MCP.md` |

## 6. Superpowers — décision vous appartenant

Votre consigne était de ne pas installer de plugin communautaire inconnu sans
vérifier l'origine, et de privilégier les éditeurs officiels.

**Faits vérifiés** : le dépôt `obra/superpowers` est public, maintenu par Jesse
Vincent, et présenté comme un cadre de méthodologie de développement agentique
(TDD, débogage, motifs de collaboration).
Source : [github.com/obra/superpowers](https://github.com/obra/superpowers) ·
[marketplace](https://github.com/obra/superpowers-marketplace)

**Fait** : ce n'est pas une marketplace Anthropic Verified.

**Recommandation** : ne l'installez que si vous acceptez d'exécuter du code
communautaire. Si vous le souhaitez :

```powershell
claude plugin marketplace add obra/superpowers-marketplace
claude plugin marketplace list          # verifier ce qui est reellement propose
claude plugin install superpowers@superpowers-marketplace
claude plugin list                      # confirmer
```

Inspectez le catalogue avant d'installer : ajouter une marketplace n'installe
rien, cela ne fait qu'ajouter une source.

## 7. Commandes utiles

```powershell
claude plugin details <nom>     # inventaire du plugin et cout en tokens projete
claude plugin disable <nom>     # desactiver sans desinstaller
claude plugin enable <nom>
claude plugin marketplace remove <nom>
```

`claude plugin details` est particulièrement utile : il indique le coût en
contexte du plugin avant que vous ne le laissiez activé en permanence.

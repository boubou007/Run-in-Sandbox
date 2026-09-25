# Les 5 skills Claude Code de la vidéo @innomation01 — instructions vérifiées

> Source analysée : vidéo TikTok `ssstik.io_innomation01_1790323928683.mp4` (43 s).
> Message de la vidéo : « Claude a 100 000+ skills. T'en as besoin de 5. »
> Vérification : dépôts clonés et installations testées le 2026-09-25 avec Claude Code 2.1.282, Node 22, sur Linux, dans un HOME isolé.

## Récapitulatif

| # | Nom dans la vidéo | Rôle | Dépôt officiel (vérifié) | Licence | Version testée | Test |
|---|---|---|---|---|---|---|
| 1 | FindSkills | trouve et installe des skills | [vercel-labs/skills](https://github.com/vercel-labs/skills) (skill `find-skills`) | MIT | CLI `skills` 1.7.0 | ✅ OK |
| 2 | Superpowers | planifie et vérifie | [obra/superpowers](https://github.com/obra/superpowers) | MIT | 6.4.1 | ✅ OK |
| 3 | ClaudeMem | mémoire entre sessions | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Apache-2.0 | 13.25.3 | ✅ installé (voir risques) |
| 4 | Impeccable | design d'interface | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Apache-2.0 | plugin 4.4.0 | ✅ via `/plugin` ; ⚠️ `npx` bloqué dans ma sandbox |
| 5 | TaskObserver | apprend ton style, améliore tes skills | [rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all) (skill `task-observer`) | CC BY 4.0 | 3.3.1 | ✅ OK (activation manuelle requise) |

Prérequis communs : Claude Code installé, **Node.js ≥ 20** (`node -v`), `git`.

Pas besoin de « commenter CLAUDE » comme le demande la vidéo : les 5 sont publics et gratuits sur GitHub.

---

## 1. FindSkills (`vercel-labs/skills`)

**Rôle** : quand tu demandes « est-ce qu'il existe un skill pour X ? », Claude cherche dans l'écosystème skills.sh et propose l'installation.

**Commande (dans un terminal, pas dans Claude Code)** :
```bash
npx skills add vercel-labs/skills --skill find-skills -g -a claude-code -y
```
- `-g` : installation globale dans `~/.claude/skills/` (tous tes projets)
- `-a claude-code` : cible uniquement Claude Code
- `-y` : pas de questions interactives

**Vérifier** : `ls ~/.claude/skills/find-skills` → doit contenir `SKILL.md`.

**Risque** : ce skill peut te proposer d'installer d'autres skills tiers. L'outil l'affiche lui-même : *« Review skills before use; they run with full agent permissions. »* Lis toujours le dépôt avant d'accepter.

---

## 2. Superpowers (`obra/superpowers`)

**Rôle** : méthodologie de développement (brainstorming → plan → TDD → revue). Force Claude à ralentir, planifier et vérifier son travail.

**Option A — marketplace officielle Anthropic (recommandée, testée OK)** :
```
/plugin install superpowers@claude-plugins-official
```

**Option B — marketplace de l'auteur (testée OK)** :
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```
Équivalent en terminal :
```bash
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace
```

**Vérifier** : `claude plugin list` → `superpowers@… Status: enabled`. Redémarre Claude Code.

**Risque** : faible. Le plugin rend Claude plus lent (plus d'étapes), c'est voulu.

---

## 3. ClaudeMem (`thedotmack/claude-mem`)

**Rôle** : enregistre ce qui se passe pendant tes sessions, le compresse avec une IA, et le réinjecte au début des sessions suivantes.

**Option A — plugin, sans passer par l'assistant de connexion (testée)** :
```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```
Puis redémarre Claude Code.

**Option B — installateur officiel** :
```bash
npx claude-mem install
```
⚠️ Cet installateur te demande ensuite de **te connecter à un compte claude-mem** (lien magique par e-mail). Le README indique un essai gratuit de 30 jours de leur « observer » hébergé ; à la fin, la mémoire bascule sur ton forfait Anthropic sauf si tu t'abonnes. Tu peux aussi choisir ta propre clé OpenRouter/Gemini ou ton forfait Anthropic.

**Ne fais pas** `npm install -g claude-mem` : d'après le README, ça installe seulement la bibliothèque, sans les hooks.

**Vérifier** : `claude plugin list` → `claude-mem@thedotmack Status: enabled`. À la session suivante, le contexte des sessions précédentes doit apparaître.

**Risques (à lire avant d'installer)** :
- Le plugin installe des **hooks** (Setup, SessionStart, UserPromptSubmit…) qui lancent un service local en arrière-plan (Bun, qu'il installe automatiquement s'il manque) avec une API HTTP locale.
- Il **stocke le contenu de tes sessions** (base SQLite locale). Selon le fournisseur choisi, ce contenu est envoyé à un service externe pour être compressé. Pour exclure des secrets, entoure-les de balises `<private>…</private>`.
- Il consomme des tokens (ton forfait ou le leur).
- C'est le plus intrusif des 5 : à éviter sur un projet client confidentiel sans avoir validé la politique de données.

---

## 4. Impeccable (`pbakaus/impeccable`)

**Rôle** : un « langage de design » pour que les interfaces générées par Claude ne ressemblent plus à du « design d'IA » générique. Commandes `/impeccable …` et un hook qui détecte les défauts de design quand tu modifies un fichier d'UI.

**Option A — CLI officielle (recommandée par l'auteur, à lancer à la racine du projet)** :
```bash
npx impeccable install --providers=claude --scope=project
```
(`--scope=global` pour tous les projets.) Puis dans Claude Code :
```
/impeccable init
```
⚠️ Dans ma sandbox, cette commande a échoué : `Could not verify skill bundle … (HTTP 403)`. Cause probable : le proxy réseau de la sandbox bloque le téléchargement du bundle signé ; rien n'a été installé (échec propre). Sur un poste normal, ça devrait fonctionner. Si l'erreur persiste, l'auteur renvoie vers le ticket [pbakaus/impeccable#479](https://github.com/pbakaus/impeccable/issues/479).

**Option B — plugin Claude Code (testée, fonctionne)** :
```
/plugin marketplace add pbakaus/impeccable
/plugin install impeccable
```
Terminal :
```bash
claude plugin marketplace add pbakaus/impeccable
claude plugin install impeccable
```

**Vérifier** : `claude plugin list` → `impeccable@impeccable Version: 4.4.0 Status: enabled`.

**Risque** : faible. Le moteur est un binaire téléchargé dans `~/.impeccable/bin/` au premier lancement.

---

## 5. TaskObserver (`rebelytics/one-skill-to-rule-them-all`)

**Rôle** : un « méta-skill » qui observe tes sessions, note tes corrections et tes choix, puis propose des améliorations à tes autres skills (et à lui-même).

**Installation (terminal)** :
```bash
npx skills add rebelytics/one-skill-to-rule-them-all --skill task-observer -g -a claude-code -y
```

**Étape indispensable : l'activer.** D'après le README, installer les fichiers ne suffit pas : il se déclenche mal tout seul. Il faut ajouter le « bloc d'activation » dans ton `CLAUDE.md` :
1. Ouvre `~/.claude/skills/task-observer/references/environments.md`, section **« The activation block »**.
2. Copie le bloc dans ton `CLAUDE.md` (global `~/.claude/CLAUDE.md` ou celui du projet).
3. Remplace `[ABSOLUTE PATH]` par un dossier **permanent** (par exemple `~/task-observer-workspace`), jamais un dossier temporaire ou un worktree.

**Vérifier** : dans une **nouvelle** session (la session d'installation ne prouve rien, dit l'auteur), Claude doit invoquer `task-observer` avant le premier outil. Après quelques sessions, le dossier `skill-observations/observation-log/` doit exister dans ton workspace.

**Risque** : moyen. Il **modifie des fichiers de skills** (les propositions passent par `skill-updates/PENDING.md` pour revue). Relis chaque proposition avant de l'appliquer.

---

## Prompt prêt à coller dans Claude Code

```text
Installe ces skills/plugins Claude Code dans l'ordre. Arrête-toi et montre-moi l'erreur si une commande échoue.
1. Vérifie que node -v renvoie une version ≥ 20.
2. npx skills add vercel-labs/skills --skill find-skills -g -a claude-code -y
3. claude plugin marketplace add obra/superpowers-marketplace && claude plugin install superpowers@superpowers-marketplace
4. claude plugin marketplace add pbakaus/impeccable && claude plugin install impeccable
5. npx skills add rebelytics/one-skill-to-rule-them-all --skill task-observer -g -a claude-code -y
6. Montre-moi le bloc « The activation block » de ~/.claude/skills/task-observer/references/environments.md et demande-moi le dossier à utiliser pour [ABSOLUTE PATH] avant de modifier mon CLAUDE.md.
7. Ne pas installer claude-mem sans ma confirmation explicite (hooks + service en arrière-plan + stockage des sessions).
8. Termine par claude plugin list et ls ~/.claude/skills pour prouver que tout est installé.
```

Ensuite, si tu veux la mémoire : `claude plugin marketplace add thedotmack/claude-mem && claude plugin install claude-mem`.

## Désinstallation
```bash
claude plugin uninstall superpowers@superpowers-marketplace
claude plugin uninstall claude-mem@thedotmack
claude plugin uninstall impeccable@impeccable
rm -rf ~/.claude/skills/find-skills ~/.claude/skills/task-observer
```

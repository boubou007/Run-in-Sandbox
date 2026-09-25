# Installer les 5 skills un par un — prompts pour Claude Code

Chaque bloc ci-dessous est un **prompt à coller dans Claude Code**, un à la fois.
Ne passe au suivant que si Claude affiche `VALIDATION … OK`.

**Testé le 2026-09-25** dans un HOME vierge (Linux, Claude Code 2.1.282, Node 22). Toutes les commandes d'installation et de validation ci-dessous ont été exécutées et ont renvoyé OK.
Ce qui n'a **pas** été testé : les « tests fonctionnels » après redémarrage (ils dépendent de ta session Claude connectée). Ils sont signalés *(test manuel)*.

Ordre choisi : du moins risqué au plus intrusif. ClaudeMem en dernier.

> Windows : Claude Code exécute les commandes avec Git Bash, donc les commandes `bash` ci-dessous fonctionnent aussi.

---

## Étape 0 — Prérequis (à coller en premier)

```text
Vérifie les prérequis pour installer des skills Claude Code. N'installe rien.
Exécute :
  node -v
  git --version
  claude --version
Règle de validation :
- node doit être en version 20 ou plus.
- git et claude doivent répondre.
Affiche "VALIDATION 0 OK" si tout est bon, sinon "VALIDATION 0 KO" avec la raison et comment corriger. Arrête-toi là.
```

---

## Étape 1 — FindSkills (risque faible)

```text
Installe le skill find-skills (source officielle : https://github.com/vercel-labs/skills, licence MIT).

1. Installation :
   npx -y skills add vercel-labs/skills --skill find-skills -g -a claude-code -y

2. Validation (exécute exactement) :
   test -f ~/.claude/skills/find-skills/SKILL.md && grep -q '^name: find-skills' ~/.claude/skills/find-skills/SKILL.md && echo "VALIDATION 1 OK" || echo "VALIDATION 1 KO"

3. Si KO : montre-moi la sortie complète de l'étape 1, n'essaie pas d'autre source, et arrête-toi.
4. Si OK : dis-moi de redémarrer Claude Code avant l'étape suivante. N'installe rien d'autre.
```

*(test manuel, après redémarrage)* : demande « Trouve-moi un skill pour faire des tests Playwright ». Claude doit utiliser find-skills et proposer une commande `npx skills add …`. **N'accepte pas l'installation sans avoir lu le dépôt proposé.**

---

## Étape 2 — Superpowers (risque faible)

```text
Installe le plugin Superpowers depuis la marketplace officielle Anthropic (source : https://github.com/obra/superpowers, licence MIT).

1. Installation :
   claude plugin marketplace add anthropics/claude-plugins-official
   claude plugin install superpowers@claude-plugins-official

2. Validation (exécute exactement) :
   claude plugin list | grep -A3 'superpowers@claude-plugins-official' | grep -q 'enabled' && echo "VALIDATION 2a OK" || echo "VALIDATION 2a KO"
   claude plugin details superpowers@claude-plugins-official | grep -q 'brainstorming' && echo "VALIDATION 2b OK" || echo "VALIDATION 2b KO"
   Résultat attendu : version 6.4.1 ou plus, 15 skills dont brainstorming, writing-plans, test-driven-development.

3. Si KO : montre la sortie complète et arrête-toi. Plan B possible, seulement si je te le confirme :
   claude plugin marketplace add obra/superpowers-marketplace
   claude plugin install superpowers@superpowers-marketplace
4. Si OK : dis-moi de redémarrer Claude Code. N'installe rien d'autre.
```

*(test manuel)* : demande « Je veux ajouter une page de contact à mon site ». Claude doit commencer par poser des questions (brainstorming) au lieu de coder directement.

---

## Étape 3 — Impeccable (risque faible)

```text
Installe le plugin Impeccable (source : https://github.com/pbakaus/impeccable, licence Apache-2.0).
N'utilise PAS "npx impeccable install" pour l'instant : utilise la voie plugin, qui a été validée.

1. Installation :
   claude plugin marketplace add pbakaus/impeccable
   claude plugin install impeccable@impeccable

2. Validation (exécute exactement) :
   claude plugin list | grep -A3 'impeccable@impeccable' | grep -q 'enabled' && echo "VALIDATION 3a OK" || echo "VALIDATION 3a KO"
   claude plugin details impeccable@impeccable | grep -q 'Skills (1)  impeccable' && echo "VALIDATION 3b OK" || echo "VALIDATION 3b KO"
   Résultat attendu : 1 skill "impeccable", 4 agents, 3 hooks (SessionStart, PostToolUse, Stop).

3. Si KO : montre la sortie complète et arrête-toi.
4. Si OK : dis-moi de redémarrer Claude Code, puis de lancer "/impeccable init" à la racine d'un projet web. N'installe rien d'autre.
```

*(test manuel)* : dans un projet web, `/impeccable init`, puis `/impeccable audit`. Claude doit produire une liste de défauts de design.

---

## Étape 4 — TaskObserver (risque moyen : il propose de modifier tes skills)

```text
Installe le skill task-observer (source : https://github.com/rebelytics/one-skill-to-rule-them-all, licence CC BY 4.0).

1. Installation :
   npx -y skills add rebelytics/one-skill-to-rule-them-all --skill task-observer -g -a claude-code -y

2. Validation (exécute exactement) :
   test -f ~/.claude/skills/task-observer/SKILL.md && test -f ~/.claude/skills/task-observer/references/environments.md && echo "VALIDATION 4a OK" || echo "VALIDATION 4a KO"
   claude plugin list | grep -A4 'task-observer' | grep -q 'loaded' && echo "VALIDATION 4b OK" || echo "VALIDATION 4b KO"
   Note : n'utilise pas scripts/validate-skill-bundle.py comme critère. Il échoue toujours après ce type d'installation, à cause d'un fichier .claude-plugin/plugin.json qui ne concerne que la mise en ligne du skill, pas son usage.

3. Activation (obligatoire, sinon le skill ne se déclenche presque jamais) :
   a. Affiche-moi la section "### The activation block" de ~/.claude/skills/task-observer/references/environments.md.
   b. Demande-moi quel dossier PERMANENT utiliser pour [ABSOLUTE PATH] (proposition : ~/task-observer-workspace, en chemin absolu). Jamais un dossier temporaire, un worktree ou un clone jetable.
   c. Montre-moi le texte exact que tu vas ajouter à ~/.claude/CLAUDE.md et attends mon accord avant d'écrire.
   d. Après écriture : grep -q 'task-observer' ~/.claude/CLAUDE.md && echo "VALIDATION 4c OK" || echo "VALIDATION 4c KO"

4. Si un KO : montre la sortie et arrête-toi.
5. Si OK : dis-moi de redémarrer Claude Code. N'installe rien d'autre.
```

*(test manuel)* : dans une **nouvelle** session, demande n'importe quelle tâche. Claude doit invoquer `task-observer` avant son premier outil. Après quelques sessions, le dossier `skill-observations/observation-log/` doit exister dans ton workspace. S'il n'existe pas, l'activation n'a pas marché.

---

## Étape 5 — ClaudeMem (risque élevé : service en arrière-plan + stockage de tes sessions)

À faire seulement si tu acceptes que le contenu de tes sessions soit enregistré (base SQLite locale dans `~/.claude-mem/`) et résumé par une IA.

```text
Installe le plugin claude-mem (source : https://github.com/thedotmack/claude-mem, licence Apache-2.0).
Utilise la voie plugin, PAS "npx claude-mem install" (qui demande une création de compte), et PAS "npm install -g claude-mem" (qui n'installe pas les hooks).

1. Avant d'installer, rappelle-moi en 3 lignes ce que ce plugin ajoute (hooks, service local, stockage) et attends mon "OK".

2. Installation :
   claude plugin marketplace add thedotmack/claude-mem
   claude plugin install claude-mem@thedotmack

3. Validation immédiate (exécute exactement) :
   claude plugin list | grep -A3 'claude-mem@thedotmack' | grep -q 'enabled' && echo "VALIDATION 5a OK" || echo "VALIDATION 5a KO"
   Résultat attendu dans "claude plugin details claude-mem@thedotmack" : 20 skills, 7 hooks, 1 serveur MCP (mcp-search).

4. Dis-moi de redémarrer Claude Code, puis, dans la NOUVELLE session, exécute :
   PORT=$(node -e "console.log(require(require('os').homedir()+'/.claude-mem/settings.json').CLAUDE_MEM_WORKER_PORT)")
   curl -s http://127.0.0.1:$PORT/api/health | grep -q '"status":"ok"' && echo "VALIDATION 5b OK" || echo "VALIDATION 5b KO"
   Et affiche la valeur de CLAUDE_MEM_PROVIDER dans ~/.claude-mem/settings.json (par défaut "claude" = utilise mon forfait Anthropic).

5. Si KO : montre la sortie complète et arrête-toi.
```

*(test manuel)* : ouvre `http://127.0.0.1:<PORT>` dans ton navigateur pour voir la mémoire. Travaille une session, redémarre, puis demande « de quoi on a parlé la dernière fois ? ».

Désinstaller si ça ne te convient pas :
```bash
claude plugin uninstall claude-mem@thedotmack
```
Les données restent dans `~/.claude-mem/` : supprime ce dossier toi-même si tu veux tout effacer.

---

## Contrôle final (après les 5 étapes)

```text
Fais un bilan des skills installés. Exécute :
  claude plugin list
  ls ~/.claude/skills
Puis affiche un tableau : nom, version, statut (enabled/loaded), et indique tout élément manquant parmi :
find-skills, superpowers, impeccable, task-observer, claude-mem.
```

## Résultats de mes tests (2026-09-25)

| Étape | Commande de validation | Résultat |
|---|---|---|
| 0 | node ≥ 20, git, claude | OK (Node 22.22.2, Claude Code 2.1.282) |
| 1 | `SKILL.md` présent + `name: find-skills` | OK |
| 2 | plugin enabled + skill `brainstorming` | OK (v6.4.1, 15 skills) |
| 3 | plugin enabled + skill `impeccable` | OK (v4.4.0) |
| 4 | fichiers présents + `loaded` | OK (v3.3.1). `validate-skill-bundle.py` échoue, pour une raison sans rapport avec l'usage (voir étape 4) |
| 5 | plugin enabled + `/api/health` → `"status":"ok"` | OK (v13.25.3, port 37700 chez moi ; le tien peut différer, d'où la lecture dans settings.json) |

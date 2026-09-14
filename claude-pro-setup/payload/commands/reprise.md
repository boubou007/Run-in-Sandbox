---
description: Produit un résumé de reprise du projet à partir de la mémoire existante
allowed-tools: Read, Glob, Grep
---

Applique la Skill `memory-manager` pour produire un **résumé de reprise**.

Lis dans cet ordre, uniquement ce qui existe :
1. `.claude/memory/etat.md` — point de reprise
2. `.claude/memory/decisions.md` — arbitrages déjà tranchés, à ne pas rouvrir
3. `.claude/memory/erreurs.md` — problèmes déjà résolus
4. `CLAUDE.md` du projet — conventions
5. `.claude/memory/architecture.md` seulement si la tâche touche à la structure

Puis restitue :
- **Objectif du projet**
- **État actuel**
- **Dernières décisions** (avec leur raison)
- **Travail terminé**
- **Travail restant**
- **Prochaine action** — précise et exécutable telle quelle
- **Pièges connus**

Si aucun fichier de mémoire n'existe, dis-le clairement et propose de créer la
structure à partir de `~/.claude/templates/memoire-projet.md`. N'invente aucun
état : un projet sans mémoire est un projet sans mémoire.

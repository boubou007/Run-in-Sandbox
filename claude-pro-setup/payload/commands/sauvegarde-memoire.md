---
description: Enregistre l'état, les décisions et les erreurs de la session dans la mémoire projet
allowed-tools: Read, Write, Edit, Glob, Grep
---

Applique la Skill `memory-manager` pour enregistrer le travail de cette session.

Procédure :
1. **Relis** les fichiers de `.claude/memory/` concernés AVANT d'écrire, pour
   éviter les doublons. Fusionne au lieu d'empiler.
2. **Mets à jour `etat.md`** : travail terminé, travail restant, et une
   **prochaine action** exécutable sans réflexion préalable.
3. **Ajoute à `decisions.md`** toute décision structurante prise pendant la
   session : date, décision, raison, alternatives écartées, condition de remise
   en cause. Sans la raison, la décision sera rouverte plus tard.
4. **Ajoute à `erreurs.md`** tout problème résolu : symptôme, cause racine,
   solution validée, prévention.
5. **Retire l'obsolète** uniquement quand c'est sûr. Une décision remplacée n'est
   jamais supprimée : marque-la « remplacée par … ».

Contrôles avant d'écrire :
- Aucun secret, mot de passe, jeton ou clé privée.
- Aucun doublon avec une entrée existante.
- Chaque décision porte sa date et sa raison.

Si `.claude/memory/` n'existe pas, crée-le à partir de
`~/.claude/templates/memoire-projet.md`, puis renseigne-le.

Termine en listant ce que tu as écrit et ce que tu as volontairement omis.

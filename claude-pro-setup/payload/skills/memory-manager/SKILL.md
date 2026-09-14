---
name: memory-manager
description: Gérer la mémoire persistante de Claude : lire la mémoire existante, enregistrer objectifs, préférences, décisions, architecture, état d'avancement, erreurs rencontrées et solutions validées, éviter les doublons, retirer l'obsolète, séparer mémoire globale et mémoire projet, et produire un résumé de reprise. Utiliser quand l'utilisateur veut se souvenir de quelque chose, reprendre un projet, faire le point, ou quand une décision importante doit être conservée.
---

# Gestion de la mémoire

## Quand utiliser cette Skill
- Une décision, une préférence ou une correction importante doit être conservée.
- Reprise d'un projet après une interruption : produire un résumé de reprise.
- La mémoire est devenue contradictoire, redondante ou obsolète.
- Fin d'une session de travail significative.

## Quand ne PAS l'utiliser
- Information jetable, valable uniquement dans la conversation en cours.
- Contenu sensible : secrets, mots de passe, jetons, clés privées. Jamais en mémoire.

## Procédure
### Architecture de mémoire
- **Mémoire globale** — `~/.claude/CLAUDE.md` : préférences durables, règles de travail,
  langue, conventions. Valable pour tous les projets. Doit rester court.
- **Mémoire projet** — `<projet>/CLAUDE.md` : conventions et contexte du dépôt,
  versionné avec le code.
- **État projet** — `<projet>/.claude/memory/` (non versionné si sensible) :
  - `etat.md` : objectif courant, travail terminé, travail restant, prochaine action.
  - `decisions.md` : journal daté des décisions, avec la raison et les alternatives écartées.
  - `architecture.md` : structure, choix techniques, dépendances clés.
  - `erreurs.md` : problèmes rencontrés, cause racine, solution validée.

### Procédure de lecture
1. Lire `etat.md` en premier : il donne le point de reprise.
2. Lire `decisions.md` pour ne pas rouvrir un arbitrage déjà tranché.
3. Consulter `erreurs.md` avant de déboguer : le problème a peut-être déjà été résolu.
4. Ne charger `architecture.md` que si la tâche touche à la structure.

### Procédure d'écriture
5. **Avant d'écrire, relire** la section concernée pour éviter le doublon.
6. **Enregistrer une décision** : date, décision, raison, alternatives écartées,
   conditions qui la remettraient en cause. Sans la raison, la décision sera rouverte.
7. **Enregistrer une erreur résolue** : symptôme, cause racine, correction, prévention.
8. **Mettre à jour l'état** en fin de session : ce qui est fait, ce qui reste,
   la prochaine action précise. « Prochaine action » doit être exécutable sans réflexion.
9. **Dédoublonner** : deux entrées sur le même sujet sont fusionnées, la plus récente prime.
10. **Retirer l'obsolète** des fichiers de projet uniquement quand c'est sûr :
    une décision explicitement remplacée, une tâche terminée, un fichier supprimé.
    En cas de doute, déplacer vers une section « Historique » plutôt que supprimer.
    Ne jamais supprimer une décision structurante, même remplacée : la marquer
    comme remplacée en indiquant par quoi.
11. **Vérifier l'absence de secret** avant toute écriture.

### Résumé de reprise
12. Produire : objectif du projet · état actuel · dernières décisions ·
    travail terminé · travail restant · prochaine action · pièges connus.

## Contrôles qualité
- [ ] Aucun secret, mot de passe, jeton ou clé n'a été écrit.
- [ ] Aucun doublon introduit : la section a été relue avant écriture.
- [ ] Chaque décision porte sa date et sa raison.
- [ ] Rien d'utile n'a été supprimé ; les éléments incertains sont archivés, pas effacés.
- [ ] La séparation mémoire globale / mémoire projet est respectée.
- [ ] La « prochaine action » est précise et exécutable telle quelle.

## Critères de fin
- La mémoire reflète l'état réel du projet, sans contradiction ni doublon.
- Un résumé de reprise permet de redémarrer sans relire l'historique.

## Format de livrable
Fichiers de mémoire mis à jour · Résumé de reprise · Liste des éléments
archivés ou retirés, avec la justification.

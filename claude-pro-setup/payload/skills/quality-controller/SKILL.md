---
name: quality-controller
description: Vérification finale de tout livrable important avant remise : complétude par rapport à la demande, exactitude et sourçage, cohérence interne, vérification réelle par exécution ou test, risques signalés, et verdict de livraison. Utiliser avant de remettre un livrable important, quand l'utilisateur demande de vérifier ou relire un travail, ou avant de déclarer une tâche terminée.
---

# Contrôle qualité final

## Quand utiliser cette Skill
- Un livrable important est sur le point d'être remis.
- Avant de déclarer une tâche terminée.
- L'utilisateur demande une relecture ou une validation.

## Quand ne PAS l'utiliser
- Réponse conversationnelle courte sans livrable.

## Procédure
1. **Relire la demande d'origine**, pas le livrable en premier.
   Lister les exigences explicites ET implicites. La cause première d'un livrable
   rejeté est une exigence oubliée, pas une erreur de fond.
2. **Complétude** : chaque exigence est-elle traitée ? Marquer chacune
   traitée / partielle / absente. Une exigence partielle doit être signalée, pas arrondie.
3. **Exactitude** : les affirmations factuelles sont-elles sourcées et datées ?
   Une donnée non sourcée est requalifiée en hypothèse ou retirée.
4. **Vérification réelle** : pour du code, exécuter ; pour une commande, la lancer ;
   pour une interface, l'ouvrir dans un navigateur ; pour un calcul, le refaire.
   Ne jamais valider sur la seule lecture. « Ça devrait marcher » n'est pas une vérification.
5. **Cohérence interne** : les chiffres concordent-ils d'une section à l'autre,
   les conclusions découlent-elles des éléments présentés, la terminologie est-elle stable ?
6. **Régressions et effets de bord** : quelque chose qui fonctionnait a-t-il pu être cassé ?
7. **Risques** : sont-ils explicitement signalés, avec leur gravité ?
8. **Sécurité** : aucun secret, jeton, clé, mot de passe ni donnée personnelle
   dans le livrable, le code, les journaux ou les exemples.
9. **Forme** : le livrable est-il structuré, réutilisable, compréhensible sans
   l'historique de la conversation ?
10. **Cohérence avec le projet** : respecte-t-il les décisions déjà prises
    et les conventions établies ?
11. **Verdict** — trois valeurs possibles, et seulement trois.
    Ce ne sont **pas** GO / WAIT / NO : ce vocabulaire appartient à `decision-gate`
    et ne s'applique qu'aux décisions d'engagement. Ici, on juge un livrable.
    Ne jamais inventer une quatrième valeur, même quand la situation semble ne
    rentrer dans aucune :
    - **VALIDÉ** : toutes les exigences traitées, vérification réelle effectuée.
    - **VALIDÉ AVEC RÉSERVES** : livrable utilisable, réserves listées explicitement.
    - **NON VALIDÉ** : exigence majeure absente, vérification échouée, **ou
      vérification impossible**. Lister ce qui manque et ce qu'il faut faire.

    **Cas « vérification impossible »** : le livrable n'est pas fourni, le code
    n'est pas lisible, rien ne peut être exécuté. Le verdict est **NON VALIDÉ**,
    avec le motif « vérification impossible » — et non un jugement sur le fond.
    Préciser alors ce qu'il faut fournir pour qu'une vraie revue ait lieu.
    Ne jamais valider sur description : une absence de preuve n'est pas une preuve.

## Contrôles qualité
- [ ] La demande d'origine a été relue avant l'évaluation.
- [ ] Chaque exigence est marquée traitée, partielle ou absente.
- [ ] Une vérification réelle a été effectuée, pas une simple relecture.
- [ ] Aucun secret ni donnée sensible n'est présent.
- [ ] Les risques et limites sont écrits.
- [ ] Le verdict est unique, pris dans les trois valeurs autorisées, et justifié.
- [ ] Une vérification impossible donne NON VALIDÉ avec le motif, jamais un
      verdict inventé ni une validation de complaisance.

## Critères de fin
- Un verdict unique est rendu avec la liste des réserves ou des manques.
- Rien n'est déclaré terminé sans preuve de vérification.

## Format de livrable
**VERDICT : VALIDÉ / VALIDÉ AVEC RÉSERVES / NON VALIDÉ** ·
Tableau des exigences (traitée/partielle/absente) · Vérifications effectuées et résultats ·
Réserves et risques · Actions restantes.

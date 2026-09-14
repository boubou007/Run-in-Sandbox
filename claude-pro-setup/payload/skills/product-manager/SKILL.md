---
name: product-manager
description: Travail de product management : besoins utilisateurs, document de spécification produit (PRD), user stories, critères d'acceptation, périmètre du MVP, priorisation des fonctionnalités, feuille de route et indicateurs de succès. Utiliser quand l'utilisateur veut spécifier une application ou une fonctionnalité, définir un MVP, prioriser un backlog ou rédiger des besoins.
---

# Gestion de produit

## Quand utiliser cette Skill
- Transformer une idée de produit en spécification exploitable par un développeur.
- Arbitrer entre plusieurs fonctionnalités avec des ressources limitées.
- Définir le périmètre d'un MVP et ce qui en est exclu.

## Quand ne PAS l'utiliser
- Choix techniques d'implémentation → app-architect.
- Modèle économique et validation marché → business-builder.

## Procédure
1. **Problème et utilisateur** : qui, quel problème, dans quel contexte, à quelle
   fréquence, et quel est le coût actuel du problème. Sans cela, toute priorisation est arbitraire.
2. **Résultat visé** : le changement mesurable attendu, pas la fonctionnalité.
   « réduire l'abandon au paiement de 30 % » plutôt que « ajouter un bouton ».
3. **Parcours utilisateur** : étapes de bout en bout, points de friction actuels,
   cas limites, états d'erreur et états vides. Les états vides et d'erreur sont
   systématiquement oubliés et coûtent cher en fin de projet.
4. **User stories** : « En tant que [rôle], je veux [action] afin de [bénéfice] ».
   Chaque story porte des critères d'acceptation vérifiables, formulés en
   conditions observables (Étant donné / Quand / Alors).
5. **Priorisation** : impact sur le résultat visé, effort estimé, risque, dépendances.
   Traiter d'abord les éléments à fort impact et faible effort, et les dépendances bloquantes.
6. **Périmètre du MVP** : écrire explicitement ce qui est DANS et ce qui est HORS.
   La liste HORS est aussi importante que la liste DANS.
7. **Feuille de route** : jalons avec un livrable démontrable par jalon.
8. **Indicateurs de succès** : définis avant le développement, avec la valeur de départ
   et la cible. Prévoir comment ils seront mesurés.
9. **Risques** : techniques, dépendances externes, adoption, réglementaires.

## Contrôles qualité
- [ ] Chaque fonctionnalité est rattachée à un problème utilisateur réel.
- [ ] Les critères d'acceptation sont vérifiables sans interprétation.
- [ ] Les cas limites, états d'erreur et états vides sont spécifiés.
- [ ] Le périmètre exclu du MVP est écrit noir sur blanc.
- [ ] Les indicateurs de succès sont mesurables et leur mode de mesure est défini.

## Critères de fin
- Le PRD couvre problème, parcours, stories, critères, périmètre, jalons et indicateurs.
- Un développeur peut commencer sans avoir à deviner.

## Format de livrable
PRD : Contexte et problème · Résultat visé · Parcours · User stories avec critères ·
Périmètre DANS/HORS · Feuille de route · Indicateurs · Risques · Questions ouvertes.

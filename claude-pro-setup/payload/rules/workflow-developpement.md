# Règle — Workflow de développement

Référence chargée à la demande.

## Projet de programmation important
1. **Comprendre** : reformuler la demande, identifier les exigences implicites,
   lever les ambiguïtés avant de coder.
2. **Inspecter** : lire le code existant, les conventions, les tests, les dépendances.
   Ne jamais proposer une architecture sans avoir vu l'existant.
3. **Planifier** : découper en étapes avec un livrable par étape.
4. **Valider l'architecture** avec l'utilisateur avant l'implémentation lourde.
   Une architecture validée tard coûte une réécriture.
5. **Implémenter** par incréments testables, en respectant les conventions du projet.
6. **Tester** : exécuter réellement les tests, pas seulement les écrire.
7. **Inspecter visuellement** si l'interface est concernée : ouvrir dans un vrai
   navigateur, vérifier desktop et mobile.
8. **Corriger** les écarts constatés.
9. **Revoir** : relecture critique du diff, recherche de régressions,
   revue de sécurité si le code touche à l'authentification, aux données ou aux entrées.
10. **Documenter** les décisions structurantes et les compromis acceptés.
11. **Mettre à jour la mémoire** du projet : état, décisions, prochaine action.

## Correction de bug
1. **Reproduire** avant toute modification. Sans reproduction, la correction ne
   peut pas être validée.
2. **Identifier la cause racine**, pas le symptôme visible.
3. **Corriger au minimum** : la plus petite modification qui traite la cause.
   Ne pas mélanger correction et refactorisation.
4. **Tester** le cas d'origine et les cas limites.
5. **Chercher les régressions** activement sur les fonctionnalités connexes.
6. **Ajouter un test** qui échouait avant et réussit après.
7. **Documenter** la cause et le moyen de prévention.
8. **Vérifier** si le même défaut existe ailleurs dans le code.

## Interdits
- Supprimer ou désactiver un test pour faire passer la suite.
- Supprimer une fonctionnalité existante pour contourner un problème.
- Déclarer terminé sans avoir exécuté une vérification réelle.
- Modifier du code sans avoir compris pourquoi il était écrit ainsi.

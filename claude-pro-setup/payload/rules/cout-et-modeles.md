# Règle — Coût et choix de modèle

Référence chargée à la demande. Objectif : ne jamais payer plus que nécessaire,
sans jamais sacrifier la fiabilité d'une tâche importante.

## Choix du modèle
- Utiliser le modèle disponible le plus économique capable de réussir la tâche.
- Réserver les modèles les plus puissants aux décisions complexes : architecture,
  arbitrages business, diagnostics difficiles, revue de sécurité.
- Tâches mécaniques et reproductibles (reformatage, extraction, renommage,
  application d'un patron connu) : modèle économique.
- Basculer vers un modèle plus puissant dès qu'une tâche importante échoue deux fois.
  Insister avec un modèle insuffisant coûte plus cher que de changer.

## Mode plan
Utiliser le mode plan avant toute modification importante : refonte, migration,
changement structurant, intervention sur du code critique.
Un plan validé coûte moins cher qu'une implémentation à refaire.

## Sous-agents
- Un seul agent quand un seul suffit.
- Paralléliser uniquement les recherches et analyses lourdes et indépendantes.
- Ne jamais déléguer une tâche triviale : le coût de coordination dépasse le gain.
- Chaque sous-agent doit recevoir un brief complet (objectif, contexte, format de
  sortie attendu) et ne renvoyer que sa conclusion, pas son cheminement.

## Réduction du contexte
- Lire des extraits ciblés, jamais un gros fichier entier « pour voir ».
- Ne pas relire un fichier déjà lu dans la session.
- Filtrer les sorties de commandes : limiter les lignes, extraire l'utile.
- Désactiver les serveurs MCP inutiles pour la tâche en cours : leurs définitions
  d'outils occupent le contexte en permanence, même sans être appelées.
- Skills à chargement à la demande plutôt que d'alourdir CLAUDE.md, qui est permanent.
- Fichiers de référence séparés plutôt qu'un CLAUDE.md volumineux.

## Limite
Ne jamais dégrader la fiabilité d'une tâche importante pour économiser quelques
tokens. Un livrable faux à refaire coûte toujours plus cher que le modèle adéquat.

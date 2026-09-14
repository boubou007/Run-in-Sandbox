---
name: prompt-engineer
description: Création, structuration et optimisation de prompts pour Claude, GPT, Gemini et outils génératifs texte ou image : cadrage du rôle, contexte, contraintes, format de sortie, exemples, découpage en étapes, gestion des échecs et évaluation. Utiliser quand l'utilisateur veut écrire, améliorer ou déboguer un prompt, obtenir des réponses plus fiables d'une IA, ou construire une instruction système.
---

# Ingénierie de prompts

## Quand utiliser cette Skill
- Un prompt donne des résultats instables, incomplets ou hors sujet.
- Construire une instruction système ou un modèle de prompt réutilisable.
- Concevoir un prompt pour un générateur d'images.

## Quand ne PAS l'utiliser
- Écrire une Skill Claude Code complète → utiliser le créateur de Skills dédié.
- Architecturer un système multi-agents → automation-architect.

## Procédure
1. **Définir la sortie attendue en premier** : format exact, longueur, structure,
   ce qui doit être présent et absent. Un prompt se conçoit à rebours du livrable.
2. **Structurer** : rôle et expertise · contexte et données · tâche précise ·
   contraintes · format de sortie · critères de qualité.
3. **Être spécifique** : remplacer les adjectifs vagues par des critères vérifiables.
   « professionnel » ne veut rien dire ; « phrases de 15 mots maximum, sans jargon,
   ton direct » est actionnable.
4. **Exemples** : un à trois exemples de sortie correcte valent mieux qu'une longue
   description. Inclure aussi un contre-exemple lorsque l'erreur est récurrente.
5. **Découper** : pour une tâche complexe, demander un raisonnement par étapes
   ou séparer en plusieurs prompts chaînés plutôt qu'un seul prompt surchargé.
6. **Gérer l'incertitude** : instruire explicitement le modèle de dire quand une
   information manque plutôt que de l'inventer. C'est la contrainte la plus rentable.
7. **Prompts d'image** : sujet · action · cadrage et plan · style et référence
   artistique · lumière · palette · ambiance · niveau de détail · format et ratio ·
   éléments à exclure. Ordonner du plus important au moins important.
8. **Tester et itérer** : exécuter le prompt 3 à 5 fois. Un prompt qui ne réussit
   qu'une fois sur trois n'est pas fiable. Corriger la cause de l'échec, pas le symptôme.
9. **Documenter** : consigner la version, ce qui a changé et pourquoi.

## Contrôles qualité
- [ ] Le format de sortie est défini sans ambiguïté.
- [ ] Les critères subjectifs ont été traduits en critères vérifiables.
- [ ] Le prompt instruit le modèle sur la conduite à tenir en cas d'information manquante.
- [ ] Le prompt a été testé plusieurs fois et donne un résultat stable.
- [ ] Aucune donnée sensible ou secret n'est inclus dans le prompt.

## Critères de fin
- Le prompt est testé, stable sur plusieurs exécutions, et documenté.
- Les limites connues du prompt sont écrites.

## Format de livrable
Prompt final · Notes de conception · Résultats des tests · Variantes ·
Limites et cas d'échec connus.

---
name: context-token-manager
description: Maintenir Claude rapide et économique : mesurer l'occupation du contexte, identifier les postes de consommation, réduire les lectures inutiles, préserver les décisions avant compactage, et recommander KEEP, COMPACT ou CLEAR. Fournit la procédure d'audit de contexte (token-audit). Utiliser quand la session devient lente, longue ou coûteuse, avant un compactage, lors d'un changement de tâche, ou quand l'utilisateur demande un audit de contexte, de coût ou d'utilisation.
---

# Gestion du contexte et des tokens

## Quand utiliser cette Skill
- La session est longue et la saturation approche.
- Avant un compactage, pour préserver ce qui compte.
- Changement réel de tâche.
- L'utilisateur demande un audit de contexte, de coût ou d'usage.

## Quand ne PAS l'utiliser
- Session courte et fluide : l'audit consomme plus qu'il n'économise.

## Procédure
### Commandes disponibles
`/context` occupation du contexte · `/cost` coût de la session ·
`/usage` consommation par rapport aux limites · `/compact` résumé et compression ·
`/clear` réinitialisation complète.

### Règles d'économie permanentes
1. Ne jamais charger un document entier quand un extrait suffit : cibler par recherche
   puis lire la plage utile.
2. Ne jamais relire un fichier déjà lu dans la session, sauf modification depuis.
3. Filtrer les sorties de commandes : limiter les lignes, extraire ce qui est utile.
   Une sortie de terminal brute de plusieurs centaines de lignes est du gaspillage pur.
4. Préférer une recherche ciblée à un parcours exhaustif de l'arborescence.
5. Limiter les résultats MCP aux champs nécessaires ; désactiver les serveurs MCP
   inutiles pour la tâche en cours : leurs définitions d'outils occupent le contexte
   en permanence, même sans être appelées.
6. Charger les Skills à la demande plutôt que gonfler CLAUDE.md :
   CLAUDE.md est permanent, une Skill ne se charge que lorsqu'elle est pertinente.
7. Déléguer les explorations volumineuses à un sous-agent : il consomme son propre
   contexte et ne renvoie que sa conclusion.

### Procédure /token-audit
1. **Occupation actuelle** : exécuter `/context`, relever le pourcentage utilisé.
2. **Principaux postes de consommation** : instructions système, CLAUDE.md,
   définitions d'outils MCP, fichiers lus, sorties de commandes, historique de conversation.
   Identifier les trois plus lourds.
3. **Skills actives** : lesquelles sont chargées, lesquelles servent encore.
4. **MCP pertinents** : lesquels sont utiles à la tâche en cours, lesquels ne le sont pas.
5. **Éléments inutiles** : fichiers lus et devenus hors sujet, sorties volumineuses,
   explorations abandonnées, tâches terminées.
6. **Niveau de risque de saturation** : faible (< 50 %), moyen (50-70 %),
   élevé (70-85 %), critique (> 85 %).
7. **Recommandation** :
   - **KEEP** : occupation < 60 % et tâche en cours. Ne rien faire.
   - **COMPACT** : occupation 60-85 % et la tâche continue.
     Avant de compacter, écrire explicitement les décisions prises, l'état d'avancement
     et la prochaine action, afin qu'elles survivent au résumé.
   - **CLEAR** : changement réel de tâche, ou occupation critique avec un état
     déjà sauvegardé. Ne jamais utiliser `/clear` en cours de travail sans avoir
     d'abord enregistré l'état via memory-manager.
8. **Actions recommandées** : liste concrète et ordonnée.

## Contrôles qualité
- [ ] L'occupation réelle a été mesurée, pas estimée.
- [ ] Les trois principaux postes de consommation sont nommés.
- [ ] La recommandation est unique : KEEP, COMPACT ou CLEAR.
- [ ] Si COMPACT ou CLEAR : les décisions et l'état ont été préservés AVANT l'action.
- [ ] Aucune information nécessaire à la suite du travail n'est perdue.

## Critères de fin
- L'audit est rendu avec une recommandation unique et des actions ordonnées.
- Si une action est exécutée, l'état a été préservé au préalable.

## Format de livrable
**Audit de contexte** : Occupation · Top 3 des postes de consommation ·
Skills actives · MCP pertinents et inutiles · Éléments supprimables ·
Niveau de risque · **Recommandation : KEEP / COMPACT / CLEAR** · Actions ordonnées.

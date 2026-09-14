---
description: Audit du contexte et des tokens de la session, avec recommandation KEEP, COMPACT ou CLEAR
allowed-tools: Read, Glob, Grep
---

Réalise un audit de contexte en appliquant la Skill `context-token-manager`.

Produis exactement ces rubriques, sans en omettre aucune :

1. **Occupation actuelle du contexte** — pourcentage utilisé. Si tu ne peux pas
   le mesurer directement, dis-le et donne ton estimation en la marquant comme telle.
   N'invente jamais un chiffre précis.
2. **Principaux postes de consommation** — les trois plus lourds, nommés.
3. **Skills actives** — lesquelles sont chargées, lesquelles servent encore.
4. **MCP pertinents** — utiles à la tâche en cours, et ceux qui ne le sont pas.
5. **Éléments inutiles** — fichiers lus devenus hors sujet, sorties volumineuses,
   explorations abandonnées, tâches terminées.
6. **Niveau de risque de saturation** — faible (<50 %), moyen (50-70 %),
   élevé (70-85 %), critique (>85 %).
7. **Recommandation** — **KEEP**, **COMPACT** ou **CLEAR**, une seule.
8. **Actions recommandées** — concrètes et ordonnées.

Règle impérative : si tu recommandes COMPACT ou CLEAR, écris d'abord
explicitement les décisions prises, l'état d'avancement et la prochaine action,
afin qu'ils survivent à l'opération. Ne propose jamais `/clear` en cours de
travail sans cette préservation préalable.

Reste concis : cet audit ne doit pas lui-même consommer un contexte significatif.

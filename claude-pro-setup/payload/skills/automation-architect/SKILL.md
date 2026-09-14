---
name: automation-architect
description: Concevoir des automatisations fiables : cartographie du processus, choix de l'outil (n8n, Make, Zapier, script, agent), intégrations API et webhooks, serveurs MCP, orchestration, gestion des erreurs, idempotence, sécurité des secrets et supervision. Utiliser quand l'utilisateur veut automatiser une tâche, connecter des outils, créer un workflow, un agent, un webhook ou une intégration API.
---

# Architecture d'automatisation

## Quand utiliser cette Skill
- Un processus répétitif doit être automatisé de façon fiable.
- Plusieurs outils doivent être connectés entre eux.
- Une automatisation existante échoue silencieusement ou en double.

## Quand ne PAS l'utiliser
- Le processus n'est pas encore stable : le stabiliser manuellement d'abord.
  Automatiser un processus instable multiplie les erreurs.
- Il s'agit d'architecture applicative → app-architect.

## Procédure
1. **Cartographier le processus manuel** : déclencheur, étapes, données en entrée et
   en sortie, décisions, exceptions, fréquence, temps consommé. Chiffrer le gain attendu.
2. **Vérifier la rentabilité** : temps de construction et de maintenance contre temps gagné.
   Une automatisation fragile qui demande une surveillance constante fait perdre du temps.
3. **Choisir l'outil selon le besoin réel** :
   - Interface visuelle (n8n, Make, Zapier) : intégrations standard, itération rapide,
     maintenance par un non-développeur. Coût à l'exécution, moins de contrôle fin.
   - Script : logique complexe, gros volumes, contrôle total, coût marginal nul.
     Exige une compétence de maintenance.
   - Agent avec MCP : tâches nécessitant du jugement ou du langage naturel.
     Non déterministe : ne pas l'utiliser là où une règle fixe suffit.
4. **Concevoir les flux de données** : format, validation à l'entrée, transformations,
   correspondance des champs, encodage. Valider avant de traiter, jamais après.
5. **Idempotence** : une même exécution répétée ne doit pas produire de doublon.
   Utiliser une clé d'idempotence ou un contrôle d'existence préalable.
   C'est la source d'erreur numéro un des automatisations.
6. **Gestion des erreurs** : distinguer erreur temporaire (relance avec délai croissant)
   et erreur définitive (arrêt et alerte). Prévoir une file d'échec pour reprise manuelle.
   Une automatisation qui échoue en silence est pire que pas d'automatisation.
7. **Limites d'API** : quotas, limitation de débit, pagination, coût par appel,
   politique de dépréciation.
8. **Sécurité** : secrets dans un gestionnaire dédié, jamais dans le flux ni dans un dépôt.
   Jetons à portée minimale. Webhooks entrants signés et vérifiés. Journaux sans données sensibles.
9. **Supervision** : journal d'exécution, alerte en cas d'échec, indicateur de réussite,
   contrôle périodique que le flux tourne réellement.
10. **Tester** : cas nominal, données malformées, service indisponible, exécution en double,
    volume élevé. Documenter le fonctionnement et la procédure de reprise manuelle.

## Contrôles qualité
- [ ] Le gain de temps est chiffré et supérieur au coût de maintenance.
- [ ] L'automatisation est idempotente : pas de doublon en cas de reprise.
- [ ] Les erreurs temporaires et définitives sont traitées différemment.
- [ ] Un échec déclenche une alerte visible.
- [ ] Aucun secret n'apparaît en clair dans le flux, les journaux ou un dépôt.
- [ ] Une procédure de reprise manuelle est documentée.

## Critères de fin
- Le flux est construit, testé sur les cas nominaux ET d'erreur, et supervisé.
- La documentation permet à quelqu'un d'autre de le reprendre.

## Format de livrable
Schéma du flux · Choix d'outil justifié · Configuration · Matrice de gestion d'erreurs ·
Plan de supervision · Résultats de test · Procédure de reprise manuelle.

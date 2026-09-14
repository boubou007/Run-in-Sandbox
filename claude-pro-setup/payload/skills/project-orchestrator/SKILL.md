---
name: project-orchestrator
description: Décomposer un projet complexe en étapes, choisir les Skills nécessaires, déléguer les analyses lourdes à des sous-agents en parallèle, consolider les résultats et vérifier la cohérence d'ensemble. Utiliser quand une demande couvre plusieurs domaines, nécessite plusieurs étapes dépendantes, ou quand l'utilisateur demande de piloter, planifier ou coordonner un projet complet.
---

# Orchestration de projet

## Quand utiliser cette Skill
- La demande couvre plusieurs domaines (marché, produit, design, technique).
- Le travail comporte des étapes dépendantes qui doivent être ordonnées.
- Des recherches ou analyses lourdes peuvent être menées en parallèle.

## Quand ne PAS l'utiliser
- Tâche relevant d'un seul domaine : invoquer directement la Skill concernée.
  Orchestrer une tâche simple coûte plus qu'elle ne rapporte.

## Procédure
1. **Clarifier le résultat final attendu** et son critère d'acceptation.
   Si le résultat attendu n'est pas clair, le clarifier avant toute décomposition.
2. **Décomposer** en étapes, chacune avec un livrable identifiable.
3. **Établir les dépendances** : ce qui doit précéder quoi. Repérer ce qui peut
   être mené en parallèle sans risque d'incohérence.
4. **Affecter une Skill par étape** :
   - Vérification et sources → research-verification
   - Marché, tendance, concurrence → market-intelligence, trend-radar, competitive-intelligence
   - Décision d'engagement → decision-gate
   - Modèle et offre → business-builder
   - Acquisition et message → marketing-strategist, copywriting-pro, seo-expert
   - Spécification → product-manager
   - Technique → app-architect, qa-debugging, automation-architect
   - Interface → web-design-pro, ui-ux-audit, design-system, landing-page-conversion
   - Vérification finale → quality-controller
5. **Déléguer aux sous-agents** les étapes lourdes et indépendantes.
   Un sous-agent doit recevoir : objectif, contexte nécessaire, format de sortie
   attendu, contraintes. Un brief incomplet produit un résultat inutilisable.
   Ne pas déléguer les tâches triviales : le coût de coordination dépasse le gain.
6. **Consolider** : rassembler les livrables, détecter les contradictions entre
   résultats d'agents. Une contradiction non traitée se propage dans tout le livrable final.
7. **Vérifier la cohérence d'ensemble** : les conclusions s'enchaînent-elles,
   les hypothèses d'une étape sont-elles compatibles avec les résultats d'une autre ?
8. **Passer le tout à quality-controller** avant livraison.
9. **Enregistrer** les décisions structurantes via memory-manager.

## Contrôles qualité
- [ ] Le résultat final attendu est explicite et son critère d'acceptation écrit.
- [ ] Les dépendances entre étapes sont correctes : rien ne démarre sans son préalable.
- [ ] La parallélisation ne crée pas d'incohérence entre résultats.
- [ ] Chaque sous-agent a reçu un brief complet et un format de sortie.
- [ ] Les contradictions entre livrables ont été recherchées et traitées.
- [ ] Aucune étape n'a été déclarée terminée sans son livrable.

## Critères de fin
- Toutes les étapes sont livrées, cohérentes entre elles, et consolidées.
- La vérification finale par quality-controller est passée.

## Format de livrable
Plan d'exécution avec étapes, Skills et dépendances · Livrables consolidés ·
Contradictions relevées et arbitrées · Décisions enregistrées · Reste à faire.

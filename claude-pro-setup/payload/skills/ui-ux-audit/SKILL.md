---
name: ui-ux-audit
description: Auditer une interface existante : clarté de l'objectif, navigation, hiérarchie visuelle, lisibilité, formulaires, états, cohérence, accessibilité, expérience mobile et obstacles à la conversion, avec des correctifs priorisés par impact. Utiliser quand l'utilisateur demande un avis sur une interface, veut savoir pourquoi ça ne convertit pas, ou demande un audit UX, UI ou d'ergonomie.
---

# Audit d'interface

## Quand utiliser cette Skill
- Une interface existe et ses performances ou son ergonomie déçoivent.
- Un avis structuré est demandé avant une refonte.

## Quand ne PAS l'utiliser
- Il faut concevoir depuis zéro → web-design-pro.
- Le problème est un bug fonctionnel → qa-debugging.

## Procédure
1. **Établir le critère d'évaluation** : objectif de la page et action attendue.
   Sans objectif, un audit devient une liste de préférences personnelles.
2. **Test des cinq secondes** : au premier regard, comprend-on ce que c'est,
   pour qui, et quelle est l'action suivante ?
3. **Navigation** : libellés compréhensibles hors contexte, position courante visible,
   chemin de retour évident, profondeur raisonnable, recherche si le volume l'exige.
4. **Hiérarchie visuelle** : l'élément le plus important est-il le plus visible ?
   Compter les éléments qui se disputent l'attention. Plus de trois niveaux de
   priorité simultanés signifie aucune priorité.
5. **Lisibilité** : contraste, taille de corps (16 px minimum sur mobile),
   longueur de ligne, hauteur de ligne, densité, découpage du texte.
6. **Formulaires** : nombre de champs justifié, libellés persistants (pas uniquement
   des textes d'aide qui disparaissent), validation au bon moment, messages d'erreur
   qui expliquent comment corriger, ordre de tabulation logique, sauvegarde de la saisie.
7. **États** : chargement, vide, erreur, succès, désactivé, aucun résultat.
   Les états vides et d'erreur sont presque toujours négligés et cassent la confiance.
8. **Cohérence** : composants identiques pour des fonctions identiques,
   vocabulaire stable, espacement et arrondis réguliers.
9. **Accessibilité** : parcours clavier complet, focus visible, structure de titres,
   textes alternatifs, contrastes, cibles tactiles, absence de sens porté par la seule couleur.
10. **Mobile** : tester réellement en largeur réduite. Défilement horizontal,
    éléments fixes qui masquent le contenu, cibles trop petites, menus inaccessibles.
11. **Frein à la conversion** : friction, doute non levé, absence de preuve,
    coût caché, engagement perçu trop fort, appel à l'action ambigu.
12. **Prioriser** : classer chaque constat par impact (élevé, moyen, faible) et
    effort (faible, moyen, élevé). Traiter d'abord impact élevé et effort faible.

## Contrôles qualité
- [ ] Chaque constat est rattaché à l'objectif de la page, pas à un goût personnel.
- [ ] Chaque problème est accompagné d'un correctif concret et applicable.
- [ ] L'audit couvre desktop ET mobile, vérifiés réellement.
- [ ] L'accessibilité est évaluée, pas seulement l'esthétique.
- [ ] Les constats sont priorisés par impact et effort.

## Critères de fin
- Tous les axes sont couverts et chaque constat a un correctif priorisé.
- Les trois actions à plus fort impact sont identifiées en tête de rapport.

## Format de livrable
Rapport d'audit : Objectif évalué · Constats par axe avec gravité ·
Correctif proposé pour chaque constat · Tableau de priorisation impact/effort ·
Top 3 des actions immédiates.

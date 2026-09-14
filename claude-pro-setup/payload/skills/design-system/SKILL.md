---
name: design-system
description: Créer et maintenir un design system : jetons de couleur, typographie, espacement, rayons, ombres, grille, bibliothèque de composants, variantes, états, règles d'usage, documentation, accessibilité et gouvernance des évolutions. Utiliser quand l'utilisateur veut unifier son interface, créer des composants réutilisables, définir des design tokens, une charte d'interface ou une bibliothèque de composants.
---

# Design system

## Quand utiliser cette Skill
- Plusieurs pages ou produits doivent partager une identité cohérente.
- L'interface dérive : styles dupliqués, valeurs arbitraires, incohérences.
- Une équipe doit produire des interfaces sans tout redécider.

## Quand ne PAS l'utiliser
- Un site unique de quelques pages : un système complet est un surcoût inutile.
- Auditer l'existant → ui-ux-audit.

## Procédure
1. **Inventaire de l'existant** : recenser toutes les couleurs, tailles, espacements,
   arrondis et composants réellement utilisés. L'inventaire révèle l'ampleur de la dérive
   et sert de base de rationalisation.
2. **Jetons primitifs** : la palette brute et les échelles, nommées de façon neutre
   (`blue-500`, `space-4`). Aucune référence à un usage.
3. **Jetons sémantiques** : la couche qui porte le sens (`surface`, `surface-elevated`,
   `text-primary`, `text-muted`, `border`, `accent`, `success`, `warning`, `danger`).
   Les composants consomment uniquement les jetons sémantiques.
   C'est cette couche qui rend possible un changement de thème ou de marque sans tout réécrire.
4. **Échelles** :
   - Espacement : progression régulière sur une unité de base (4 ou 8 px).
   - Typographie : échelle modulaire, rôles nommés (display, titre 1 à 3, corps,
     légende), avec hauteur de ligne et graisse associées.
   - Rayons, ombres, épaisseurs de bordure, durées d'animation : échelles limitées.
   Limiter le nombre de valeurs est l'objectif : un système avec trop d'options
   ne contraint rien et ne sert à rien.
5. **Composants** : commencer par les plus utilisés (bouton, champ, carte, modale,
   navigation, tableau, notification). Pour chacun : anatomie, variantes,
   tailles, états (défaut, survol, focus, actif, désactivé, chargement, erreur),
   règles d'usage et contre-exemples.
6. **Accessibilité intégrée** : contrastes validés pour chaque paire de jetons,
   focus visible normalisé, cibles tactiles minimales, sémantique HTML par défaut.
   L'accessibilité doit être une propriété du système, pas une vérification finale.
7. **Documentation** : pour chaque composant, l'usage prévu, l'usage à éviter,
   le code d'exemple et les props.
8. **Gouvernance** : qui peut ajouter un jeton ou un composant, comment une valeur
   ponctuelle est proscrite, comment un changement cassant est communiqué, versionnage.
9. **Adoption** : migrer progressivement, en commençant par les pages à fort trafic.

## Contrôles qualité
- [ ] Les composants n'utilisent que des jetons sémantiques, aucune valeur brute.
- [ ] Chaque échelle est limitée : pas de valeur hors échelle.
- [ ] Tous les états de chaque composant sont définis, y compris focus et erreur.
- [ ] Les contrastes des paires de jetons sont validés en mode clair et sombre.
- [ ] Chaque composant a un exemple d'usage et un contre-exemple.
- [ ] Une règle de gouvernance existe pour les évolutions.

## Critères de fin
- Jetons, échelles et composants prioritaires sont définis et documentés.
- Un développeur peut construire une page nouvelle sans inventer de valeur.

## Format de livrable
Fichier de jetons (primitifs et sémantiques) · Échelles documentées ·
Fiches de composants avec variantes et états · Règles d'accessibilité ·
Règles de gouvernance · Plan de migration.

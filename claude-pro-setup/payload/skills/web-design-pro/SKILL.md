---
name: web-design-pro
description: Concevoir et implémenter des sites web professionnels de bout en bout : cadrage, architecture, wireframes, UX, UI, design system, typographie, grilles, espacement, responsive, dark mode, animations, accessibilité, SEO technique, performance et Core Web Vitals, en HTML/CSS/JS, TypeScript, React, Next.js et Tailwind. Utiliser quand l'utilisateur veut créer, refondre ou améliorer un site, une landing page, un site SaaS, un dashboard, une boutique, un portfolio ou une interface web.
---

# Conception de sites web professionnels

## Quand utiliser cette Skill
- Créer un site ou une interface web, de la conception à l'implémentation.
- Refondre un site existant dont le design ou la conversion est insuffisante.
- Implémenter une interface qui doit être responsive, accessible et performante.

## Quand ne PAS l'utiliser
- Auditer une interface existante sans la reconstruire → ui-ux-audit.
- Optimiser uniquement une page de conversion → landing-page-conversion.
- Créer un système de composants réutilisable → design-system.

## Procédure
### Phase 1 — Cadrage (obligatoire avant toute ligne de code)
Ne jamais commencer à coder sans avoir répondu à ces sept points :
1. **Objectif du site** : ce que le site doit accomplir pour l'entreprise.
2. **Public** : qui vient, avec quel niveau de connaissance, sur quel appareil,
   dans quel contexte (mobile en déplacement, bureau, connexion lente).
3. **Conversion principale** : l'action unique qui compte. Une seule.
   Les actions secondaires ne doivent jamais lui faire concurrence visuellement.
4. **Architecture** : pages, hiérarchie, navigation, parcours principal.
5. **Contenu** : le contenu réel, ou à défaut un contenu représentatif en volume.
   Concevoir avec du faux texte court produit des mises en page qui cassent en production.
6. **Direction visuelle** : positionnement, références assumées, ce qu'il faut éviter.
7. **Contraintes techniques** : stack imposée, CMS, hébergement, navigateurs,
   budget de performance, contraintes d'accessibilité légales.

### Phase 2 — Structure
8. **Wireframes** : structure avant esthétique. Ordre de lecture, hiérarchie de
   l'information, emplacement des appels à l'action, états vides et états d'erreur.
9. **Grille et rythme** : grille 12 colonnes courante, largeur de contenu maîtrisée
   (65 à 75 caractères par ligne pour le texte courant), échelle d'espacement basée
   sur une unité (4 ou 8 px). L'espacement cohérent est ce qui distingue le plus
   nettement une interface professionnelle d'une interface amateur.

### Phase 3 — Direction artistique
10. **Typographie** : deux familles maximum, échelle modulaire (ratio 1,2 à 1,333),
    hauteur de ligne 1,5 pour le corps de texte et 1,1 à 1,25 pour les titres,
    graisses limitées à trois niveaux.
11. **Couleur** : construire par jetons sémantiques (surface, texte, bordure, accent,
    succès, alerte, erreur) et non par valeurs brutes dispersées.
    Vérifier les contrastes : 4,5:1 pour le texte courant, 3:1 pour le grand texte
    et les éléments d'interface.
12. **Dark mode** : définir la palette claire par défaut, puis redéfinir uniquement
    les jetons en mode sombre. Ne jamais inverser mécaniquement : le noir pur et le
    blanc pur fatiguent ; utiliser des gris très foncés et légèrement colorés.
13. **Éviter le rendu générique** : un site reconnaissable a un parti pris.
    Signaux d'interface générée sans intention : dégradé violet-bleu par défaut,
    trois cartes identiques avec icônes génériques, section de témoignages inventés,
    espacement uniforme sans hiérarchie, arrondis identiques partout, absence de
    contenu réel. Chercher un élément distinctif : typographie assumée, mise en page
    asymétrique, illustration propre, traitement photographique cohérent.

### Phase 4 — Implémentation
14. **Choix technique** : HTML/CSS pour un site statique simple ;
    React ou Next.js quand il y a de l'état, des données dynamiques ou du rendu serveur ;
    TypeScript dès que le projet dépasse quelques composants ;
    Tailwind quand la cohérence par jetons et la vitesse d'itération priment.
    Justifier le choix par une contrainte, pas par une préférence.
15. **Responsive** : concevoir mobile d'abord. Points de rupture dictés par le contenu,
    pas par des tailles d'appareils. Vérifier 360, 768, 1024 et 1440 px.
    Zones tactiles de 44 px minimum. Aucun défilement horizontal.
16. **Animations** : uniquement si elles communiquent quelque chose (changement d'état,
    continuité spatiale, retour d'action). Durées 150 à 300 ms.
    Respecter `prefers-reduced-motion`. Une animation décorative qui retarde la
    lecture est un défaut, pas une qualité.
17. **Accessibilité** : HTML sémantique, un seul H1, hiérarchie de titres continue,
    navigation complète au clavier, focus visible, libellés de formulaires associés,
    messages d'erreur explicites, texte alternatif pertinent, ARIA uniquement quand
    le HTML natif ne suffit pas, contrastes vérifiés.
18. **SEO technique** : title et meta description uniques par page, URL propres,
    données structurées, balises Open Graph, sitemap, rendu du contenu sans JavaScript
    lorsque c'est possible, hreflang si multilingue.
19. **Performance et Core Web Vitals** :
    - LCP : optimiser l'image ou le texte principal, précharger la ressource critique,
      éviter d'en bloquer le rendu.
    - INP : limiter le JavaScript exécuté au chargement, découper les tâches longues.
    - CLS : dimensions explicites sur images et vidéos, espace réservé pour les
      contenus injectés, polices avec `font-display: swap` et repli métriquement proche.
    - Images en AVIF ou WebP, dimensionnées, chargement différé hors du premier écran.

### Phase 5 — Vérification
20. **Vérification visuelle en navigateur réel** : lorsqu'un outil navigateur est
    disponible (Playwright, Chrome DevTools MCP), ouvrir la page et inspecter
    réellement le rendu. Ne jamais déclarer une interface correcte sans l'avoir vue.
    Tester au minimum une vue desktop (1440 px) et une vue mobile (390 px).
    Vérifier aussi le mode sombre si implémenté, les états de survol et de focus,
    et les erreurs dans la console.
21. **Correction et itération** jusqu'à ce que les contrôles qualité passent.

Références détaillées : `references/checklist-technique.md` et `references/typologies.md`.

## Contrôles qualité
- [ ] Le cadrage en 7 points a été fait avant toute implémentation.
- [ ] La conversion principale est visuellement dominante sur chaque page.
- [ ] L'espacement suit une échelle cohérente, pas des valeurs arbitraires.
- [ ] Les contrastes atteignent 4,5:1 (texte) et 3:1 (grand texte et interface).
- [ ] Navigation complète au clavier avec focus visible.
- [ ] Aucun défilement horizontal à 360 px ; zones tactiles ≥ 44 px.
- [ ] Images dimensionnées et optimisées ; aucun décalage de mise en page au chargement.
- [ ] `prefers-reduced-motion` respecté.
- [ ] Le rendu a été inspecté dans un vrai navigateur, en desktop ET en mobile.
- [ ] Console sans erreur.
- [ ] Le résultat a un parti pris identifiable, pas un rendu générique interchangeable.

## Critères de fin
- Le site ou la page est implémenté, vérifié visuellement en desktop et mobile,
  accessible au clavier, sans erreur console et sans défilement horizontal.
- Les choix de conception sont documentés et les compromis signalés.

## Format de livrable
Cadrage · Architecture · Code implémenté · Jetons de design utilisés ·
Captures ou compte rendu de vérification desktop et mobile · Liste de contrôle
accessibilité et performance · Points restants.

# Liste de contrôle technique — web-design-pro

Référence chargée à la demande. Ne pas recopier dans SKILL.md.

## Avant livraison

### Responsive
- [ ] 360 px : aucun défilement horizontal, aucun texte tronqué.
- [ ] 768 px : la mise en page se recompose sans chevauchement.
- [ ] 1024 px et 1440 px : la largeur de contenu reste maîtrisée, pas de ligne trop longue.
- [ ] Points de rupture définis par le contenu, pas par des noms d'appareils.
- [ ] Images fluides (`max-width: 100%`), pas de largeur fixe supérieure à l'écran.
- [ ] Tableaux, blocs de code et diagrammes dans un conteneur `overflow-x: auto`.
- [ ] Cibles tactiles ≥ 44 × 44 px, espacées d'au moins 8 px.

### Accessibilité
- [ ] Un seul `<h1>` par page, hiérarchie de titres sans saut de niveau.
- [ ] Éléments interactifs natifs (`<button>`, `<a>`) plutôt que `<div>` cliquables.
- [ ] Parcours clavier complet : Tab, Maj+Tab, Entrée, Espace, Échap.
- [ ] Focus visible sur tous les éléments interactifs, y compris en mode sombre.
- [ ] Ordre de tabulation conforme à l'ordre visuel.
- [ ] Libellés `<label>` associés à chaque champ via `for` / `id`.
- [ ] Messages d'erreur liés au champ (`aria-describedby`) et explicites.
- [ ] Texte alternatif utile ; `alt=""` pour les images purement décoratives.
- [ ] Contraste ≥ 4,5:1 pour le texte courant, ≥ 3:1 pour le grand texte et l'interface.
- [ ] Aucune information portée par la seule couleur.
- [ ] `prefers-reduced-motion` respecté.
- [ ] Lien d'évitement vers le contenu principal si la navigation est longue.
- [ ] `lang` correct sur `<html>`.

### Performance et Core Web Vitals
- [ ] LCP : élément principal identifié, préchargé si image, non bloqué par un script.
- [ ] Images en AVIF ou WebP, dimensionnées à l'usage réel, `srcset` si nécessaire.
- [ ] `loading="lazy"` hors du premier écran ; jamais sur l'image LCP.
- [ ] `width` et `height` explicites sur images et vidéos (évite le CLS).
- [ ] Espace réservé pour tout contenu injecté après chargement.
- [ ] Polices : `font-display: swap`, préchargement de la police critique,
      repli métriquement proche pour limiter le décalage.
- [ ] JavaScript non critique différé ; pas de script bloquant dans `<head>`.
- [ ] CSS critique en ligne si le premier rendu est lent.
- [ ] Aucune dépendance lourde chargée pour un usage marginal.

### SEO technique
- [ ] `<title>` unique et porteur du terme cible, ≤ 60 caractères environ.
- [ ] `<meta name="description">` unique, orientée clic.
- [ ] URL courte, lisible, stable.
- [ ] Balise canonique si contenu accessible par plusieurs URL.
- [ ] Open Graph et Twitter Card pour le partage.
- [ ] Données structurées schema.org adaptées au type de page.
- [ ] Contenu principal présent sans exécution de JavaScript quand c'est possible.
- [ ] `sitemap.xml` et `robots.txt` cohérents.
- [ ] `hreflang` si plusieurs langues.

### États et robustesse
- [ ] État de chargement défini pour chaque zone asynchrone.
- [ ] État vide conçu (pas une page blanche) avec une action proposée.
- [ ] État d'erreur explicite, avec le moyen de corriger.
- [ ] État de succès visible après une action.
- [ ] Comportement en connexion lente vérifié.

### Mode sombre
- [ ] Palette claire définie sur `:root`, jetons redéfinis en mode sombre.
- [ ] Pas de noir pur ni de blanc pur : gris très foncés légèrement colorés.
- [ ] Contrastes revérifiés en mode sombre (ils ne se transposent pas automatiquement).
- [ ] Images et illustrations restent lisibles sur fond sombre.
- [ ] `color-scheme` déclaré.

### Vérification navigateur réelle
- [ ] Page ouverte dans un vrai navigateur (Playwright ou Chrome DevTools MCP).
- [ ] Capture desktop 1440 px.
- [ ] Capture mobile 390 px.
- [ ] Capture en mode sombre si le thème est implémenté.
- [ ] Console sans erreur ni avertissement bloquant.
- [ ] Survol et focus vérifiés sur les éléments interactifs.
- [ ] Formulaires soumis au moins une fois, cas d'erreur inclus.

### Pièges de la vérification par capture d'écran
Une capture n'est pas une preuve brute : elle peut mentir. Avant de « corriger »
un défaut vu sur une image, vérifiez qu'il existe dans le DOM.

- [ ] **`backdrop-filter` + capture pleine page** : un en-tête collant flouté
      produit du **texte fantôme** dupliqué à des endroits arbitraires de la
      capture `fullPage`. C'est un artefact de rendu, pas un défaut de la page.
      Recoupez toujours avec une capture **viewport seule** avant d'agir.
- [ ] **`position: sticky` en capture pleine page** : l'élément peut apparaître
      dupliqué ou mal positionné. Même remède.
- [ ] **Polices web** : une capture prise avant le chargement des polices montre
      le repli. Attendre `networkidle` ou `document.fonts.ready`.
- [ ] **Animations d'entrée** : une capture immédiate fige des éléments en état
      initial (opacité 0, décalage). Attendre la fin, ou désactiver via
      `prefers-reduced-motion`.
- [ ] Règle générale : un défaut visible sur une capture doit être **confirmé dans
      le DOM** (position réelle, styles calculés) avant toute modification de code.

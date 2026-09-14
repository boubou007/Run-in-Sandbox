# Vérification visuelle en navigateur réel

La Skill `web-design-pro` impose de ne jamais déclarer une interface correcte
sans l'avoir réellement vue. Ce paquet fournit l'outil qui automatise ce contrôle.

## L'outil

`tools/verify-page.mjs` ouvre une page dans un vrai Chromium et vérifie :

| Contrôle | Gravité |
|---|---|
| Chargement HTTP | FAIL si erreur |
| Captures desktop 1440 px (pleine page + viewport) | — |
| Captures mobile 390 px (pleine page + viewport) | — |
| Capture en mode sombre + fond de `body` explicite | WARN si transparent |
| Défilement horizontal desktop et mobile | FAIL |
| Attribut `lang` sur `<html>` | FAIL si absent |
| `<title>` présent | FAIL si absent |
| Meta description | WARN si absente |
| Un seul `<h1>` | FAIL sinon |
| Hiérarchie de titres sans saut de niveau | FAIL |
| Images sans `alt` | FAIL |
| Images sans `width`/`height` (risque de CLS) | WARN |
| Champs de formulaire sans libellé associé | FAIL |
| Cibles tactiles < 44 px | WARN |
| Erreurs de console et exceptions JavaScript | FAIL |
| Présence de `backdrop-filter` (piège de capture) | WARN |

## Prérequis

```powershell
npm install -g playwright
npx playwright install chromium
```

## Usage

```powershell
# servir la page localement
npx http-server . -p 8099

# dans un autre terminal
node tools\verify-page.mjs http://localhost:8099/ma-page.html .\verification
```

Code de sortie `1` si un contrôle bloquant échoue — utilisable en intégration continue.

## Ce que l'outil ne remplace pas

L'automatisation détecte les manquements mesurables. Elle ne juge pas la
hiérarchie visuelle, le rythme vertical, la cohérence typographique ni le
caractère générique d'une interface. **Regardez les captures.**

Exemple vécu pendant la préparation de ce paquet : tous les contrôles automatiques
passaient, mais l'examen des captures a révélé des espacements verticaux qui
s'additionnaient (padding de section + marge d'une bande adjacente), créant des
vides excessifs. Aucun contrôle programmatique ne l'aurait signalé.

## Piège important : les captures peuvent mentir

Un `backdrop-filter` sur un en-tête collant produit du **texte fantôme** dans les
captures `fullPage` : du contenu du pied de page peut apparaître en haut de l'image.

Ce n'est **pas** un défaut de la page. Vérifié en comparant avec une capture
viewport seule (propre) et en contrôlant la position réelle des éléments dans le
DOM (`getBoundingClientRect`) — les éléments étaient à leur place.

**Règle** : avant de corriger un défaut vu sur une capture, confirmez-le dans le
DOM. Corriger un artefact de rendu, c'est casser du code qui fonctionne.

C'est pourquoi l'outil produit systématiquement les deux types de capture et
signale la présence de `backdrop-filter`.

## Exemple de référence

`examples/landing-demo.html` est une landing page SaaS construite selon
`web-design-pro` : jetons sémantiques, mode sombre par redéfinition de jetons,
échelle d'espacement, mobile d'abord, navigation clavier, aucune dépendance externe.

Elle passe la vérification avec 16 PASS, 0 FAIL.

---
name: qa-debugging
description: Diagnostic et correction de bugs par la méthode : reproduction fiable, isolation, identification de la cause racine, correction minimale, test de non-régression et prévention. Utiliser quand quelque chose ne fonctionne pas, plante, produit un résultat inattendu, régresse, ou quand l'utilisateur demande de corriger, déboguer ou tester.
---

# Qualité et débogage

## Quand utiliser cette Skill
- Un comportement observé diffère du comportement attendu.
- Une régression est apparue après une modification.
- Un test échoue ou échoue par intermittence.

## Quand ne PAS l'utiliser
- Aucune anomalie : il s'agit d'ajouter une fonctionnalité → product-manager, app-architect.
- Problème d'interface visuelle uniquement → ui-ux-audit.

## Procédure
1. **Reproduire** : établir les étapes exactes, l'environnement, les données et
   la fréquence. Un bug non reproductible ne doit pas être « corrigé » à l'aveugle :
   une correction sans reproduction ne peut pas être validée.
2. **Constater les faits** : message d'erreur complet, pile d'appel, journaux,
   version, dernière modification connue. Ne pas résumer l'erreur : la lire entièrement.
3. **Formuler des hypothèses** classées par probabilité, et les tester une par une.
   Ne changer qu'une variable à la fois.
4. **Isoler** : réduire le cas au plus petit exemple qui reproduit encore le problème.
   Bissection dans l'historique si une régression est suspectée.
5. **Identifier la cause racine** : remonter jusqu'à la raison réelle.
   Corriger un symptôme visible sans comprendre la cause déplace le bug au lieu de le supprimer.
6. **Corriger au minimum** : la modification la plus petite qui traite la cause.
   Ne pas refactoriser en même temps qu'on corrige : les deux changements se masquent.
7. **Tester** : vérifier le cas d'origine, les cas limites, puis chercher activement
   les régressions sur les fonctionnalités connexes. Exécuter la suite de tests existante.
8. **Ajouter un test** qui échoue avant la correction et réussit après.
   C'est la seule garantie contre la réapparition.
9. **Documenter** : symptôme, cause racine, correction, moyen de prévention.
10. **Prévenir** : ce même défaut peut-il exister ailleurs dans le code ? Vérifier.

## Contrôles qualité
- [ ] Le bug a été reproduit avant d'être corrigé.
- [ ] La cause racine est identifiée et expliquée, pas seulement le symptôme.
- [ ] La correction est minimale et ne mélange pas refactorisation et correction.
- [ ] Un test couvre désormais le cas et échouait avant la correction.
- [ ] Les régressions possibles ont été recherchées activement.
- [ ] Aucune fonctionnalité existante n'a été supprimée pour faire passer un test.

## Critères de fin
- Le comportement attendu est rétabli et vérifié par exécution réelle.
- Un test de non-régression existe et la cause racine est documentée.

## Format de livrable
Rapport : Symptôme · Étapes de reproduction · Cause racine · Correction appliquée ·
Tests exécutés et résultats · Risques de régression · Prévention.

---
name: research-verification
description: Recherche multi-sources avec vérification factuelle : croiser au moins trois sources, dater chaque information, détecter les contradictions, privilégier les sources officielles et distinguer faits, hypothèses et recommandations. Utiliser dès qu'une affirmation doit être prouvée, qu'une donnée peut avoir changé (version, prix, API, réglementation, chiffres de marché) ou que l'utilisateur demande de vérifier, sourcer ou fact-checker.
---

# Recherche et vérification multi-sources

## Quand utiliser cette Skill
- Une affirmation doit être prouvée avant d'être utilisée dans une décision.
- L'information est périssable : versions logicielles, prix, API, lois, chiffres de marché.
- L'utilisateur demande explicitement de vérifier, sourcer ou recouper.
- Une autre Skill (market-intelligence, trend-radar, decision-gate) a besoin de preuves.

## Quand ne PAS l'utiliser
- Connaissance stable et non controversée (syntaxe d'un langage, notion mathématique).
- L'utilisateur veut un brouillon créatif, pas une analyse factuelle.

## Procédure
1. **Décomposer** la question en affirmations vérifiables, une par une.
2. **Hiérarchiser les sources** : documentation officielle / site de l'éditeur > registre
   public ou institution > étude primaire > presse spécialisée > agrégateur > blog > forum.
3. **Croiser** : minimum 3 sources indépendantes par affirmation critique.
   Deux sources qui citent la même source primaire comptent pour une seule.
4. **Dater** chaque information : date de publication ET date de dernière mise à jour.
   Une donnée sans date est traitée comme non vérifiée.
5. **Traiter les contradictions** : ne pas trancher au vote. Identifier la source la plus
   proche de l'origine, la plus récente, et exposer le désaccord s'il subsiste.
6. **Classer** chaque élément : FAIT (sourcé et daté) / HYPOTHÈSE (plausible, non prouvé) /
   INCONNU (donnée manquante).
7. **Restituer** avec les sources en lien cliquable.

## Contrôles qualité
- [ ] Chaque FAIT porte une source et une date.
- [ ] Aucune donnée manquante n'a été comblée par une estimation présentée comme un fait.
- [ ] Les contradictions entre sources sont signalées, pas lissées.
- [ ] Les sources primaires sont privilégiées sur les reprises.
- [ ] Le niveau de confiance global est annoncé (élevé / moyen / faible).

## Critères de fin
- Toutes les affirmations critiques sont classées FAIT, HYPOTHÈSE ou INCONNU.
- Les INCONNU sont listés explicitement avec ce qu'il faudrait pour les lever.

## Format de livrable
Trois sections : **Faits vérifiés** (avec sources datées), **Hypothèses**
(avec le niveau de confiance), **Inconnus / à vérifier**. Puis la liste des sources.

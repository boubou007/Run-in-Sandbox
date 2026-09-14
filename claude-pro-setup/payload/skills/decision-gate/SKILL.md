---
name: decision-gate
description: Rendre un verdict de décision business structuré GO, WAIT ou NO à partir des preuves, de la concurrence, du risque, du coût, du potentiel et du délai de retour. Utiliser quand l'utilisateur doit décider de se lancer, d'investir, d'arrêter, de choisir entre plusieurs options, ou demande explicitement un GO/WAIT/NO.
---

# Porte de décision GO / WAIT / NO

## Quand utiliser cette Skill
- Une décision d'engagement (temps, argent, arrêt) est à prendre.
- Plusieurs options doivent être départagées.
- L'utilisateur demande un verdict, pas une exploration.

## Quand ne PAS l'utiliser
- Les données de base manquent encore → market-intelligence ou research-verification d'abord.
- La question est technique, pas business → app-architect ou qa-debugging.

## Procédure
1. **Formuler la décision** en une phrase testable, avec l'engagement exact
   (montant, durée, périmètre). Une décision floue ne peut pas être tranchée.
2. **Établir les critères** avant de regarder les données, pour éviter de justifier
   une conclusion déjà choisie. Noter chaque critère de 0 à 10 :
   - Preuve de demande
   - Intensité concurrentielle (inversée : moins il y a de saturation, plus la note est haute)
   - Avantage différenciant défendable
   - Coût d'entrée et trésorerie exposée
   - Délai avant premier revenu
   - Potentiel de marge
   - Risque (réglementaire, plateforme, dépendance, réputation)
   - Adéquation avec les compétences et le temps disponibles
3. **Identifier les inconnues bloquantes** : une inconnue qui peut à elle seule
   invalider la décision impose WAIT, quelle que soit la note globale.
4. **Appliquer la règle de verdict** :
   - **GO** : demande prouvée, différenciation identifiée, coût soutenable en cas d'échec,
     aucune inconnue bloquante.
   - **WAIT** : le potentiel existe mais une inconnue bloquante subsiste. Préciser
     le test exact, son coût et son délai pour la lever.
   - **NO** : demande non prouvée, ou saturation sans avantage, ou risque supérieur
     au gain potentiel, ou inadéquation avec les ressources réelles.
5. **Définir les conditions de révision** : quel fait ferait changer le verdict.

## Contrôles qualité
- [ ] Critères posés avant l'analyse des données.
- [ ] Chaque note est justifiée par une preuve, pas par une impression.
- [ ] Les inconnues bloquantes sont listées.
- [ ] Un WAIT précise toujours le test à mener, son coût et son délai.
- [ ] Le scénario d'échec et sa perte maximale sont chiffrés.

## Critères de fin
- Un verdict unique GO, WAIT ou NO est rendu, sans ambiguïté.
- Les 3 prochaines actions concrètes sont listées.
- Les conditions de révision du verdict sont écrites.

## Format de livrable
**VERDICT : GO / WAIT / NO** · Tableau des critères notés · Inconnues bloquantes ·
Perte maximale · 3 actions immédiates · Conditions de révision.

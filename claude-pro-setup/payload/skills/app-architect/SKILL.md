---
name: app-architect
description: Concevoir l'architecture d'une application : choix frontend et backend, conception d'API, modèle de données, authentification et autorisation, sécurité, performance, stockage, tâches asynchrones, déploiement, observabilité et coûts. Utiliser quand l'utilisateur veut concevoir une application, choisir une stack, structurer une base de données, concevoir une API ou planifier un déploiement.
---

# Architecture applicative

## Quand utiliser cette Skill
- Démarrer une application et fixer les choix structurants.
- Réviser une architecture qui ne tient plus la charge ou la complexité.
- Concevoir un schéma de données ou une API.

## Quand ne PAS l'utiliser
- Déboguer un problème précis → qa-debugging.
- Spécifier le besoin fonctionnel → product-manager.
- Interface et design → web-design-pro.

## Procédure
1. **Contraintes d'abord** : volume d'utilisateurs attendu, budget, compétences de
   l'équipe, délai, exigences réglementaires, besoins hors ligne, temps réel.
   L'architecture découle des contraintes, jamais des modes.
2. **Choisir la stack** en justifiant chaque choix par une contrainte.
   Préférer les technologies matures et documentées, que l'équipe sait maintenir.
   Une stack que personne ne peut déboguer est un risque, pas un atout.
3. **Modèle de données** : entités, relations, cardinalités, index, contraintes
   d'intégrité, stratégie de migration. Choisir relationnel par défaut ;
   justifier explicitement tout autre choix.
4. **API** : style (REST ou GraphQL), conventions de nommage, versionnage,
   pagination, filtrage, codes d'erreur normalisés, limitation de débit, idempotence
   des opérations d'écriture.
5. **Authentification et autorisation** : distinguer les deux. Sessions ou jetons,
   durée de vie et renouvellement, stockage côté client, modèle de rôles et permissions,
   vérification systématique côté serveur.
6. **Sécurité** : validation des entrées côté serveur, requêtes paramétrées,
   échappement des sorties, protection CSRF, en-têtes de sécurité, chiffrement en
   transit et au repos, gestion des secrets hors du dépôt, journalisation sans données
   sensibles, principe du moindre privilège, dépendances à jour.
7. **Performance** : stratégie de cache par niveau, pagination, requêtes N+1,
   index manquants, traitements lourds en tâches de fond, fichiers statiques via CDN.
8. **Asynchrone** : file de tâches, idempotence, reprise sur erreur, file d'échec.
9. **Déploiement** : environnements, intégration continue, migrations de base,
   stratégie de retour arrière, sauvegardes et test de restauration.
   Une sauvegarde jamais restaurée n'est pas une sauvegarde.
10. **Observabilité** : journaux structurés, métriques, alertes, traçage.
11. **Coûts** : estimer le coût d'exploitation à l'échelle visée.

## Contrôles qualité
- [ ] Chaque choix technique est justifié par une contrainte explicite.
- [ ] Le modèle de données supporte les cas d'usage principaux sans contorsion.
- [ ] L'autorisation est vérifiée côté serveur pour chaque ressource.
- [ ] Aucun secret n'est stocké dans le dépôt ou le code client.
- [ ] La stratégie de sauvegarde et de retour arrière est définie et testable.
- [ ] Les points de défaillance unique sont identifiés.

## Critères de fin
- Stack, données, API, sécurité, déploiement et observabilité sont documentés.
- Les compromis acceptés et leurs conséquences sont écrits.

## Format de livrable
Document d'architecture : Contraintes · Stack justifiée · Schéma de données ·
Contrat d'API · Sécurité · Performance · Déploiement · Observabilité · Coûts ·
Compromis acceptés · Risques.

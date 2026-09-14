# Modèles de mémoire projet

À copier dans `<projet>/.claude/memory/` au démarrage d'un projet.
Gérés par la Skill `memory-manager`.

---

## `etat.md`

```markdown
# État du projet — <nom>

Dernière mise à jour : AAAA-MM-JJ

## Objectif
<ce que le projet doit accomplir, en 2 phrases>

## État actuel
<où on en est aujourd'hui>

## Travail terminé
- [x] ...

## Travail restant
- [ ] ...

## Prochaine action
<une action précise, exécutable telle quelle sans réflexion préalable>

## Pièges connus
- ...
```

---

## `decisions.md`

```markdown
# Journal des décisions — <nom>

## AAAA-MM-JJ — <titre de la décision>
- **Décision** : <ce qui a été décidé>
- **Raison** : <pourquoi>
- **Alternatives écartées** : <et pourquoi elles ont été écartées>
- **Remise en cause si** : <le fait qui obligerait à rouvrir la décision>
- **Statut** : active | remplacée par <décision du AAAA-MM-JJ>
```

Une décision remplacée n'est jamais supprimée : elle est marquée comme remplacée.

---

## `architecture.md`

```markdown
# Architecture — <nom>

## Structure
<arborescence et rôle de chaque partie>

## Stack
| Couche | Technologie | Raison du choix |
|---|---|---|

## Modèle de données
<entités et relations principales>

## Dépendances clés
<et ce qui casserait si elles changeaient>

## Compromis acceptés
<ce qui a été sacrifié et pourquoi>
```

---

## `erreurs.md`

```markdown
# Erreurs rencontrées et solutions validées — <nom>

## AAAA-MM-JJ — <symptôme court>
- **Symptôme** : <ce qui était observé>
- **Cause racine** : <la vraie cause, pas le symptôme>
- **Solution validée** : <ce qui a corrigé le problème>
- **Prévention** : <comment éviter que cela se reproduise>
```

À consulter avant tout débogage : le problème a peut-être déjà été résolu.

---

## Règles

- Ne jamais écrire de secret, mot de passe, jeton ou clé privée dans ces fichiers.
- Relire la section concernée avant d'écrire, pour éviter les doublons.
- `etat.md` se met à jour en fin de chaque session de travail significative.
- Si ces fichiers contiennent des informations sensibles, les exclure du dépôt
  via `.gitignore`.

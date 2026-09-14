# Modèle de CLAUDE.md projet

À copier à la racine d'un projet sous le nom `CLAUDE.md`, puis à adapter.
Ce fichier est versionné avec le code : il décrit le projet, pas les préférences
personnelles (celles-ci vivent dans `~/.claude/CLAUDE.md`).

Garder ce fichier court : il est chargé en permanence dans le contexte.

```markdown
# <Nom du projet>

## Objet
<ce que fait le projet, en 2 phrases>

## Stack
<langages, frameworks, base de données, hébergement>

## Structure
- `src/` — ...
- `tests/` — ...
- `docs/` — ...

## Commandes
| Action | Commande |
|---|---|
| Installer | `...` |
| Lancer en développement | `...` |
| Tester | `...` |
| Linter | `...` |
| Construire | `...` |

## Conventions
- <style de nommage>
- <organisation des fichiers>
- <convention de commit>
- <règles de branches>

## Contraintes
- <navigateurs supportés, versions minimales, exigences de performance,
  contraintes réglementaires>

## Pièges connus
- <ce qui casse facilement et pourquoi>

## À ne pas faire
- <modifications interdites, fichiers générés à ne pas éditer à la main>

## Mémoire
État et décisions du projet : `.claude/memory/` (voir la Skill `memory-manager`).
```

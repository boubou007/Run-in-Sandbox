# Test de déclenchement des Skills

Une Skill n'a de valeur que si elle se déclenche au bon moment. Une description
trop vague ne se déclenche jamais ; deux descriptions qui se recouvrent font
déclencher la mauvaise. Ce fichier mesure cela.

## Comment l'exécuter

Collez le bloc ci-dessous dans Claude Code, ou passez-le à `claude -p`.
Comparez ensuite les réponses au tableau de résultats attendus.

> Pour chacun des cas ci-dessous, indique UNIQUEMENT le nom de la Skill que tu
> invoquerais, au format `1. nom-de-skill`. Une seule par cas. Si aucune ne
> convient, écris `aucune`. N'exécute aucune tâche, ne justifie pas.

## Les 27 cas

**Série A — cas directs**
1. Ma page de vente reçoit du trafic mais personne n'achète.
2. Je veux créer un site vitrine pour mon activité de plombier.
3. Mon test unitaire passait hier, il échoue aujourd'hui.
4. Est-ce que je devrais me lancer sur le marché des coques de téléphone ?
5. Je veux être trouvé sur Google pour « formation yoga en ligne ».
6. La session devient lente et je m'inquiète du coût.
7. Je reprends un projet abandonné il y a trois semaines, où j'en étais ?
8. Je veux vendre des plannings imprimables sur Etsy.
9. Aide-moi à écrire une instruction système fiable pour un agent.
10. J'ai besoin de spécifier les fonctionnalités de mon appli avant de coder.

**Série B — cas volontairement ambigus**
11. Je veux uniformiser les boutons et les couleurs dans toute mon application.
12. Mon dashboard existant est confus, dis-moi ce qui cloche.
13. Analyse les trois entreprises qui vendent la même chose que moi.
14. Cette information sur la réglementation date de 2024, est-elle encore valable ?
15. Je veux que mes factures partent automatiquement chaque mois.
16. Comment structurer les tables de ma base pour une appli de réservation ?
17. Écris-moi le texte d'une publicité Facebook pour ma formation.
18. Ce projet touche au marché, au design et au code, par où je commence ?
19. Vérifie mon livrable avant que je l'envoie au client.
20. Quelles tendances émergent dans le fitness à domicile ?

**Série C — couverture du reste**
21. J'ai une idée de service pour les kinés, comment j'en fais une offre vendable ?
22. Je ne sais pas par quels canaux acquérir mes premiers clients ni avec quel budget.
23. Je cherche un produit physique à vendre, avec une marge correcte après tous les frais.
24. Je veux lancer des t-shirts pour une niche de passionnés.
25. Je dois tenir un calendrier de publication sur TikTok et Instagram.
26. Je veux améliorer le taux de clic de mes miniatures et la rétention de mes vidéos.
27. Note les décisions qu'on vient de prendre pour que je les retrouve demain.

## Résultats attendus

| # | Skill attendue | Discrimination testée |
|---|---|---|
| 1 | `landing-page-conversion` | vs copywriting-pro, ui-ux-audit |
| 2 | `web-design-pro` | **vs le plugin `frontend-design`** |
| 3 | `qa-debugging` | vs app-architect |
| 4 | `decision-gate` | vs market-intelligence |
| 5 | `seo-expert` | vs marketing-strategist |
| 6 | `context-token-manager` | — |
| 7 | `reprise` (commande) | vs memory-manager |
| 8 | `etsy-digital-products` | vs ecommerce-research |
| 9 | `prompt-engineer` | vs app-architect |
| 10 | `product-manager` | vs app-architect |
| 11 | `design-system` | vs web-design-pro |
| 12 | `ui-ux-audit` | vs web-design-pro, design-system |
| 13 | `competitive-intelligence` | vs market-intelligence |
| 14 | `research-verification` | — |
| 15 | `automation-architect` | vs app-architect |
| 16 | `app-architect` | vs product-manager |
| 17 | `copywriting-pro` | vs social-media-strategist, marketing-strategist |
| 18 | `project-orchestrator` | vs les Skills de domaine |
| 19 | `quality-controller` | vs qa-debugging |
| 20 | `trend-radar` | vs market-intelligence |
| 21 | `business-builder` | vs decision-gate |
| 22 | `marketing-strategist` | vs business-builder |
| 23 | `ecommerce-research` | vs pod-strategist |
| 24 | `pod-strategist` | vs ecommerce-research |
| 25 | `social-media-strategist` | vs marketing-strategist |
| 26 | `youtube-strategist` | vs social-media-strategist |
| 27 | `sauvegarde-memoire` (commande) | vs memory-manager |

## Dernier résultat mesuré

**27 / 27 correct**, sur Claude Code 2.1.270, avec les 4 plugins officiels installés
(`frontend-design`, `feature-dev`, `code-review`, `plugin-dev`) — donc en présence
de Skills concurrentes, pas en vase clos.

## Quand relancer ce test

- Après avoir modifié la `description` d'une Skill.
- Après en avoir ajouté une nouvelle : vérifiez qu'elle ne capte pas les cas d'une autre.
- Après l'installation d'un plugin qui apporte ses propres Skills.

Une réponse qui dérive signale une description à resserrer, pas un cas de test à changer.

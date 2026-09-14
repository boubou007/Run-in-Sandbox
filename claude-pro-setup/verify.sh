#!/usr/bin/env bash
# Audit post-installation de la configuration Claude Code.
# Statuts : PASS / WARNING / FAIL. Aucun element n'est declare OK sans controle reel.
set -uo pipefail

CLAUDE_HOME="$HOME/.claude"
PASS=0; WARN=0; FAIL=0
ROWS=()

row() { # statut | element | detail
  ROWS+=("$1|$2|$3")
  case "$1" in
    PASS) PASS=$((PASS+1)) ;;
    WARNING) WARN=$((WARN+1)) ;;
    FAIL) FAIL=$((FAIL+1)) ;;
  esac
}

printf '\n  AUDIT DE LA CONFIGURATION CLAUDE CODE\n'
printf '  Cible : %s\n\n' "$CLAUDE_HOME"

# --- Claude Code
if command -v claude >/dev/null 2>&1; then
  V=$(claude --version 2>&1 | head -1)
  row PASS "Claude Code" "$V"
else
  row FAIL "Claude Code" "commande 'claude' introuvable dans le PATH"
fi

# --- CLAUDE.md
if [ -f "$CLAUDE_HOME/CLAUDE.md" ]; then
  L=$(wc -l < "$CLAUDE_HOME/CLAUDE.md" | tr -d ' ')
  if [ "$L" -gt 150 ]; then
    row WARNING "CLAUDE.md" "$L lignes - trop long, deplacer les procedures dans des Skills"
  else
    row PASS "CLAUDE.md" "present, $L lignes"
  fi
else
  row FAIL "CLAUDE.md" "absent"
fi
[ -f "$CLAUDE_HOME/CLAUDE.md.nouveau" ] && row WARNING "CLAUDE.md.nouveau" "fusion manuelle en attente"

# --- settings.json
if [ -f "$CLAUDE_HOME/settings.json" ]; then
  if python3 -m json.tool "$CLAUDE_HOME/settings.json" >/dev/null 2>&1; then
    row PASS "settings.json" "JSON valide"
  else
    row FAIL "settings.json" "JSON INVALIDE"
  fi
else
  row WARNING "settings.json" "absent"
fi

# --- structure
MISSING=""
for d in skills agents rules backups logs templates; do
  [ -d "$CLAUDE_HOME/$d" ] || MISSING="$MISSING $d"
done
if [ -z "$MISSING" ]; then row PASS "Structure .claude" "skills, agents, rules, backups, logs, templates"
else row WARNING "Structure .claude" "manquant :$MISSING"; fi

# --- skills
SC=0
[ -d "$CLAUDE_HOME/skills" ] && SC=$(find "$CLAUDE_HOME/skills" -mindepth 2 -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$SC" -ge 27 ]; then row PASS "Skills" "$SC Skills avec SKILL.md"
elif [ "$SC" -gt 0 ]; then row WARNING "Skills" "$SC Skills (27 attendues)"
else row FAIL "Skills" "aucune Skill detectee"; fi

# frontmatter
BAD=0
if [ -d "$CLAUDE_HOME/skills" ]; then
  while IFS= read -r f; do
    head -1 "$f" | grep -q '^---$' || BAD=$((BAD+1))
    grep -q '^name:' "$f" || BAD=$((BAD+1))
    grep -q '^description:' "$f" || BAD=$((BAD+1))
  done < <(find "$CLAUDE_HOME/skills" -mindepth 2 -maxdepth 2 -name SKILL.md 2>/dev/null)
fi
if [ "$BAD" -eq 0 ]; then row PASS "Frontmatter Skills" "name + description presents partout"
else row FAIL "Frontmatter Skills" "$BAD anomalie(s)"; fi

# --- agents
AC=0
[ -d "$CLAUDE_HOME/agents" ] && AC=$(find "$CLAUDE_HOME/agents" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "$AC" -ge 10 ]; then row PASS "Sous-agents" "$AC agents"
elif [ "$AC" -gt 0 ]; then row WARNING "Sous-agents" "$AC agents (10 attendus)"
else row FAIL "Sous-agents" "aucun agent detecte"; fi

# --- skills cles
for s in web-design-pro context-token-manager memory-manager quality-controller project-orchestrator; do
  if [ -f "$CLAUDE_HOME/skills/$s/SKILL.md" ]; then row PASS "Skill $s" "presente"
  else row FAIL "Skill $s" "absente"; fi
done

# --- references chargees a la demande
RC=$(find "$CLAUDE_HOME/skills" -path '*/references/*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "$RC" -gt 0 ]; then row PASS "References a la demande" "$RC fichier(s) hors contexte permanent"
else row WARNING "References a la demande" "aucune"; fi

# --- plugins
if command -v claude >/dev/null 2>&1; then
  P=$(CI=1 timeout 90 claude plugin list 2>&1 | head -20)
  if printf '%s' "$P" | grep -qi 'no plugins installed'; then
    row WARNING "Plugins" "aucun plugin installe (voir docs/PLUGINS.md)"
  else
    N=$(printf '%s' "$P" | grep -c . )
    row PASS "Plugins" "$N ligne(s) retournee(s) par 'claude plugin list'"
  fi
else
  row WARNING "Plugins" "non verifiable : CLI absente"
fi

# --- MCP
if command -v claude >/dev/null 2>&1; then
  M=$(CI=1 timeout 90 claude mcp list 2>&1 | head -20)
  if printf '%s' "$M" | grep -qi 'no mcp servers configured'; then
    row WARNING "MCP" "aucun serveur MCP configure (voir docs/MCP.md)"
  else
    row PASS "MCP" "$(printf '%s' "$M" | grep -c .) ligne(s) retournee(s)"
  fi
else
  row WARNING "MCP" "non verifiable : CLI absente"
fi

# --- memoire
if [ -f "$CLAUDE_HOME/templates/memoire-projet.md" ]; then
  row PASS "Modeles de memoire" "templates/memoire-projet.md present"
else
  row WARNING "Modeles de memoire" "absent"
fi

# --- secrets
LEAK=0
if [ -d "$CLAUDE_HOME/skills" ] || [ -d "$CLAUDE_HOME/agents" ]; then
  LEAK=$(grep -rlE '(sk-ant-[A-Za-z0-9]|ghp_[A-Za-z0-9]{20}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----)' \
         "$CLAUDE_HOME/skills" "$CLAUDE_HOME/agents" "$CLAUDE_HOME/rules" "$CLAUDE_HOME/templates" 2>/dev/null | wc -l | tr -d ' ')
fi
if [ "$LEAK" -eq 0 ]; then row PASS "Absence de secrets" "aucun secret detecte dans la configuration"
else row FAIL "Absence de secrets" "$LEAK fichier(s) suspect(s)"; fi

# --- sauvegardes
if [ -d "$CLAUDE_HOME/backups" ]; then
  B=$(find "$CLAUDE_HOME/backups" -maxdepth 1 -mindepth 1 -type d -name 'pro-setup-*' 2>/dev/null | wc -l | tr -d ' ')
  if [ "$B" -gt 0 ]; then
    LAST=$(find "$CLAUDE_HOME/backups" -maxdepth 1 -mindepth 1 -type d -name 'pro-setup-*' | sort | tail -1)
    row PASS "Sauvegarde" "$B sauvegarde(s), derniere : $LAST"
  else
    row WARNING "Sauvegarde" "aucune sauvegarde pro-setup (installation neuve ?)"
  fi
else
  row WARNING "Sauvegarde" "dossier backups absent"
fi

# --- tableau
printf '  %-8s | %-28s | %s\n' "STATUT" "ELEMENT" "DETAIL"
printf '  %-8s-+-%-28s-+-%s\n' "--------" "----------------------------" "------------------------------"
for r in "${ROWS[@]}"; do
  IFS='|' read -r s e d <<< "$r"
  printf '  %-8s | %-28s | %s\n' "$s" "$e" "$d"
done

printf '\n  PASS: %s   WARNING: %s   FAIL: %s\n\n' "$PASS" "$WARN" "$FAIL"
[ "$FAIL" -gt 0 ] && exit 1 || exit 0

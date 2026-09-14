#!/usr/bin/env bash
# Ajoute la marketplace officielle Anthropic et installe les plugins recommandes.
#   ./setup-plugins.sh              plugins recommandes
#   ./setup-plugins.sh --optional   + commit-commands, security-guidance, pr-review-toolkit
set -uo pipefail
export CI=1

OPTIONAL=0
[ "${1:-}" = "--optional" ] && OPTIONAL=1

command -v claude >/dev/null 2>&1 || { echo "  [FAIL] commande 'claude' introuvable"; exit 1; }

printf '\n  Installation des plugins Claude Code (marketplace officielle)\n'

printf '\n=== Marketplace officielle\n'
if claude plugin marketplace list 2>&1 | grep -q 'claude-code-plugins'; then
  echo "  [INFO] Marketplace deja configuree"
else
  if claude plugin marketplace add anthropics/claude-code >/dev/null 2>&1; then
    echo "  [OK]   Marketplace ajoutee"
  else
    echo "  [FAIL] Ajout de la marketplace echoue"; exit 1
  fi
fi

PLUGINS=(frontend-design feature-dev code-review plugin-dev)
[ "$OPTIONAL" = 1 ] && PLUGINS+=(commit-commands security-guidance pr-review-toolkit)

printf '\n=== Plugins\n'
INSTALLED=$(claude plugin list 2>&1)
DONE=0; SKIPPED=0; FAILED=()
for p in "${PLUGINS[@]}"; do
  if printf '%s' "$INSTALLED" | grep -q "$p@claude-code-plugins"; then
    echo "  [INFO] $p deja installe"; SKIPPED=$((SKIPPED+1)); continue
  fi
  if claude plugin install "$p@claude-code-plugins" >/dev/null 2>&1; then
    echo "  [OK]   $p installe"; DONE=$((DONE+1))
  else
    echo "  [FAIL] $p : echec"; FAILED+=("$p")
  fi
done

printf '\n=== Verification\n'
FINAL=$(claude plugin list 2>&1)
CONFIRMED=0
for p in "${PLUGINS[@]}"; do
  if printf '%s' "$FINAL" | grep -q "$p@claude-code-plugins"; then
    echo "   [OK]   $p"; CONFIRMED=$((CONFIRMED+1))
  else
    echo "   [FAIL] $p non confirme"
  fi
done

printf '\n  Confirmes : %s / %s   Installes : %s   Deja presents : %s   Echecs : %s\n' \
  "$CONFIRMED" "${#PLUGINS[@]}" "$DONE" "$SKIPPED" "${#FAILED[@]}"
printf '  Redemarrez Claude Code pour charger les plugins.\n\n'
[ "$CONFIRMED" -lt "${#PLUGINS[@]}" ] && exit 1 || exit 0

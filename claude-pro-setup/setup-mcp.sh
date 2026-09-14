#!/usr/bin/env bash
# Ajoute les serveurs MCP ne demandant AUCUNE authentification, puis teste la connexion.
# Les serveurs necessitant OAuth ou une cle (GitHub, Figma, Supabase, Context7)
# ne sont PAS ajoutes ici : voir docs/MCP.md, ils exigent votre intervention.
#
#   ./setup-mcp.sh                 playwright uniquement (recommande)
#   ./setup-mcp.sh --with-devtools + chrome-devtools
set -uo pipefail
export CI=1

WITH_DEVTOOLS=0
[ "${1:-}" = "--with-devtools" ] && WITH_DEVTOOLS=1

command -v claude >/dev/null 2>&1 || { echo "  [FAIL] commande 'claude' introuvable"; exit 1; }
command -v npx    >/dev/null 2>&1 || { echo "  [FAIL] npx introuvable : installez Node.js"; exit 1; }

printf '\n  Installation des serveurs MCP sans authentification\n'
printf '  Note : chaque MCP actif occupe du contexte en permanence.\n'

EXISTING=$(claude mcp list 2>&1)

add_mcp() {
  local name="$1"; shift
  if printf '%s' "$EXISTING" | grep -q "^$name:"; then
    echo "  [INFO] $name deja configure"
    return
  fi
  if claude mcp add "$name" -s user -- "$@" >/dev/null 2>&1; then
    echo "  [OK]   $name ajoute"
  else
    echo "  [FAIL] $name : echec de l'ajout"
  fi
}

printf '\n=== Ajout\n'
add_mcp playwright npx -y @playwright/mcp@latest
if [ "$WITH_DEVTOOLS" = 1 ]; then
  add_mcp chrome-devtools npx -y chrome-devtools-mcp@latest
else
  echo "  [INFO] chrome-devtools non ajoute (recouvre partiellement playwright)."
  echo "         Relancez avec --with-devtools si vous voulez l'analyse de performance."
fi

printf '\n=== Test de connexion reel\n'
OUT=$(claude mcp list 2>&1)
printf '%s\n' "$OUT" | grep -E '^(playwright|chrome-devtools):' | sed 's/^/  /'

if printf '%s' "$OUT" | grep -q 'playwright.*Connected'; then
  echo "  [OK]   playwright operationnel"
else
  echo "  [FAIL] playwright non connecte"
fi

printf '\n  Serveurs necessitant VOTRE intervention (non automatisables) :\n'
printf '   - GitHub   : OAuth ou jeton personnel\n'
printf '   - Figma    : OAuth dans le navigateur\n'
printf '   - Supabase : jeton d acces personnel\n'
printf '   - Context7 : cle API (authentification requise, verifie)\n'
printf '  Commandes exactes dans docs/MCP.md\n\n'

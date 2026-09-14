#!/usr/bin/env bash
# Installe la configuration Claude Code professionnelle dans ~/.claude
# Equivalent Linux/macOS de install.ps1.
#
#   ./install.sh              installation non destructive
#   ./install.sh --force      remplace les fichiers du paquet deja presents
#   ./install.sh --overwrite-claude-md   remplace un CLAUDE.md existant
#   ./install.sh --dry-run    simulation, aucune ecriture

set -uo pipefail

FORCE=0; OVERWRITE_MD=0; DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --overwrite-claude-md) OVERWRITE_MD=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Option inconnue : $arg" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYLOAD="$SCRIPT_DIR/payload"
CLAUDE_HOME="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$CLAUDE_HOME/backups/pro-setup-$STAMP"

WARNINGS=()

step() { printf '\n=== %s\n' "$1"; }
ok()   { printf '  [OK]   %s\n' "$1"; }
info() { printf '  [INFO] %s\n' "$1"; }
warn() { printf '  [WARN] %s\n' "$1"; WARNINGS+=("$1"); }
fail() { printf '  [FAIL] %s\n' "$1"; }

[ -d "$PAYLOAD" ] || { fail "Dossier 'payload' introuvable : $PAYLOAD"; exit 1; }

printf '\n  Installation de la configuration Claude Code professionnelle\n'
printf '  Cible : %s\n' "$CLAUDE_HOME"
[ "$DRY_RUN" = 1 ] && printf '  MODE SIMULATION - aucune ecriture\n'

# ------------------------------------------------------------ 1. audit
step '1/7  Audit de l'\''installation existante'
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code detecte : $(claude --version 2>&1 | head -1)"
else
  warn "Commande 'claude' introuvable dans le PATH."
fi

if [ -d "$CLAUDE_HOME" ]; then
  ok "Dossier .claude existant trouve"
  for sub in skills agents rules templates plugins; do
    [ -d "$CLAUDE_HOME/$sub" ] && info "$sub : $(find "$CLAUDE_HOME/$sub" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ') element(s)"
  done
else
  info "Aucun dossier .claude : creation complete"
fi

# ------------------------------------------------------------ 2. sauvegarde
step '2/7  Sauvegarde horodatee'
BACKED_UP=0
if [ -d "$CLAUDE_HOME" ]; then
  TO_BACKUP=()
  for item in CLAUDE.md settings.json settings.local.json skills agents rules templates; do
    [ -e "$CLAUDE_HOME/$item" ] && TO_BACKUP+=("$CLAUDE_HOME/$item")
  done
  [ -f "$HOME/.claude.json" ] && TO_BACKUP+=("$HOME/.claude.json")

  if [ ${#TO_BACKUP[@]} -gt 0 ]; then
    if [ "$DRY_RUN" = 1 ]; then
      info "SIMULATION : sauvegarde de ${#TO_BACKUP[@]} element(s) vers $BACKUP_DIR"
    else
      mkdir -p "$BACKUP_DIR"
      cp -R "${TO_BACKUP[@]}" "$BACKUP_DIR"/ 2>/dev/null
      ok "Sauvegarde creee : $BACKUP_DIR"
      BACKED_UP=1
    fi
    info "Elements sauvegardes : ${#TO_BACKUP[@]}"
  else
    info 'Rien a sauvegarder'
  fi
else
  info 'Pas de dossier .claude : aucune sauvegarde necessaire'
fi

# ------------------------------------------------------------ 3. structure
step '3/7  Creation de la structure'
for d in skills agents rules backups logs templates; do
  if [ -d "$CLAUDE_HOME/$d" ]; then
    info "$d/ existe deja"
  elif [ "$DRY_RUN" = 1 ]; then
    info "SIMULATION : creation de $d/"
  else
    mkdir -p "$CLAUDE_HOME/$d"; ok "$d/ cree"
  fi
done

# ------------------------------------------------------------ 4. copie
step '4/7  Installation des Skills, agents, regles et modeles'
copy_tree() {
  local src="$1" dst="$2" label="$3"
  [ -d "$src" ] || { warn "Source absente : $src"; return; }
  local added=0 kept=0 replaced=0
  while IFS= read -r -d '' f; do
    local rel="${f#$src/}"
    local target="$dst/$rel"
    if [ -e "$target" ]; then
      if [ "$FORCE" = 1 ]; then
        [ "$DRY_RUN" = 1 ] || { mkdir -p "$(dirname "$target")"; cp -f "$f" "$target"; }
        replaced=$((replaced+1))
      else
        kept=$((kept+1))
      fi
    else
      [ "$DRY_RUN" = 1 ] || { mkdir -p "$(dirname "$target")"; cp -f "$f" "$target"; }
      added=$((added+1))
    fi
  done < <(find "$src" -type f -print0)
  ok "$label : $added ajoute(s), $replaced remplace(s), $kept conserve(s)"
  if [ "$kept" -gt 0 ] && [ "$FORCE" != 1 ]; then
    info "  $kept fichier(s) conserve(s). Relancez avec --force pour les remplacer."
  fi
}

copy_tree "$PAYLOAD/skills"    "$CLAUDE_HOME/skills"    'skills'
copy_tree "$PAYLOAD/agents"    "$CLAUDE_HOME/agents"    'agents'
copy_tree "$PAYLOAD/rules"     "$CLAUDE_HOME/rules"     'rules'
copy_tree "$PAYLOAD/templates" "$CLAUDE_HOME/templates" 'templates'

# ------------------------------------------------------------ 5. CLAUDE.md
step '5/7  CLAUDE.md global'
SRC_MD="$PAYLOAD/CLAUDE.md"; DST_MD="$CLAUDE_HOME/CLAUDE.md"
if [ ! -f "$DST_MD" ]; then
  [ "$DRY_RUN" = 1 ] && info 'SIMULATION : installation de CLAUDE.md' || { cp "$SRC_MD" "$DST_MD"; ok 'CLAUDE.md installe'; }
elif [ "$OVERWRITE_MD" = 1 ]; then
  [ "$DRY_RUN" = 1 ] && info 'SIMULATION : remplacement de CLAUDE.md' || { cp "$SRC_MD" "$DST_MD"; ok 'CLAUDE.md remplace'; }
elif cmp -s "$SRC_MD" "$DST_MD"; then
  ok 'CLAUDE.md deja a jour (identique au paquet)'
  [ -f "$CLAUDE_HOME/CLAUDE.md.nouveau" ] && [ "$DRY_RUN" != 1 ] && rm -f "$CLAUDE_HOME/CLAUDE.md.nouveau"
else
  [ "$DRY_RUN" = 1 ] || cp "$SRC_MD" "$CLAUDE_HOME/CLAUDE.md.nouveau"
  warn "CLAUDE.md existe deja et differe : il a ete conserve. Nouvelle version : CLAUDE.md.nouveau (fusionnez, ou relancez avec --overwrite-claude-md)."
fi

# ------------------------------------------------------------ 6. settings.json
step '6/7  Fusion de settings.json'
SRC_SET="$PAYLOAD/settings.json"; DST_SET="$CLAUDE_HOME/settings.json"

if ! command -v python3 >/dev/null 2>&1; then
  warn "python3 absent : fusion de settings.json impossible."
  if [ ! -f "$DST_SET" ] && [ "$DRY_RUN" != 1 ]; then
    cp "$SRC_SET" "$DST_SET"; ok 'settings.json copie tel quel (aucun existant)'
  fi
else
  MERGE_OUT=$(DRY="$DRY_RUN" python3 - "$SRC_SET" "$DST_SET" <<'PYEOF'
import json, os, sys

src, dst = sys.argv[1], sys.argv[2]
dry = os.environ.get("DRY") == "1"

with open(src, encoding="utf-8") as f:
    new = json.load(f)

existing = {}
if os.path.exists(dst):
    try:
        with open(dst, encoding="utf-8") as f:
            txt = f.read().strip()
        existing = json.loads(txt) if txt else {}
        print("  [INFO] settings.json existant detecte : fusion non destructive")
    except Exception as e:
        print(f"  [FAIL] settings.json existant illisible ({e}) : AUCUNE modification")
        sys.exit(2)
else:
    print("  [INFO] Aucun settings.json : creation")

merged = dict(existing)

# L'existant gagne sur les cles simples.
for k, v in new.items():
    if k == "permissions":
        continue
    if k not in merged:
        merged[k] = v
        print(f"  [INFO]   ajout : {k}")
    else:
        print(f"  [INFO]   conserve (valeur existante) : {k}")

# Les listes de permissions sont unionnees : aucune entree existante n'est perdue.
np = new.get("permissions") or {}
if np:
    mp = merged.get("permissions")
    if not isinstance(mp, dict):
        mp = {}
    for pk, pv in np.items():
        if pk in ("allow", "ask", "deny"):
            old = mp.get(pk) or []
            if not isinstance(old, list):
                old = []
            union = list(dict.fromkeys(list(old) + list(pv)))
            mp[pk] = union
            print(f"  [INFO]   permissions.{pk} : {len(old)} existante(s) -> {len(union)} apres union")
        elif pk not in mp:
            mp[pk] = pv
            print(f"  [INFO]   permissions.{pk} : ajout")
        else:
            print(f"  [INFO]   permissions.{pk} : conserve")
    merged["permissions"] = mp

out = json.dumps(merged, indent=2, ensure_ascii=False)
json.loads(out)  # validation avant ecriture

if dry:
    print("  [INFO] SIMULATION : settings.json non ecrit")
else:
    with open(dst, "w", encoding="utf-8") as f:
        f.write(out + "\n")
    print("  [OK]   settings.json fusionne et valide")
PYEOF
  )
  rc=$?
  printf '%s\n' "$MERGE_OUT"
  [ $rc -ne 0 ] && warn "settings.json n'a PAS ete modifie (voir ci-dessus). La sauvegarde reste intacte."
fi

# ------------------------------------------------------------ 7. verification
step '7/7  Verification'
SKILL_COUNT=0; AGENT_COUNT=0
[ -d "$CLAUDE_HOME/skills" ] && SKILL_COUNT=$(find "$CLAUDE_HOME/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')
[ -d "$CLAUDE_HOME/agents" ] && AGENT_COUNT=$(find "$CLAUDE_HOME/agents" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
info "Skills avec SKILL.md : $SKILL_COUNT"
info "Agents (.md)         : $AGENT_COUNT"

if [ -f "$DST_SET" ]; then
  if python3 -m json.tool "$DST_SET" >/dev/null 2>&1; then ok 'settings.json : JSON valide'
  else fail 'settings.json : JSON INVALIDE - restaurez depuis la sauvegarde'; fi
fi
[ -f "$DST_MD" ] && ok 'CLAUDE.md present' || warn 'CLAUDE.md absent'

# ------------------------------------------------------------ resume
printf '\n  --------------------------------------------------\n'
printf '  RESUME\n'
printf '  --------------------------------------------------\n'
if [ "$BACKED_UP" = 1 ]; then printf '  Sauvegarde  : %s\n' "$BACKUP_DIR"; else printf '  Sauvegarde  : aucune (installation neuve ou simulation)\n'; fi
printf '  CLAUDE.md   : %s\n' "$DST_MD"
printf '  Skills      : %s  (%s)\n' "$CLAUDE_HOME/skills" "$SKILL_COUNT"
printf '  Agents      : %s  (%s)\n' "$CLAUDE_HOME/agents" "$AGENT_COUNT"
printf '  Settings    : %s\n' "$DST_SET"

if [ ${#WARNINGS[@]} -gt 0 ]; then
  printf '\n  AVERTISSEMENTS (%s) :\n' "${#WARNINGS[@]}"
  for w in "${WARNINGS[@]}"; do printf '   - %s\n' "$w"; done
fi

printf '\n  ETAPES SUIVANTES :\n'
printf '   1. Lancez  ./verify.sh  pour l'\''audit post-installation.\n'
printf '   2. Plugins et MCP : voir  docs/PLUGINS.md  et  docs/MCP.md\n'
printf '   3. Redemarrez Claude Code pour charger la configuration.\n\n'

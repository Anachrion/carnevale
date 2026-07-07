#!/usr/bin/env bash
set -euo pipefail

# Guards the color system: brand/semantic colors must be referenced through the theme-aware
# getters in lib/app_colors.dart (context.accentColor, context.dangerColor, …), never hardcoded
# at the call site. This keeps light/dark consistent and every color changeable in one place.
#
# Forbidden outside the palette layer:
#   • AppPalette.gold  — the primary accent is dark-mode-only; use context.accentColor so it
#                        flips to the deep red on the light theme.
#   • Colors.red*      — destructive/error signal; use context.dangerColor.
#
# Run:  ./scripts/check_colors.sh   (exits non-zero if anything leaks)

cd "$(dirname "$0")/.."

# Search app source only — the generated api_client and the palette layer itself are exempt.
SEARCH_DIRS="lib"
EXCLUDES=(
  --include='*.dart'
  --exclude-dir='api_client'
)
# The two files that are *allowed* to name raw palette tokens.
ALLOWED='lib/(app_palette|app_colors)\.dart'

fail=0

check() {
  local pattern="$1" label="$2"
  # grep -nE, then drop the allowed palette files from the hits.
  local hits
  hits=$(grep -rnE "${EXCLUDES[@]}" "$pattern" $SEARCH_DIRS 2>/dev/null | grep -vE "^$ALLOWED:" || true)
  if [[ -n "$hits" ]]; then
    echo "✗ $label"
    echo "$hits" | sed 's/^/    /'
    echo
    fail=1
  fi
}

check 'AppPalette\.gold\b' 'Hardcoded gold accent — use context.accentColor instead:'
check 'Colors\.red'        'Hardcoded red — use context.dangerColor instead:'

if [[ "$fail" -ne 0 ]]; then
  echo "Color guard failed. Route these through the getters in lib/app_colors.dart."
  exit 1
fi

echo "✓ No hardcoded accent/danger colors outside the palette layer."

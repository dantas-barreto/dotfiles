#!/bin/bash
# Install the Omarchy configs saved in this folder into ~/.config.
#
# Usage: ./setup-configs.sh [--dry-run]
#
# Each file under ./.config is copied to the same path under ~/.config
# (or $XDG_CONFIG_HOME). An existing file that differs is first backed up
# next to itself as <name>.bak.<timestamp>.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP=$(date +%s)
DRY_RUN=false

case "${1:-}" in
"") ;;
--dry-run) DRY_RUN=true ;;
*)
  echo "Usage: $0 [--dry-run]" >&2
  exit 1
  ;;
esac

FILES=(
  hypr/monitors.lua
  hypr/input.lua
  omarchy/shell.json
  omarchy/bar/scripts/sysstat
  chromium-flags.conf
  nvim/lazyvim.json
  nvim/lazy-lock.json
  nvim/lua/config/options.lua
  nvim/lua/config/autocmds.lua
  nvim/lua/plugins/cpp.lua
  nvim/spell/pt.utf-8.spl
)

# True when the destination already holds the same thing as the source.
same() {
  local src=$1 dest=$2
  if [[ -L $src ]]; then
    [[ -L $dest && $(readlink "$src") == "$(readlink "$dest")" ]]
  else
    [[ -f $dest && ! -L $dest ]] && cmp -s "$src" "$dest"
  fi
}

for file in "${FILES[@]}"; do
  src="$SRC/$file"
  dest="$DEST/$file"

  if [[ ! -e $src && ! -L $src ]]; then
    echo "missing    $file (not in $SRC)" >&2
    exit 1
  fi

  if same "$src" "$dest"; then
    echo "unchanged  $file"
    continue
  fi

  if [[ -e $dest || -L $dest ]]; then
    echo "backup     $file -> $(basename "$dest").bak.$STAMP"
    $DRY_RUN || mv "$dest" "$dest.bak.$STAMP"
  fi

  echo "install    $file"
  if ! $DRY_RUN; then
    mkdir -p "$(dirname "$dest")"
    # -P keeps the spell file as a symlink; -p keeps the executable bit.
    cp -pP "$src" "$dest"
  fi
done

$DRY_RUN || chmod +x "$DEST/omarchy/bar/scripts/sysstat"

# The Portuguese dictionary is a symlink into the vim-spell-pt package.
spell_target=$(readlink "$SRC/nvim/spell/pt.utf-8.spl")
if [[ ! -e $spell_target ]]; then
  echo
  echo "Note: $spell_target is missing, so the Portuguese spell check will not work."
  echo "      Install it with: omarchy pkg add vim-spell-pt"
fi

echo
if $DRY_RUN; then
  echo "Dry run: nothing was changed."
else
  echo "Done. Hyprland and the Omarchy bar reload on their own."
  echo "Restart Chromium for the new flags, and run :Lazy restore in Neovim to match lazy-lock.json."
fi

#!/bin/bash
# Install the Omarchy configs saved in this folder into ~/.config and ~.
#
# Usage: ./setup-configs.sh [--dry-run]
#
# Each file under ./.config is copied to the same path under ~/.config
# (or $XDG_CONFIG_HOME), and each file under ./home to the same path under ~.
# An existing file that differs is first backed up next to itself as
# <name>.bak.<timestamp>.
#
# A file that differs between the desktop and the laptop is saved as
# <name>.desktop.<ext> and <name>.laptop.<ext> (hypr/input.desktop.lua, for
# instance), and the one for this machine is installed as <name>.<ext>. The
# machine is a laptop when systemd says its chassis is one, or when it has a
# battery; MACHINE=desktop or MACHINE=laptop overrides that.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/.config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"
HOME_SRC="$HERE/home"
STAMP=$(date +%s)
DRY_RUN=false

# desktop or laptop: picks the variant of the files that have one.
detect_machine() {
  case "$(hostnamectl chassis 2>/dev/null || true)" in
  laptop | notebook | convertible | tablet | handset) echo laptop ;;
  desktop | server | vm | container | embedded) echo desktop ;;
  *)
    if compgen -G "/sys/class/power_supply/BAT*" >/dev/null; then
      echo laptop
    else
      echo desktop
    fi
    ;;
  esac
}

MACHINE="${MACHINE:-$(detect_machine)}"
if [[ $MACHINE != desktop && $MACHINE != laptop ]]; then
  echo "MACHINE must be desktop or laptop, not '$MACHINE'" >&2
  exit 1
fi
echo "machine    $MACHINE"

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
  nvim/lua/plugins/cmake.lua
  nvim/spell/pt.utf-8.spl
)

# Files for the home folder itself. The .clang-format is the shared Muse one:
# clang-format looks for it upwards from each file, so this one covers every
# repository under ~.
HOME_FILES=(
  .clang-format
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

# Copies <from>/<file> to <to>/<file>, backing up a different file already there.
install_file() {
  local from=$1 to=$2 file=$3
  local src="$from/$file" dest="$to/$file"

  # this machine's variant, when the file has one: input.lua -> input.laptop.lua
  local name=${file%.*} ext=${file##*.}
  local variant="$from/$name.$MACHINE.$ext"
  if [[ ! -e $src && ( -e $variant || -L $variant ) ]]; then
    src=$variant
  fi

  if [[ ! -e $src && ! -L $src ]]; then
    echo "missing    $file (not in $from, nor its $MACHINE variant)" >&2
    exit 1
  fi

  if same "$src" "$dest"; then
    echo "unchanged  $file"
    return
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
}

for file in "${FILES[@]}"; do
  install_file "$SRC" "$DEST" "$file"
done

for file in "${HOME_FILES[@]}"; do
  install_file "$HOME_SRC" "$HOME" "$file"
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

#!/usr/bin/env bash
# Installer for tmux-hpc-workflow. Idempotent. Run with --dry-run to preview.
set -euo pipefail

DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${TMUX_HPC_BIN_DIR:-$HOME/bin}"
CONFIG_DIR="${TMUX_HPC_CONFIG_DIR:-$HOME/.config/tmux-hpc-workflow}"
PLUGIN_DIR="$HOME/.tmux/plugins"
STAMP="$(date +%Y%m%d%H%M%S)"

log() { printf '==> %s\n' "$*"; }
run() { if [ "$DRY" = 1 ]; then printf 'DRY: %s\n' "$*"; else "$@"; fi; }
link() {  # link SRC DEST — back up an existing non-symlink target
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    log "backup $dest -> $dest.bak-$STAMP"; run mv "$dest" "$dest.bak-$STAMP"
  fi
  run ln -sfn "$src" "$dest"
}

log "repo: $REPO"

# 1. tmux.conf
link "$REPO/tmux.conf" "$HOME/.tmux.conf"

# 2. bin scripts
run mkdir -p "$BIN_DIR"
for f in "$REPO"/bin/*; do link "$f" "$BIN_DIR/$(basename "$f")"; done

# 3. plugins
run mkdir -p "$PLUGIN_DIR"
plugin_names=(tmux-resurrect tmux-yank vim-tmux-navigator tmux-fzf)
plugin_urls=(
  "https://github.com/tmux-plugins/tmux-resurrect"
  "https://github.com/tmux-plugins/tmux-yank"
  "https://github.com/christoomey/vim-tmux-navigator"
  "https://github.com/sainnhe/tmux-fzf"
)
for i in "${!plugin_names[@]}"; do
  name="${plugin_names[$i]}"
  if [ -d "$PLUGIN_DIR/$name" ]; then log "plugin present: $name"
  else run git clone --depth 1 "${plugin_urls[$i]}" "$PLUGIN_DIR/$name"; fi
done

# 4. runtime config (seed from samples on first run)
run mkdir -p "$CONFIG_DIR"
for c in projects agents; do
  if [ -e "$CONFIG_DIR/$c.conf" ]; then log "config present: $c.conf"
  else run cp "$REPO/config/$c.conf.sample" "$CONFIG_DIR/$c.conf"; log "seeded $c.conf — EDIT IT"; fi
done

# 5. wire aliases into ~/.bashrc (guarded, idempotent)
MARK="# >>> tmux-hpc-workflow >>>"
if grep -qF "$MARK" "$HOME/.bashrc" 2>/dev/null; then
  log "~/.bashrc already wired"
elif [ "$DRY" = 1 ]; then
  printf 'DRY: append aliases source block to ~/.bashrc\n'
else
  { printf '\n%s\n' "$MARK"
    printf 'source "%s/shell/aliases.sh"\n' "$REPO"
    printf '# <<< tmux-hpc-workflow <<<\n'; } >> "$HOME/.bashrc"
  log "appended aliases source block to ~/.bashrc"
fi

# 6. dependency check
for dep in tmux fzf git; do
  if command -v "$dep" >/dev/null 2>&1; then log "found: $dep"; else log "MISSING (required): $dep"; fi
done
command -v squeue >/dev/null 2>&1 || log "note: Slurm not found — HPC status modules will render empty"

log "done. Edit $CONFIG_DIR/projects.conf, open a new shell, then run: tmux"

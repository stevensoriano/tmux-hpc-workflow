# Dependencies

## Required
- **tmux** >= 3.4 (developed and tested on 3.5a). Older system builds (e.g. 2.x)
  lack the popup, `display-menu`, and multi-line `status-format` features this
  config uses — see `building-tmux.md` to build a current tmux without root.
- **bash** >= 4.4 (associative arrays; expanding an empty array under `set -u`
  — hit on the fresh-install path when config is absent — is only safe from 4.4).
- **git** (plugin fetch + this repo).
- **fzf** — the `prefix + f` sessionizer popup and the `prefix + Q` catch-all.

## Optional
- **Slurm** (`squeue`, `sinfo`, `scontrol`) — the status-line modules
  (`slurm-status`, `gpu-status`) and the admin "cluster" window. Without Slurm
  these panes render empty; everything else works.
- **htop** — the admin "mon" window (falls back to `top`).
- **xsel** — X11 `CLIPBOARD` integration for copy-mode `y` and mouse-drag copy.
  Without it, selections still reach tmux's own buffer; only the system-clipboard
  bridge is skipped.

## Plugins (installed by `install.sh`)
- tmux-resurrect, tmux-yank, vim-tmux-navigator, tmux-fzf.

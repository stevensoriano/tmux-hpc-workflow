# tmux-hpc-workflow

A polished, reproducible tmux setup for working across multiple projects on an
HPC/CFD cluster — built around per-project sessions, a two-row status bar with
clickable session tabs, an fzf sessionizer, and Slurm-aware status modules.

## Features

- **Two-row status bar** — a persistent **session tab strip** on top (every
  session as a tab; the attached one highlighted; click to switch) and the
  normal window/status row beneath it.
- **Fast navigation, no awkward chords** — prefix is **F12** (single key);
  `Shift`+`←/→` cycles windows, `Shift`+`↑/↓` cycles sessions, `Alt`+arrows move
  between panes.
- **fzf sessionizer** (`F12 f`) — jump to / create a project session from a
  curated list.
- **Per-project sessions** — `tmux-bootstrap` builds each project's
  `shell / agent / queue / logs` windows plus an admin session, all from a
  config file.
- **Slurm-aware status line** — live queue/GPU summaries; an admin "cluster"
  window with `sinfo` / `squeue` / GPU / CPU stripes.
- **Persistence** via tmux-resurrect; OSC 52 clipboard; resilient mouse-wheel
  scrolling.

## Install

```sh
git clone https://github.com/<your-username>/tmux-hpc-workflow.git
cd tmux-hpc-workflow
./install.sh            # add --dry-run first to preview
```

`install.sh` symlinks `tmux.conf` and `bin/*`, fetches the four plugins, seeds
your runtime config, and wires the aliases into `~/.bashrc`. Then:

```sh
$EDITOR ~/.config/tmux-hpc-workflow/projects.conf   # set your project paths
exec bash    # reload aliases
tmux
```

Need a current tmux? See [`docs/building-tmux.md`](docs/building-tmux.md).
Full key reference: [`docs/cheatsheet.html`](docs/cheatsheet.html).

## Customize

- **Projects** — `~/.config/tmux-hpc-workflow/projects.conf`: the session→dir map,
  per-session agent-pane counts (`AGENT_PANES`), and extra sessionizer roots.
- **Agent menu** — `~/.config/tmux-hpc-workflow/agents.conf`: the commands offered
  by the `F12 a` "spawn agent" menu.

These files live outside the repo and are never tracked, so your real project
names and tools stay private.

## Dependencies

tmux >= 3.4, bash >= 4.4, git, fzf; optional Slurm, htop, and xsel (X11 clipboard). See
[`docs/dependencies.md`](docs/dependencies.md).

## License

MIT — see [LICENSE](LICENSE).

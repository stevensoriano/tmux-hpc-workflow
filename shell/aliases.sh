# tmux-hpc-workflow shell aliases — source from ~/.bashrc:
#   source /path/to/tmux-hpc-workflow/shell/aliases.sh
# Builds attach-or-create aliases (t<name>) from your projects.conf.

# Ensure the workflow's bin dir is on PATH (adjust if you symlinked elsewhere).
case ":$PATH:" in *":$HOME/bin:"*) ;; *) export PATH="$HOME/bin:$PATH" ;; esac

_thpc_conf="${TMUX_HPC_CONFIG_DIR:-$HOME/.config/tmux-hpc-workflow}/projects.conf"
if [ -r "$_thpc_conf" ]; then
    # shellcheck disable=SC1090
    source "$_thpc_conf"
    for _s in "${!PROJECTS[@]}"; do
        # shellcheck disable=SC2139
        alias "t${_s}=tmux attach -t ${_s} 2>/dev/null || tmux new -s ${_s} -c '${PROJECTS[$_s]}'"
    done
    unset _s
fi
unset _thpc_conf

# Admin session (full layout); falls back to bootstrap if missing.
alias tadmin='tmux attach -t tadmin 2>/dev/null || (tmux-bootstrap >/dev/null && tmux attach -t tadmin)'
alias tls='tmux ls'
alias tmuxs='tmux-sessionizer'
alias tdiag='tmux-diag'

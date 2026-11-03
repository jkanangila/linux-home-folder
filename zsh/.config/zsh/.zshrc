# $ZDOTDIR/.zshrc — interactive-shell entry point.
# Keep this file lightweight. Configuration lives in conf.d/
# and reusable functions live in functions/.
# vim: ft=zsh

# ── XDG directories ──────────────────────────────────────────────

: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

ZSH_DATA_DIR="$XDG_DATA_HOME/zsh"
ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
ZSH_STATE_DIR="$XDG_STATE_HOME/zsh"

# Export for child processes and configuration modules.
export ZSH_DATA_DIR ZSH_CACHE_DIR ZSH_STATE_DIR

# Create required directories.
for _dir in "$ZSH_DATA_DIR/plugins" "$ZSH_CACHE_DIR" "$ZSH_STATE_DIR"; do
  [[ -d $_dir ]] || mkdir -p -- "$_dir"
done
unset _dir

# ── Function autoloading ─────────────────────────────────────────

# Register functions for lazy loading.
if [[ -d "$ZDOTDIR/functions" ]]; then
  fpath=("$ZDOTDIR/functions" $fpath)

  autoload -Uz "$ZDOTDIR"/functions/*(N-.:t)
fi

# ── Modular configuration ────────────────────────────────────────

# Files are loaded in lexical order.
if [[ -d "$ZDOTDIR/conf.d" ]]; then
  for _file in "$ZDOTDIR"/conf.d/*.zsh(N); do
    [[ -r $_file ]] && source "$_file"
  done
fi
unset _file

# ── Machine-specific overrides ──────────────────────────────────

# Optional, untracked configuration.
if [[ -r "$ZDOTDIR/local.zsh" ]]; then
  source "$ZDOTDIR/local.zsh"
fi

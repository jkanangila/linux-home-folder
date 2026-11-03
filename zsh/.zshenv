# ~/.zshenv — read by EVERY zsh before anything else (and before ZDOTDIR is known),
# so it must stay tiny. It only points zsh at the real config directory.
# With this in place zsh reads $ZDOTDIR/.zshrc itself; no ~/.zshrc is needed.
# vim: ft=zsh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

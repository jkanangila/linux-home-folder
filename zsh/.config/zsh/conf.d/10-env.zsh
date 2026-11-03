# Environment variables and the base PATH.

typeset -U path PATH                 # keep PATH free of duplicates

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"

# Ollama server address (host:port, not an HTTP URL)
export OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"

# Tools that spawn $SHELL (nvim :terminal, yazi, tmux) should get this zsh,
# not whichever login shell happens to be configured for the account.
(( $+commands[zsh] )) && export SHELL="${commands[zsh]}"

# Prefer user-installed executables
path=("$HOME/.local/bin" /usr/local/bin $path)

# Rendering problems under WSLg/chroots? Don't force software GL globally;
# launch the one misbehaving app with LIBGL_ALWAYS_SOFTWARE=1 instead.

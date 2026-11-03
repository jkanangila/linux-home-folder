# Key bindings.

# Up/Down search history for commands starting with what you've already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search     # Up
bindkey '^[OA' up-line-or-beginning-search     # Up (application mode)
bindkey '^[[B' down-line-or-beginning-search   # Down
bindkey '^[OB' down-line-or-beginning-search   # Down (application mode)
[[ -n ${terminfo[kcuu1]} ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n ${terminfo[kcud1]} ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# In vi command mode, leave Up/Down unbound so mouse-wheel scrolling
# (sent as arrow keys) doesn't walk through history.
bindkey -M vicmd -r '^[[A'
bindkey -M vicmd -r '^[[B'

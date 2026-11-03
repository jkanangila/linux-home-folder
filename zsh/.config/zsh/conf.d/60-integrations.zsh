# Tools that hook into the shell. They need compinit (30) and PATH (10/20) first.

# ── Prompt ───────────────────────────────────────────────────────────────
if (($+commands[starship])); then
  eval "$(starship init zsh)"
else
  print -P "%F{yellow}starship not found%f — install it (pacman -S starship, or https://starship.rs)"
fi

# ── Smarter cd ───────────────────────────────────────────────────────────
(($+commands[zoxide])) && eval "$(zoxide init zsh --cmd cd)"

# ── Per-directory environments ───────────────────────────────────────────
(($+commands[direnv])) && eval "$(direnv hook zsh)"

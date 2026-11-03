# Tools that hook into the shell. Interactive only; they need PATH from 00/10 first.
status is-interactive; or return

# ── Prompt ───────────────────────────────────────────────────────────────
if type -q starship
    starship init fish | source
else
    echo "starship not found — install it (pacman -S starship, or https://starship.rs)" >&2
end

# ── Smarter cd ───────────────────────────────────────────────────────────
type -q zoxide; and zoxide init fish --cmd cd | source

# ── Per-directory environments ───────────────────────────────────────────
type -q direnv; and direnv hook fish | source

# fish already ships autosuggestions and syntax highlighting, so there's no
# plugin to install for those. Right Arrow / End accept a suggestion.

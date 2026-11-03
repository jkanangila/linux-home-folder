# Aliases. Anything environment-specific is guarded so it only exists where it works.

# ── Core wrappers (-v shows what happened; use -i if you'd rather be asked) ──
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias cl='clear'
alias reload='exec zsh'
(($+commands[nvim])) && alias vim='nvim'

# ── ls → eza / lsd, with a plain-ls fallback ───────────────────────────────────
if (($+commands[eza])); then
    alias ls='eza --icons --group-directories-first -1'
    alias l='ls'
    alias ll='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
elif (($+commands[lsd])); then
    alias ls='lsd --group-directories-first'
    alias ll='lsd -l --header'
    alias la='lsd -la --header'
    alias lt='lsd --tree --depth 2'
    alias lta='lsd --tree --depth 2 -a'
    alias lsize='lsd -l --total-size --sort size --reverse'
else
    alias ls='ls --color=auto --group-directories-first'
fi

# ── System monitoring / disk usage ───────────────────────────────────────
(($+commands[btop])) && alias top='btop'
if (($+commands[gdu])); then
    alias dus='gdu'
    alias gdux='sudo gdu -x /'
fi
(($+commands[lazygit])) && alias lg='lazygit'

# ── Python / Django ──────────────────────────────────────────────────────
alias py='python'
alias drun='python manage.py runserver'
alias dmake='python manage.py makemigrations'
alias dmi='python manage.py migrate'
alias dtest='python manage.py test'

# ── Services: systemd where it exists, SysV `service` elsewhere (chroots) ─
if (($+commands[systemctl])) && [[ -d /run/systemd/system ]]; then
    alias spst='sudo systemctl start postgresql'
elif (($+commands[service])); then
    alias spst='sudo service postgresql start'
fi

# ── Termux host: enter / leave the Ubuntu chroot ─────────────────────────
if [[ -d /data/data/com.termux ]]; then
    alias ubuntu="su -c 'exec /data/data/com.termux/files/home/chroot/start_ubuntu.sh'"
    alias ubuntu-root="su -c 'exec /data/data/com.termux/files/home/chroot/root_ubuntu.sh'"
    alias ubuntu-stop="su -c 'exec /data/data/com.termux/files/home/chroot/stop_ubuntu.sh'"
fi

# ── Lemonade clipboard: silence the client's chatter ─────────────────────
if (($+commands[lemonade])); then
    alias lemonade-copy='lemonade copy > /dev/null 2>&1'
    alias lemonade-paste='lemonade paste 2> /dev/null'
fi

# ── GNOME keyring ────────────────────────────────────────────────────────
alias uk='unlock_keyring'

# ── Python / UV package manager ────────────────────────────────
if (($+commands[uv])); then
    # Project management
    alias uvi='uv init'
    alias uil='uv init --lib'
    alias uis='uv init --script'
    alias uia='uv init --app'

    # Dependencies
    alias ua='uv add'
    alias uad='uv add --dev'
    alias urm='uv remove'
    alias us='uv sync'
    alias usf='uv sync --frozen'
    alias ul='uv lock'
    alias ulc='uv lock --check'
    # Running Python
    #
    alias ur='uv run'
    alias upy='uv run python'
    alias upytest='uv run pytest'
    alias upytestc='uv run pytest --cov'

    # Python versions
    alias upv='uv python list'
    alias upin='uv python install'
    alias upfind='uv python find'

    # Virtual environments
    alias uvv='uv venv'
    alias uva='source .venv/bin/activate'
    alias uvx='uv tool run'

    # Tool management
    alias ut='uv tool'
    alias uti='uv tool install'
    alias utr='uv tool run'
    alias utl='uv tool list'
    alias utrm='uv tool uninstall'
    alias utup='uv tool upgrade --all'

    # Maintenance
    alias ucache='uv cache clean'
    alias uversion='uv version'
    alias uhelp='uv help'
fi

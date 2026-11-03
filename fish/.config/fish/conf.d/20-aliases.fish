# Aliases and abbreviations. Interactive only.
#
# alias -> persistent command wrapper.
# abbr  -> expands into the full command as you type.
#
# Environment-specific commands are guarded.

status is-interactive; or return

# ── Core wrappers ─────────────────────────────────────────────

alias cp 'cp -v'
alias mv 'mv -v'
alias rm 'rm -v'

abbr -a cl 'clear'
abbr -a reload 'exec fish'

if type -q nvim
    abbr -a vim 'nvim'
end

# ── Directory listing: eza / lsd / ls ─────────────────────────

if type -q eza
    alias ls 'eza --icons --group-directories-first -1'

    abbr -a l 'ls'
    abbr -a ll 'ls -l'
    abbr -a la 'ls -a'
    abbr -a lla 'ls -la'

else if type -q lsd
    alias ls 'lsd --group-directories-first'
    alias ll 'lsd -l --header'
    alias la 'lsd -la --header'
    alias lt 'lsd --tree --depth 2'
    alias lta 'lsd --tree --depth 2 -a'
    alias lsize 'lsd -l --total-size --sort size --reverse'

else
    alias ls 'ls --color=auto --group-directories-first'
end

# ── System monitoring / disk usage ─────────────────────────────

if type -q btop
    alias top 'btop'
end

if type -q gdu
    abbr -a dus 'gdu'
    abbr -a gdux 'sudo gdu -x /'
end

# ── Python / Django ────────────────────────────────────────────

abbr -a py 'python'
abbr -a drun 'python manage.py runserver'
abbr -a dmake 'python manage.py makemigrations'
abbr -a dmi 'python manage.py migrate'
abbr -a dtest 'python manage.py test'

# ── PostgreSQL service management ─────────────────────────────

if type -q systemctl; and test -d /run/systemd/system
    abbr -a spst 'sudo systemctl start postgresql'
else if type -q service
    abbr -a spst 'sudo service postgresql start'
end

# ── Termux host: Ubuntu chroot ─────────────────────────────────

if test -d /data/data/com.termux
    abbr -a ubuntu \
        "su -c 'exec /data/data/com.termux/files/home/chroot/start_ubuntu.sh'"

    abbr -a ubuntu-root \
        "su -c 'exec /data/data/com.termux/files/home/chroot/root_ubuntu.sh'"

    abbr -a ubuntu-stop \
        "su -c 'exec /data/data/com.termux/files/home/chroot/stop_ubuntu.sh'"
end

# ── GNOME keyring ──────────────────────────────────────────────

if type -q unlock_keyring
    abbr -a uk 'unlock_keyring'
end

# ── Git ────────────────────────────────────────────────────────

if type -q lazygit
    abbr -a lg 'lazygit'
end

if type -q git
    abbr -a gd 'git diff'
    abbr -a ga 'git add .'
    abbr -a gc 'git commit -am'
    abbr -a gl 'git log'
    abbr -a gs 'git status'
    abbr -a gst 'git stash'
    abbr -a gsp 'git stash pop'
    abbr -a gp 'git push'
    abbr -a gpl 'git pull'
    abbr -a gsw 'git switch'
    abbr -a gsm 'git switch main'
    abbr -a gb 'git branch'
    abbr -a gbd 'git branch -d'
    abbr -a gco 'git checkout'
    abbr -a gsh 'git show'
end


# ── Python / UV package manager ────────────────────────────────

if type -q uv

    # Project management
    abbr -a uvi 'uv init'
    abbr -a uil 'uv init --lib'
    abbr -a uis 'uv init --script'
    abbr -a uia 'uv init --app'

    # Dependencies
    abbr -a ua 'uv add'
    abbr -a uad 'uv add --dev'
    abbr -a urm 'uv remove'
    abbr -a us 'uv sync'
    abbr -a usf 'uv sync --frozen'
    abbr -a ul 'uv lock'
    abbr -a ulc 'uv lock --check'

    # Running Python
    abbr -a ur 'uv run'
    abbr -a upy 'uv run python'
    abbr -a upytest 'uv run pytest'
    abbr -a upytestc 'uv run pytest --cov'

    # Python versions
    abbr -a upv 'uv python list'
    abbr -a upin 'uv python install'
    abbr -a upfind 'uv python find'

    # Virtual environments
    abbr -a uvv 'uv venv'
    abbr -a uva 'source .venv/bin/activate.fish'
    abbr -a uvx 'uv tool run'

    # Tool management
    abbr -a ut 'uv tool'
    abbr -a uti 'uv tool install'
    abbr -a utr 'uv tool run'
    abbr -a utl 'uv tool list'
    abbr -a utrm 'uv tool uninstall'
    abbr -a utup 'uv tool upgrade --all'

    # Maintenance
    abbr -a ucache 'uv cache clean'
    abbr -a uversion 'uv version'
    abbr -a uhelp 'uv help'

end


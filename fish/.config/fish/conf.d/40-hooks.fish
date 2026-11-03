# Directory-change hooks and shell-start tasks. Interactive only.
#
# Event handlers (--on-variable, --on-event) must live in conf.d/: functions/ is
# autoloaded on first call, so a handler placed there would never be registered.
status is-interactive; or return

# Auto-activate/deactivate the pipenv virtualenv for projects with a Pipfile.
function __auto_pipenv_shell --on-variable PWD --description 'Activate/deactivate pipenv venv on cd'
    type -q pipenv; or return

    # Entering a project (Pipfile present, no environment active)
    if test -f Pipfile; and test -z "$VIRTUAL_ENV"
        set -l venv_path
        if test -r .venv/bin/activate.fish
            # PIPENV_VENV_IN_PROJECT=1 puts the venv in ./.venv — skips pipenv's slow startup
            set venv_path $PWD/.venv
        else
            set venv_path (pipenv --venv 2>/dev/null)
        end

        if test -n "$venv_path"; and test -r "$venv_path/bin/activate.fish"
            echo "💡 Pipfile detected. Activating virtual environment..."
            set -gx PIPENV_SHELL_ORIGIN_DIR $PWD
            source "$venv_path/bin/activate.fish"
        end
        return
    end

    # Leaving (we activated an env and PWD is no longer inside that project)
    if test -n "$VIRTUAL_ENV"; and test -n "$PIPENV_SHELL_ORIGIN_DIR"
        if test "$PWD" != "$PIPENV_SHELL_ORIGIN_DIR"; and not string match -q -- "$PIPENV_SHELL_ORIGIN_DIR/*" "$PWD"
            echo "👋 Left project directory. Deactivating virtual environment..."
            set -e PIPENV_SHELL_ORIGIN_DIR
            deactivate
        end
    end
end
__auto_pipenv_shell    # also handle the directory the shell starts in

# Termux only: make sure the Lemonade clipboard server is running.
init_clip_sync

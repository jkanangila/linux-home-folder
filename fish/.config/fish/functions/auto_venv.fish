# Automatically manages project-local Python virtual environments.
#
# Behavior:
#   - Finds the nearest `.venv` in $PWD or any parent directory.
#   - Activates it, and keeps it active anywhere under that project.
#   - Deactivates it (only if this function activated it) when you leave
#     the project, or switches if you enter another project.
#   - Never overrides a manually activated virtual environment.
#   - Respects a manual `deactivate`: won't re-activate that venv until
#     you leave the project and come back.
#
# Variables:
#   __AUTO_VENV            venv activated by this function (ownership)
#   __AUTO_VENV_OPTOUT     venv the user manually deactivated
#   auto_venv_skip_home    set to anything to ignore a `.venv` in $HOME
#                          (e.g. `set -g auto_venv_skip_home 1`)
#
# Requirements: fish 3.5+ (for `path`), `.venv/bin/activate.fish`
#
# Setup: put `auto_venv` in config.fish once. --on-variable handlers only
# register when the function file is first autoloaded, and the call also
# handles the directory a new terminal starts in.

function __auto_venv_find
    set -l dir $PWD
    while true
        if set -q auto_venv_skip_home; and test "$dir" = "$HOME"
            return 1
        end
        if test -f "$dir/.venv/bin/activate.fish"
            path resolve "$dir/.venv"
            return 0
        end
        test "$dir" = /; and return 1
        set dir (path dirname "$dir")
    end
end

function auto_venv --on-variable PWD
    status is-interactive; or return

    set -l target (__auto_venv_find)

    # The user ran `deactivate` themselves: remember not to re-activate.
    if set -q __AUTO_VENV; and not set -q VIRTUAL_ENV
        set -g __AUTO_VENV_OPTOUT "$__AUTO_VENV"
        set -e __AUTO_VENV
    end

    # Forget the opt-out once we've left that project.
    if set -q __AUTO_VENV_OPTOUT; and test "$__AUTO_VENV_OPTOUT" != "$target"
        set -e __AUTO_VENV_OPTOUT
    end

    # Deactivate our own venv when leaving it or switching projects.
    if set -q __AUTO_VENV; and test "$__AUTO_VENV" != "$target"
        if set -q VIRTUAL_ENV
            set -l active (path resolve "$VIRTUAL_ENV")
            if test "$active" = "$__AUTO_VENV"; and functions -q deactivate
                deactivate
            end
        end
        set -e __AUTO_VENV
    end

    # Nothing to activate, or the user opted out of this one.
    test -n "$target"; or return
    test "$target" = "$__AUTO_VENV_OPTOUT"; and return

    # Something is already active (ours or manual): leave it alone.
    set -q VIRTUAL_ENV; and return

    source "$target/bin/activate.fish"
    if set -q VIRTUAL_ENV
        set -g __AUTO_VENV "$target"
    end
end

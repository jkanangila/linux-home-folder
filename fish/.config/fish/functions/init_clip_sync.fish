# Termux only: start the Lemonade clipboard server in the background if it
# isn't already running. Config comes from ~/.config/lemonade.toml.
function init_clip_sync --description 'Start the Lemonade clipboard server on Termux'
    if not set -q TERMUX_VERSION; and not string match -q '*com.termux*' -- "$PREFIX"
        return 0
    end
    type -q lemonade; or return 0
    pgrep -x lemonade >/dev/null; and return 0

    echo "Starting Lemonade clipboard server in background..."
    lemonade server >/dev/null 2>&1 &
    disown
end

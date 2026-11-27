# Caelestia integration. Interactive only.
status is-interactive; or return
test -d ~/.local/state/caelestia; or test -d ~/.config/caelestia; or return

# Custom terminal colours
command cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

# Jump between prompts in foot
function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end

# User overrides (sourced last, so they win over everything above)
set -l cConf $HOME/.config/caelestia
set -q XDG_CONFIG_HOME; and set cConf $XDG_CONFIG_HOME/caelestia
source $cConf/user-config.fish 2>/dev/null

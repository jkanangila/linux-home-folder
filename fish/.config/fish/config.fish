# ~/.config/fish/config.fish — intentionally almost empty.
# fish auto-loads everything in conf.d/ (alphabetically) and lazily loads
# functions/, so there is nothing to source by hand. See conf.d/ for the config.

if status is-interactive
    set -g fish_greeting    # no welcome message
end

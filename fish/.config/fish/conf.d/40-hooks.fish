# Termux only: make sure the Lemonade clipboard server is running.
init_clip_sync

# Auto-activate .venv on cd: initial execution registration
# see ~/.config/fish/functions/auto_venv.fish for more details
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1   # let Starship show the venv name
set -g auto_venv_skip_home 1           # optional: ignore ~/.venv
auto_venv

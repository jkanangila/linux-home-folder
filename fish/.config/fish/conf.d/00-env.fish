# Environment variables and the base PATH. Runs for every fish, interactive or not.

set -q EDITOR; or set -gx EDITOR nvim
set -q VISUAL; or set -gx VISUAL $EDITOR

# Ollama server address (host:port, not an HTTP URL)
set -q OLLAMA_HOST; or set -gx OLLAMA_HOST 127.0.0.1:11434

# fish_add_path skips directories that don't exist.
#   -g  keep this out of the universal fish_variables file (which would churn in git)
#   -m  move entries to the front if they're already on PATH
fish_add_path -g -m $HOME/.local/bin /usr/local/bin

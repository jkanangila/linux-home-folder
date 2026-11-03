# Directory-change hooks and shell-start tasks.

autoload -Uz add-zsh-hook

# Auto-activate/deactivate the pipenv virtualenv for projects with a Pipfile.
if (( $+commands[pipenv] )); then
  add-zsh-hook chpwd auto_pipenv_shell
  auto_pipenv_shell                  # also handle the directory the shell starts in
fi

# Termux only: make sure the Lemonade clipboard server is running.
init_clip_sync

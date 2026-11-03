# Plugins. Loaded LAST on purpose: zsh-syntax-highlighting wraps ZLE widgets,
# so it has to come after every bindkey / widget definition above.
# Plugins are cloned on first use into $ZSH_DATA_DIR/plugins (see zsh_add_plugin);
# update them with `zsh-update-plugins`.

# Configure before loading: accept suggestions only with Right Arrow or End
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line)
zsh_add_plugin zsh-users/zsh-autosuggestions

# Other candidates:
#   marlonrichert/zsh-autocomplete     real-time type-ahead completion
#   zsh-users/zsh-completions          extra completion definitions (add to fpath before compinit)
#   https://github.com/unixorn/awesome-zsh-plugins

zsh_add_plugin zsh-users/zsh-syntax-highlighting     # keep this one last


#!/bin/sh

#          ╭──────────────────────────────────────────────────────────╮
#          │        CORE SHELL BEHAVIOR & INTERACTIVE OPTIONS         │
#          ╰──────────────────────────────────────────────────────────╯

# Configures general Zsh shell enhancements:
# - autocd: Allows typing a directory path directly to 'cd' into it without the 'cd' command
# - extendedglob: Enables advanced, powerful pattern matching (wildcards) for filenames
# - nomatch: Prevents commands from running if a filename pattern match (glob) fails
# - menucomplete: Automatically inserts the first match immediately upon pressing Tab
setopt autocd extendedglob nomatch menucomplete

# Allows comments starting with '#' to be typed or pasted directly into interactive shell prompts
setopt interactive_comments

# Unbinds the 'Ctrl + S' shortcut, preventing it from accidentally freezing terminal output
stty stop undef		

# Disables text highlighting or formatting quirks when pasting code blocks into the terminal
zle_highlight=('paste:none')

# Disables all audio system beeps and alerts entirely to ensure a quiet terminal experience
unsetopt BEEP


#          ╭──────────────────────────────────────────────────────────╮
#          │      Disable mouse wheel scrolling through history       │
#          ╰──────────────────────────────────────────────────────────╯
bindkey -r '^[[A' # Disables Up arrow mapping if triggered by mouse
bindkey -r '^[[B' # Disables Down arrow mapping if triggered by mouse
bindkey -M vicmd -r '^[[A' 
bindkey -M vicmd -r '^[[B'


#          ╭──────────────────────────────────────────────────────────╮
#          │            COMPLETION SYSTEM (COMPINIT) SETUP            │
#          ╰──────────────────────────────────────────────────────────╯

# Pre-loads the native shell framework modules responsible for advanced completions and prompts
autoload -Uz compinit promptinit

# Configures case-insensitive completion matching (e.g., typing 'docs' can match 'Documents')
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Loads the visual completion selection module, enabling keyboard navigation through Tab menus
zmodload zsh/complist

# Initializes the advanced command-line completion engine
compinit

# Initializes the framework responsible for building dynamic terminal prompts
promptinit


#          ╭──────────────────────────────────────────────────────────╮
#          │        SMART HISTORY SEARCH SETTINGS (ARROW KEYS)        │
#          ╰──────────────────────────────────────────────────────────╯

# Loads advanced navigation functions that search command history based on typed prefixes
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# Registers these smart search routines as official Zsh Line Editor (ZLE) widgets
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


#          ╭──────────────────────────────────────────────────────────╮
#          │              VISUAL STYLING & MODULAR FILES              │
#          ╰──────────────────────────────────────────────────────────╯

# Automatically maps out and registers standard terminal color variables ($fg, $bg) for custom styling
autoload -Uz colors && colors

# Sources the external file containing custom utility functions compiled by the user
source "$ZDOTDIR/zsh-functions"

# Dynamically evaluates and imports local environmental variable and path settings
zsh_add_file "zsh-exports"

# Dynamically evaluates and imports custom shortcut keywords and command modifications
zsh_add_file "zsh-aliases"

# zsh_add_file "zsh-prompt"


#          ╭──────────────────────────────────────────────────────────╮
#          │         THIRD-PARTY PLUGIN & EMPOWERMENT LOADING         │
#          ╰──────────────────────────────────────────────────────────╯

# Fetches or injects predictive command suggestions based on the user's history profile
zsh_add_plugin "zsh-users/zsh-autosuggestions"
# Only accept suggestions with Right Arrow or End key
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line)

# Fetches or injects live syntax validation coloring for recognized terminal keywords
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Adds real-time type-ahead autocompletion
# zsh_add_plugin "marlonrichert/zsh-autocomplete"

# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions


# Dynamically evaluates and applies the customized user interface prompt theme layout
zsh_add_starship_prompt

# Add lsd (colorised ls commands)
zsh_ensure_lsd

#          ╭──────────────────────────────────────────────────────────╮
#          │         SYSTEM RUNTIME HOOKS & STARTUP EXECUTION         │
#          ╰──────────────────────────────────────────────────────────╯

# Loads the unified event-handling driver required to bind functions directly into shell changes
autoload -Uz add-zsh-hook

# Registers the unified controller to Zsh's directory-change callback hook
add-zsh-hook chpwd auto_pipenv_shell

# Evaluates the active directory immediately upon core shell initialization
auto_pipenv_shell

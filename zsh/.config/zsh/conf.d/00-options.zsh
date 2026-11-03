# Shell behaviour: options, history, terminal quirks.

# autocd:               type a directory name to cd into it
# extendedglob:         richer filename patterns (also needed by 30-completion)
# nomatch:              error instead of passing a failed glob through literally
# menucomplete:         Tab inserts the first match immediately
# interactive_comments: allow '# comments' at the prompt
setopt autocd extendedglob nomatch menucomplete interactive_comments
unsetopt BEEP

stty stop undef 2>/dev/null          # free Ctrl-S so it can't freeze the terminal
zle_highlight=('paste:none')         # don't highlight pasted text

# ── History ──────────────────────────────────────────────────────────────
HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

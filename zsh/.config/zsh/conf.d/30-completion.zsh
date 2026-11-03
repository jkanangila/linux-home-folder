# Completion system.

zmodload zsh/complist                # menu-style completion navigation

# Case-insensitive matching: 'docs' completes to Documents
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -Uz compinit
_zcompdump="$ZSH_CACHE_DIR/zcompdump"

# compinit is slow because it audits every completion file. Do the full rebuild
# at most once a day (or when the dump is missing); otherwise trust the cache (-C).
_zcomp_stale=("$_zcompdump"(N.mh+24))
if [[ ! -s $_zcompdump ]] || (( $#_zcomp_stale )); then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _zcomp_stale

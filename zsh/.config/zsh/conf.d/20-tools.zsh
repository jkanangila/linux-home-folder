# Language runtimes and version managers.
# Each block is a no-op when the tool isn't installed.

# ── pyenv ────────────────────────────────────────────────────────────────
if [[ -d $HOME/.pyenv ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  path=("$PYENV_ROOT/bin" $path)
  (( $+commands[pyenv] )) && eval "$(pyenv init - zsh)"
fi

# ── pipenv ───────────────────────────────────────────────────────────────
(( $+commands[pipenv] )) && export PIPENV_VENV_IN_PROJECT="${PIPENV_VENV_IN_PROJECT:-1}"

# ── Node (nvm), lazy-loaded ──────────────────────────────────────────────
# Sourcing nvm.sh costs a few hundred ms on every shell start, so it's deferred
# until the first call to nvm/node/npm/npx. Until then the default Node (from
# nvm's "default" alias if it names an exact version, else the newest installed)
# is already on PATH so editors and LSP servers can find it.
if [[ -d $HOME/.nvm ]]; then
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  _nvm_default=""
  [[ -r $NVM_DIR/alias/default ]] && _nvm_default="$(<"$NVM_DIR/alias/default")"
  if [[ -n $_nvm_default && -d $NVM_DIR/versions/node/$_nvm_default/bin ]]; then
    path=("$NVM_DIR/versions/node/$_nvm_default/bin" $path)
  else
    setopt numeric_glob_sort
    _nvm_newest=("$NVM_DIR"/versions/node/*/bin(N/On[1]))
    unsetopt numeric_glob_sort
    (( $#_nvm_newest )) && path=("${_nvm_newest[1]}" $path)
  fi
  unset _nvm_default _nvm_newest

  _nvm_lazy_load() {
    unset -f nvm node npm npx _nvm_lazy_load
    [[ -s $NVM_DIR/nvm.sh ]] && source "$NVM_DIR/nvm.sh"
  }
  nvm()  { _nvm_lazy_load; nvm  "$@" }
  node() { _nvm_lazy_load; node "$@" }
  npm()  { _nvm_lazy_load; npm  "$@" }
  npx()  { _nvm_lazy_load; npx  "$@" }
fi

# ── rbenv ────────────────────────────────────────────────────────────────
if [[ -d $HOME/.rbenv ]]; then
  path=("$HOME/.rbenv/bin" $path)
  (( $+commands[rbenv] )) && eval "$(rbenv init - zsh)"
fi

# ── Rust (cargo) ─────────────────────────────────────────────────────────
[[ -d $HOME/.cargo/bin ]] && path=("$HOME/.cargo/bin" $path)

# ── Go ───────────────────────────────────────────────────────────────────
if (( $+commands[go] )); then
  export GOPATH="${GOPATH:-$HOME/go}"
  path=("$GOPATH/bin" $path)
fi

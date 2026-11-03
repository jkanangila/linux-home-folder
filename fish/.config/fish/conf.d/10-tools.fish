# Language runtimes and version managers.
# Each block is a no-op when the tool isn't installed.

# ── pyenv ────────────────────────────────────────────────────────────────
if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -g $PYENV_ROOT/bin
    if status is-interactive; and type -q pyenv
        pyenv init - fish | source
    end
end

# ── pipenv ───────────────────────────────────────────────────────────────
if type -q pipenv
    set -q PIPENV_VENV_IN_PROJECT; or set -gx PIPENV_VENV_IN_PROJECT 1
end

# ── Node ─────────────────────────────────────────────────────────────────
# nvm.sh is a bash script and can't be sourced by fish, so this uses nvm.fish
# (installed through fisher, see fish_plugins). It manages its own Node versions
# under $nvm_data, separate from ~/.nvm — run `nvm install lts` once.
# `fnm` is a faster alternative if you'd rather switch.
set -q nvm_default_version; or set -g nvm_default_version lts

# ── rbenv ────────────────────────────────────────────────────────────────
if test -d $HOME/.rbenv
    fish_add_path -g $HOME/.rbenv/bin
    if status is-interactive; and type -q rbenv
        rbenv init - fish | source
    end
end

# ── Rust (cargo) ─────────────────────────────────────────────────────────
fish_add_path -g $HOME/.cargo/bin

# ── Go ───────────────────────────────────────────────────────────────────
if type -q go
    set -q GOPATH; or set -gx GOPATH $HOME/go
    fish_add_path -g $GOPATH/bin
end

#!/usr/bin/env bash
# First-time setup for CachyOS (Arch-based). Run as your NORMAL user (not root);
# sudo is used only where needed.
set -euo pipefail

LOCKFILE="$HOME/.local/state/cachyos_setup_complete.lock"
mkdir -p "$(dirname "$LOCKFILE")"

if [ -f "$LOCKFILE" ]; then
    echo "Setup already completed (lockfile: $LOCKFILE). Delete it to re-run."
    exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as your normal user, not root." >&2
    exit 1
fi

echo "=== 1. System update & packages ==="
sudo pacman -Syu --noconfirm

PACKAGES=(
    # Core / network
    ca-certificates gnupg wget curl git tzdata

    # Build toolchain (base-devel = gcc, make, pkgconf, etc.)
    base-devel cmake ninja gettext rust go

    # Headers / libs (Arch ships headers inside the main packages)
    # NOTE: no `zlib` here. CachyOS replaces it with zlib-ng-compat.
    openssl bzip2 readline sqlite ncurses libxml2 xmlsec libffi xz
    lua luarocks postgresql-libs python libsecret tk

    # Shell & tooling
    zsh unzip tar stow xdg-utils ripgrep fd fontconfig
    xclip wl-clipboard nmap

    # Neovim and CLI tools
    neovim lazygit gdu bottom btop lsd

    # Shader compiler and terminal file manager
    shader-slang
    yazi

    # Yazi supporting tools:
    # File previews, archive handling, search, navigation and image support.
    ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick

    # Simplified command-line help
    tealdeer

    # Nerd font (Fira Code)
    ttf-firacode-nerd

    # Graphics helpers
    xorg-server-xvfb mesa mesa-utils

    # Python tooling
    uv
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo "=== 2. Locale ==="
if ! locale -a | grep -qi '^en_US\.utf-\?8$'; then
    sudo sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
    sudo locale-gen
fi
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf >/dev/null
export LANG=en_US.UTF-8

echo "=== 3. Kitty -> zsh (login shell stays unchanged) ==="
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
mkdir -p "$(dirname "$KITTY_CONF")"
touch "$KITTY_CONF"
if grep -qE '^\s*shell\s' "$KITTY_CONF"; then
    sed -i -E 's|^\s*shell\s.*|shell /usr/bin/zsh|' "$KITTY_CONF"
else
    printf '\n# Launch zsh in kitty only; system login shell is unchanged\nshell /usr/bin/zsh\n' >>"$KITTY_CONF"
fi

echo "=== 4. Font cache ==="
fc-cache -f

echo "=== 5. .zshrc paths ==="
touch "$HOME/.zshrc"
if ! grep -q "NVM_DIR" "$HOME/.zshrc"; then
    cat <<'LINES' >>"$HOME/.zshrc"
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
LINES
fi

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

echo "=== 6. Python 3.12 via uv ==="
uv python install 3.12

# Base venv for editor tooling (pynvim) and requirements.txt.
# Neovim: vim.g.python3_host_prog = vim.fn.expand("~/.venvs/base/bin/python")
BASE_VENV="$HOME/.venvs/base"
[ -d "$BASE_VENV" ] || uv venv "$BASE_VENV" --python 3.12
uv pip install --python "$BASE_VENV/bin/python" pynvim

echo "=== 7. NVM, Node, global npm modules ==="
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node &>/dev/null; then
    nvm install node
    nvm alias default node
fi

for mod in yarn neovim tree-sitter-cli cspell @cspell/cspell-json-reporter; do
    if ! npm ls -g --depth=0 "$mod" >/dev/null 2>&1; then
        npm install -g "$mod"
    else
        echo "npm global '$mod' already present."
    fi
done

echo "=== 8. Dotfiles & stow ==="
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/jkanangila/linux-home-folder.git "$HOME/dotfiles"
fi

mkdir -p "$HOME/.config"

for item in \
    "$HOME/.zshrc" \
    "$HOME/.config/zsh" \
    "$HOME/.tmux.conf" \
    "$HOME/.config/nvim" \
    "$HOME/.config/lazygit" \
    "$HOME/.config/cspell" \
    "$HOME/.gitconfig" \
    "$HOME/requirements.txt"; do
    if [ -e "$item" ] || [ -L "$item" ]; then
        if [ -L "$item" ] && ls -l "$item" | grep -q "dotfiles"; then
            continue
        fi
        mv "$item" "${item}.bak"
    fi
done

cd "$HOME/dotfiles"
for package in lazygit requirements gitconfig nvim tmux zsh cspell; do
    stow --target="$HOME" "$package"
done
cd "$HOME"

if [ -f "$HOME/requirements.txt" ]; then
    uv pip install --python "$BASE_VENV/bin/python" -r "$HOME/requirements.txt"
fi

echo "=== 9. Cargo tools ==="
command -v grip-grab &>/dev/null || cargo install grip-grab

echo "=== 10. Initialize tldr cache ==="
if command -v tldr &>/dev/null; then
    tldr --update || echo "Warning: tldr page update failed; retry with 'tldr --update'."
else
    echo "Warning: tealdeer installed, but the tldr command was not found."
fi

touch "$LOCKFILE"
echo "=== Done. Restart kitty for zsh; log out/in for the locale to take effect. ==="

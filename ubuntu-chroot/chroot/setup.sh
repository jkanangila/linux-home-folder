#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Global execution lockfile path
LOCKFILE="/var/log/chroot_setup_complete.lock"

# Check if the entire script has already run successfully once
if [ -f "$LOCKFILE" ]; then
    echo "========================================="
    echo "Script has already completed successfully once."
    echo "Exiting cleanly based on lockfile: $LOCKFILE"
    echo "========================================="
    exit 0
fi

# Ensure the script is run as root inside the chroot
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root inside the chroot environment." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "========================================="
echo "1 & 2. Installing System Utilities, XDG-utils & Locales"
echo "========================================="
apt-get update

# Array of needed core apt packages
PACKAGES=(
    sudo curl wget git zsh locales build-essential 
    software-properties-common apt-transport-https 
    ca-certificates gnupg tzdata unzip tar pkg-config 
    cmake ninja-build gettext fontconfig stow xdg-utils 
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev 
    libsqlite3-dev libncursesw5-dev xz-utils tk-dev 
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev 
    lua5.4 liblua5.4-dev luarocks cargo ripgrep
    libpq-dev python3-dev gcc
)

# Filter out already installed apt packages
TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing missing packages: ${TO_INSTALL[*]}"
    apt-get install -y "${TO_INSTALL[@]}"
else
    echo "All core system packages are already installed."
fi

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Re-export locale for the remainder of this script execution
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Detect Architecture once
ARCH=$(dpkg --print-architecture)
echo "Detected architecture: $ARCH"

echo "========================================="
echo "3. Installing Neovim Stable"
echo "========================================="
if ! command -v nvim &>/dev/null; then
    if [ "$ARCH" = "amd64" ]; then NV_ARCH="linux64"; else NV_ARCH="linux-arm64"; fi
    curl -LO "https://github.com/neovim/neovim/releases/download/stable/nvim-${NV_ARCH}.tar.gz"
    tar -C /opt -xzf nvim-${NV_ARCH}.tar.gz
    ln -sf /opt/nvim-${NV_ARCH}/bin/nvim /usr/local/bin/nvim
    rm nvim-${NV_ARCH}.tar.gz
else
    echo "Neovim is already installed at $(command -v nvim)."
fi

echo "========================================="
echo "4. Installing Lazygit"
echo "========================================="
if ! command -v lazygit &>/dev/null; then
    if [ "$ARCH" = "amd64" ]; then LG_ARCH="x86_64"; else LG_ARCH="arm64"; fi
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"
    tar xf lazygit.tar.gz lazygit
    install lazygit /usr/local/bin 
    rm -f lazygit.tar.gz lazygit
else
    echo "Lazygit is already installed at $(command -v lazygit)."
fi

echo "========================================="
echo "5. Installing go DiskUsage (gdu)"
echo "========================================="
if ! command -v gdu &>/dev/null; then
    if [ "$ARCH" = "amd64" ]; then GDU_ARCH="x86_64"; else GDU_ARCH="arm64"; fi
    curl -L "https://github.com/dundee/gdu/releases/latest/download/gdu_linux_${GDU_ARCH}.tgz" | tar xz
    chmod +x "gdu_linux_${GDU_ARCH}" 
    mv "gdu_linux_${GDU_ARCH}" /usr/local/bin/gdu
else
    echo "gdu is already installed at $(command -v gdu)."
fi

echo "========================================="
echo "6. Installing bottom (btm)"
echo "========================================="
if ! command -v btm &>/dev/null; then
    if [ "$ARCH" = "amd64" ]; then BTM_ARCH="x86_64-unknown-linux-gnu"; else BTM_ARCH="aarch64-unknown-linux-gnu"; fi
    curl -Lo bottom.tar.gz "https://github.com/ClementTsang/bottom/releases/latest/download/bottom_${BTM_ARCH}.tar.gz"
    tar xf bottom.tar.gz btm
    install btm /usr/local/bin
    rm -f bottom.tar.gz btm
else
    echo "bottom (btm) is already installed at $(command -v btm)."
fi

echo "========================================="
echo "7. Installing Fira Code Mono Nerd Font"
echo "========================================="
if [ ! -d "/usr/share/fonts/truetype/NerdFonts" ] || [ -z "$(ls -A /usr/share/fonts/truetype/NerdFonts)" ]; then
    mkdir -p /usr/share/fonts/truetype/NerdFonts
    curl -Lo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -o FiraCode.zip -d /usr/share/fonts/truetype/NerdFonts
    fc-cache -fv
    rm -f FiraCode.zip
else
    echo "Nerd Fonts directory already populated."
fi

echo "========================================="
echo "8. Creating User 'jkanangila' & Setting Default Shell"
echo "========================================="
if grep -q "^jkanangila:" /etc/passwd; then
    echo "User 'jkanangila' already exists in chroot. Verifying home directory..."
    mkdir -p /home/jkanangila
    chown -R jkanangila:jkanangila /home/jkanangila
else
    echo "Creating user 'jkanangila'..."
    useradd -m -s /usr/bin/zsh jkanangila || true
fi

# Explicit step: Enforce zsh as the shell profile definition
if [ "$(getent passwd jkanangila | cut -d: -f7)" != "/usr/bin/zsh" ]; then
    echo "Setting /usr/bin/zsh as default shell for jkanangila..."
    chsh -s /usr/bin/zsh jkanangila
fi

# Ensure group structures are mapped correctly 
for grp in sudo inet net_raw sdcard_rw everybody; do
    if grep -q "^${grp}:" /etc/group; then
        usermod -aG "$grp" jkanangila 2>/dev/null || true
    fi
done

# Avoid duplicate appends to sudoers if script is rerun
if ! grep -q "jkanangila ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "jkanangila ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

echo "========================================="
echo "Switching Context: Setting up User Environment"
echo "========================================="

# Execute user actions as 'jkanangila' with an interactive-like shell context
sudo -i -u jkanangila bash << 'EOF'
set -e
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "-> 9. Configuring .zshrc paths"
if [ ! -f ~/.zshrc ] || ! grep -q "PYENV_ROOT" ~/.zshrc; then
    cat << 'LINES' >> ~/.zshrc
export LANG=en_US.UTF-8
export PATH="$HOME/.cargo/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
LINES
else
    echo ".zshrc paths are already configured."
fi

echo "-> 10. Installing Pyenv and Python 3.12.3"
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Check if specific pyenv version exists before compiling
if ! pyenv versions --bare | grep -q "3.12.3"; then
    pyenv install -s 3.12.3
fi
pyenv global 3.12.3
pip install --upgrade pip

if ! pip show pynvim >/dev/null 2>&1; then
    pip install pynvim
else
    echo "Python module 'pynvim' is already installed."
fi

echo "-> 11. Installing NVM, Node.js, and Globals"
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install node if missing
if ! command -v node &>/dev/null; then
    nvm install node
    nvm alias default node
fi

# Check and install global npm modules individually
for mod in yarn neovim tree-sitter-cli; do
    if ! command -v "$mod" &>/dev/null && ! npm list -g "$mod" >/dev/null 2>&1; then
        npm install -g "$mod"
    else
        echo "NPM global module '$mod' is already present."
    fi
done

echo "-> 12. Managing Dotfiles and Stow"
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/jkanangila/linux-home-folder.git "$HOME/dotfiles"
fi

mkdir -p "$HOME/.config"

# Safe backups before running GNU Stow
for item in \
    "$HOME/.zshrc" \
    "$HOME/.config/zsh" \
    "$HOME/.tmux.config" \
    "$HOME/.config/nvim" \
    "$HOME/.config/lazygit" \
    "$HOME/.gitconfig"; \
do 
    if [ -e "$item" ] || [ -L "$item" ]; then 
        if [ -L "$item" ] && ls -l "$item" | grep -q "dotfiles"; then
            continue
        fi
        mv "$item" "${item}.bak"
    fi
done

cd "$HOME/dotfiles"
for package in lazygit requirements gitconfig nvim tmux zsh; do
    stow "$package"
done

# Final PIP Requirements run
if [ -f "$HOME/requirements.txt" ]; then 
    pip install -r "$HOME/requirements.txt"
fi

EOF

echo "========================================="
echo "Configuring Termux xdg-open Interoperability"
echo "========================================="
if [ ! -f /usr/local/bin/xdg-open ]; then
cat << 'CHROOT_XDG' > /usr/local/bin/xdg-open
#!/usr/bin/env bash
if command -v termux-open &>/dev/null; then
    termux-open "$1"
elif [ -f /data/data/com.termux/files/usr/bin/termux-open ]; then
    /data/data/com.termux/files/usr/bin/termux-open "$1"
else
    echo "xdg-open fallback: baseline xdg-open execution"
    /usr/bin/xdg-open "$@"
fi
CHROOT_XDG
chmod +x /usr/local/bin/xdg-open
fi

echo "========================================="
echo "Setup complete! Clean up apt cache..."
echo "========================================="
apt-get clean && rm -rf /var/lib/apt/lists/*

# Creation of script lockfile to guarantee safe future passivity
touch "$LOCKFILE"

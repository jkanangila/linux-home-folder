FROM ubuntu:24.04

# Prevent interactive dialogs during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Utilities, C-Compiler, Locales, Lua, Stow and Python/Neovim build dependencies
RUN apt-get update && apt-get install -y \
    sudo curl wget git zsh locales build-essential \
    software-properties-common apt-transport-https \
    ca-certificates gnupg tzdata unzip tar pkg-config \
    cmake ninja-build gettext fontconfig stow \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    lua5.4 liblua5.4-dev luarocks cargo ripgrep \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configure Locales
RUN update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# 3. Compile Neovim 0.11+ from source 
RUN git clone --depth 1 -b master https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install && \
    rm -rf /tmp/neovim

# 4. Install Lazygit
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then LG_ARCH="x86_64"; else LG_ARCH="arm64"; fi && \
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && rm lazygit.tar.gz lazygit

# 5. Install go DiskUsage (gdu)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then GDU_ARCH="x86_64"; else GDU_ARCH="arm64"; fi && \
    curl -L "https://github.com/dundee/gdu/releases/latest/download/gdu_linux_${GDU_ARCH}.tgz" | tar xz && \
    chmod +x "gdu_linux_${GDU_ARCH}" && mv "gdu_linux_${GDU_ARCH}" /usr/local/bin/gdu

# 6. Install bottom (btm)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then BTM_ARCH="x86_64-unknown-linux-gnu"; else BTM_ARCH="aarch64-unknown-linux-gnu"; fi && \
    curl -Lo bottom.tar.gz "https://github.com/ClementTsang/bottom/releases/latest/download/bottom_${BTM_ARCH}.tar.gz" && \
    tar xf bottom.tar.gz btm && \
    install btm /usr/local/bin && rm bottom.tar.gz btm

# 7. Install Fira Code Mono Nerd Font
RUN mkdir -p /usr/share/fonts/truetype/NerdFonts && \
    curl -Lo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip && \
    unzip FiraCode.zip -d /usr/share/fonts/truetype/NerdFonts && \
    fc-cache -fv && rm FiraCode.zip

# 8. Setup user `jkanangila` with passwordless sudo & zsh
RUN useradd -m -s /usr/bin/zsh jkanangila && \
    echo "jkanangila ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ---------------------------------------------------------
# Switch to user for isolated environment setups
# ---------------------------------------------------------
USER jkanangila
WORKDIR /home/jkanangila

# 9. Install Tree-sitter CLI via Cargo
RUN cargo install tree-sitter-cli

# 10. Configure .zshrc paths so everything works inside the chroot
RUN echo 'export LANG=en_US.UTF-8' >> ~/.zshrc && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc

# 11. Install Pyenv and Python 3.12.3
RUN curl https://pyenv.run | bash && \
    export PYENV_ROOT="$HOME/.pyenv" && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install 3.12.3 && \
    pyenv global 3.12.3 && \
    pip install pynvim

# 12. Install NVM, Node Latest, Yarn, and Neovim npm package
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    \. "$NVM_DIR/nvm.sh" && \
    nvm install node && \
    nvm alias default node && \
    npm install -g yarn neovim

# 13. Clone dotfiles, handle safe backups, run Stow, and install PIP requirements
RUN git clone https://github.com/jkanangila/linux-home-folder.git /home/jkanangila/dotfiles && \
    mkdir -p /home/jkanangila/.config && \
    # Safe check and backup phase
    for item in \
        "/home/jkanangila/.zshrc" \
        "/home/jkanangila/.config/zsh" \
        "/home/jkanangila/.tmux.config" \
        "/home/jkanangila/.config/nvim" \
        "/home/jkanangila/.config/lazygit" \
        "/home/jkanangila/.gitconfig"; \
    do \
        if [ -e "$item" ] || [ -L "$item" ]; then \
            mv "$item" "${item}.bak"; \
        fi \
    done && \
    # Stow commands
    cd /home/jkanangila/dotfiles && \
    stow lazygit && \
    stow requirements && \
    stow gitconfig && \
    stow nvim && \
    stow tmux && \
    stow zsh && \
    # Run pip installations from stowed requirements
    if [ -f "/home/jkanangila/requirements.txt" ]; then \
        pip install -r /home/jkanangila/requirements.txt; \
    fi

CMD ["/usr/bin/zsh"]

# Dotfiles & System Configuration

A centralized repository for managing system configurations, dotfiles, and utility scripts using GNU Stow.

## 🚀 Overview

This repository uses **GNU Stow** to manage symlinks for configuration files. 

By linking files directly from this repository to your home directory, changes are automatically mirrored. This approach allows you to maintain a consistent environment across multiple operating systems.

---

## 📂 Repository Structure

The core repository layout separates configuration packages from the helper automation scripts:

```text
~/dotfiles/
├── nvim/                   # Neovim configuration files
├── tmux/                   # Tmux configuration files
├── zsh/                    # Zsh shell settings
└── src/
    └── scripts/            # Helper automation scripts (.sh and .lua)
```

---

## 🛠️ Installation & Setup

### 1. Install GNU Stow
Install the utility using your system package manager.

*   **Ubuntu / Debian:**
    ```bash
    sudo apt update && sudo apt install stow -y
    ```

### 2. Package Organization
GNU Stow expects configurations to be organized by package names. Structure your dotfile subdirectories to mirror your home directory path target:

```text
~/dotfiles/
├── zsh/
│   └── .zshrc
└── nvim/
    └── .config/
        └── nvim/
            └── init.lua
```

### 3. Deploy Configurations
Navigate to your dotfiles directory and stow the desired packages to generate the symlinks in your home (`~`) directory:

```bash
cd ~/dotfiles
stow zsh
stow nvim
stow tmux
```

---

## ⚙️ Automation Scripts (`src/scripts/`)

The repository includes standalone scripts to quickly configure development tools, environments, and secure connections.

### Running the Scripts
Execute the scripts directly using your system's interpreter from within the scripts folder:

```bash
cd ~/dotfiles/src/scripts

# Run a Shell script
sh install-zsh.sh

# Run a Lua script
lua install_font.lua
```

### Shell Scripts (`.sh`)
*   `install-zsh.sh` – Installs and configures the Zsh shell environment.
*   `install-nvm.sh` – Sets up Node Version Manager (NVM).
*   `nvm-install-node.sh` – Automates downloading and activating Node.js via NVM.
*   `install-pyenv.sh` – Sets up Pyenv for managing isolated Python versions.
*   `setup-ssh-aws-codecommit.sh` – Configures SSH credentials for AWS CodeCommit.

### Lua Core Scripts (`.lua`)
*   `detect_os.lua` – Utility script to identify the host operating system type.
*   `install_font.lua` – Downloads and installs developer-focused fonts.
*   `setup-github-ssh.lua` – Configures SSH keys and links them to GitHub profiles.

### Termux Environment Scripts (`.lua`)
*   `install_btm_in_termux.lua` – Installs the Bottom (BTM) system monitor in Termux.
*   `install_gdu_in_termux.lua` – Installs the GDU disk usage analyzer in Termux.
*   `install_lazygit_in_termux.lua` – Sets up the Lazygit TUI engine inside Termux.
*   `install_luarocks_in_termux.lua` – Deploys Luarocks package manager in Termux.

---

## 💻 New Machine Deployment

Replicate your entire environment on a new computer with two commands:

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles && stow zsh nvim tmux
```


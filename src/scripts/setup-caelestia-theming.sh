#!/usr/bin/env bash
#
# Configure Caelestia's optional:
#   1. Papirus folder color theming
#   2. Chromium-based browser policy theming
#
# Target: CachyOS / Arch Linux
# Shell: Bash
#
# Run as your normal user, NOT with sudo.

set -Eeuo pipefail
IFS=$'\n\t'
umask 077

readonly PAPIRUS_SUDOERS="/etc/sudoers.d/papirus-folders"
readonly BROWSER_SUDOERS="/etc/sudoers.d/caelestia-chromium"

readonly -a BROWSER_DIRS=(
    "/etc/chromium/policies/managed"
    "/etc/brave/policies/managed"
    "/etc/opt/chrome/policies/managed"
)

log() {
    printf '[INFO] %s\n' "$*"
}

warn() {
    printf '[WARN] %s\n' "$*" >&2
}

die() {
    printf '[ERROR] %s\n' "$*" >&2
    exit 1
}

# Require execution as a regular user.
if [[ $EUID -eq 0 ]]; then
    die "Run this script as your normal user, without sudo."
fi

readonly USER_NAME="${USER:?USER is not set}"

for cmd in sudo visudo install mktemp chmod; do
    command -v "$cmd" >/dev/null 2>&1 ||
        die "Required command not found: $cmd"
done

# Resolve executable paths for sudoers rules.
resolve_command() {
    command -v "$1" ||
        die "Required executable not found: $1"
}

readonly MKDIR_BIN="$(resolve_command mkdir)"
readonly TEE_BIN="$(resolve_command tee)"

readonly PAPIRUS_BIN="$(command -v papirus-folders || true)"

# Require sudo authentication for setup operations.
sudo -v

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Install a sudoers file only after validating its syntax.
install_sudoers_file() {
    local source_file="$1"
    local destination="$2"

    chmod 0440 "$source_file"

    if ! visudo -cf "$source_file"; then
        die "Invalid sudoers syntax: $destination"
    fi

    sudo install -o root -g root -m 0440 \
        "$source_file" "$destination"

    # Validate the installed file as well.
    sudo visudo -cf "$destination" ||
        die "Installed sudoers file is invalid: $destination"

    log "Installed $destination"
}

# ----------------------------------------------------------
# 1. Papirus folder color theming
# ----------------------------------------------------------

if [[ -n "$PAPIRUS_BIN" ]]; then
    log "Configuring Papirus folder color theming."

    PAPIRUS_RULE="$TMP_DIR/papirus-folders"

    printf '%s ALL=(root) NOPASSWD: %s\n' \
        "$USER_NAME" "$PAPIRUS_BIN" > "$PAPIRUS_RULE"

    install_sudoers_file "$PAPIRUS_RULE" "$PAPIRUS_SUDOERS"
else
    warn "papirus-folders is not installed; skipping Papirus theming."
    warn "Install papirus-folders and rerun this script to enable it."
fi

# ----------------------------------------------------------
# 2. Chromium-based browser policy theming
# ----------------------------------------------------------

log "Configuring managed browser policy permissions."

BROWSER_RULE="$TMP_DIR/caelestia-chromium"
: > "$BROWSER_RULE"

for dir in "${BROWSER_DIRS[@]}"; do
    policy_file="${dir}/caelestia.json"

    # Allow creating only the specific managed policy directory.
    printf '%s ALL=(root) NOPASSWD: %s -p %s\n' \
        "$USER_NAME" "$MKDIR_BIN" "$dir" >> "$BROWSER_RULE"

    # Allow writing only Caelestia's specific policy file.
    printf '%s ALL=(root) NOPASSWD: %s %s\n' \
        "$USER_NAME" "$TEE_BIN" "$policy_file" >> "$BROWSER_RULE"
done

install_sudoers_file "$BROWSER_RULE" "$BROWSER_SUDOERS"

# ----------------------------------------------------------
# 3. Summary
# ----------------------------------------------------------

printf '\n'
log "Caelestia theming permissions have been configured."
printf '\n'

printf 'Papirus executable: %s\n' \
    "${PAPIRUS_BIN:-not installed}"

printf '\nBrowser policy directories:\n'
for dir in "${BROWSER_DIRS[@]}"; do
    printf '  %s\n' "$dir"
done

printf '\nSudoers files:\n'
printf '  %s\n' "$PAPIRUS_SUDOERS"
printf '  %s\n' "$BROWSER_SUDOERS"

printf '\n'
log "Review granted permissions with: sudo -l"
log "The Caelestia CLI must still be configured to use these integrations."



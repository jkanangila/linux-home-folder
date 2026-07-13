
#!/usr/bin/env bash

# Configuration
REMOTE_HOST="127.0.0.1" # Change to Termux IP if syncing across different devices
REMOTE_PORT=8377
LOCAL_PORT=8378
CLIP_FILE="/tmp/system_clipboard"
CACHE_FILE="/tmp/clip_cache"
touch "$CLIP_FILE" "$CACHE_FILE"

# 1. Listener: Receives data from Termux and updates the chroot clipboard file
(
    while true; do
        ncat -l -p "$LOCAL_PORT" > "$CLIP_FILE.incoming" 2>/dev/null
        if ! cmp -s "$CLIP_FILE.incoming" "$CACHE_FILE"; then
            cp "$CLIP_FILE.incoming" "$CACHE_FILE"
            cp "$CLIP_FILE.incoming" "$CLIP_FILE"
        fi
    done
) >/dev/null 2>&1 &

# 2. Watcher: Watches the chroot clipboard file and sends changes to Termux
(
    while true; do
        if ! cmp -s "$CLIP_FILE" "$CACHE_FILE"; then
            cp "$CLIP_FILE" "$CACHE_FILE"
            ncat --send-only "$REMOTE_HOST" "$REMOTE_PORT" < "$CLIP_FILE" 2>/dev/null
        fi
        sleep 1
    done
) >/dev/null 2>&1 &


#!/usr/bin/env bash

# Configuration
REMOTE_HOST="127.0.0.1" # Change to target IP if syncing across different devices over LAN/Internet
REMOTE_PORT=8378
LOCAL_PORT=8377
CACHE_FILE="${TMPDIR:-/tmp}/clip_cache"
touch "$CACHE_FILE"

# 1. Listener: Receives data from Ubuntu and sets Termux clipboard
(
    while true; do
        ncat -l -p "$LOCAL_PORT" > "$CACHE_FILE.incoming" 2>/dev/null
        if ! cmp -s "$CACHE_FILE.incoming" "$CACHE_FILE"; then
            cp "$CACHE_FILE.incoming" "$CACHE_FILE"
            cat "$CACHE_FILE" | termux-clipboard-set
        fi
    done
) >/dev/null 2>&1 &

# 2. Watcher: Polls Termux clipboard and sends changes to Ubuntu
(
    while true; do
        termux-clipboard-get > "$CACHE_FILE.current" 2>/dev/null
        if ! cmp -s "$CACHE_FILE.current" "$CACHE_FILE"; then
            cp "$CACHE_FILE.current" "$CACHE_FILE"
            ncat --send-only "$REMOTE_HOST" "$REMOTE_PORT" < "$CACHE_FILE" 2>/dev/null
        fi
        sleep 1
    done
) >/dev/null 2>&1 &

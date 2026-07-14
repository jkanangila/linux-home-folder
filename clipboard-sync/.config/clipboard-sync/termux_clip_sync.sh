#!/usr/bin/env bash

REMOTE_HOST="127.0.0.1"
REMOTE_PORT=8378
LOCAL_PORT=8377
CACHE_FILE="${TMPDIR:-/tmp}/clip_cache"
touch "$CACHE_FILE"

# 1. Listener: Receives data from Ubuntu and sets Termux clipboard
(
    # ncat -lk stays open continuously listening for new packets
    ncat -lk -p "$LOCAL_PORT" 2>/dev/null | while read -r line; do
        # Process data when incoming transmission drops or finishes
        echo "$line" >> "$CACHE_FILE.incoming"
    done

    # Watch loop acting on the received buffer
    while true; do
        if [[ -f "$CACHE_FILE.incoming" ]]; then
            if ! cmp -s "$CACHE_FILE.incoming" "$CACHE_FILE"; then
                cp "$CACHE_FILE.incoming" "$CACHE_FILE"
                cat "$CACHE_FILE" | termux-clipboard-set
            fi
            rm -f "$CACHE_FILE.incoming"
        fi
        sleep 0.5
    done
) >/dev/null 2>&1 &

# 2. Watcher: Polls Termux clipboard and sends changes to Ubuntu
(
    while true; do
        termux-clipboard-get > "$CACHE_FILE.current" 2>/dev/null
        if [[ -s "$CACHE_FILE.current" ]] && ! cmp -s "$CACHE_FILE.current" "$CACHE_FILE"; then
            cp "$CACHE_FILE.current" "$CACHE_FILE"
            ncat --send-only "$REMOTE_HOST" "$REMOTE_PORT" < "$CACHE_FILE" 2>/dev/null
        fi
        sleep 1
    done
) >/dev/null 2>&1 &

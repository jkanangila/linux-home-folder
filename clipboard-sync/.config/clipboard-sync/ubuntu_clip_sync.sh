#!/usr/bin/env bash

export DISPLAY=:99.0
REMOTE_HOST="127.0.0.1"
REMOTE_PORT=8377
LOCAL_PORT=8378
CLIP_FILE="/tmp/system_clipboard"
CACHE_FILE="/tmp/clip_cache"
touch "$CLIP_FILE" "$CACHE_FILE"

# 1. Listener: Receives data from Termux and updates virtual X11 clipboard
(
    ncat -lk -p "$LOCAL_PORT" 2>/dev/null | while read -r line; do
        echo "$line" >> "$CLIP_FILE.incoming"
    done

    while true; do
        if [[ -f "$CLIP_FILE.incoming" ]]; then
            if ! cmp -s "$CLIP_FILE.incoming" "$CACHE_FILE"; then
                cp "$CLIP_FILE.incoming" "$CACHE_FILE"
                cp "$CLIP_FILE.incoming" "$CLIP_FILE"
                xclip -selection clipboard "$CLIP_FILE" 2>/dev/null
            fi
            rm -f "$CLIP_FILE.incoming"
        fi
        sleep 0.5
    done
) >/dev/null 2>&1 &

# 2. Watcher: Watches the virtual xclip clipboard and sends changes to Termux
(
    while true; do
        # Extract data from our headless xclip clipboard buffer
        xclip -selection clipboard -o > "$CLIP_FILE" 2>/dev/null
        
        if [[ -s "$CLIP_FILE" ]] && ! cmp -s "$CLIP_FILE" "$CACHE_FILE"; then
            cp "$CLIP_FILE" "$CACHE_FILE"
            ncat --send-only "$REMOTE_HOST" "$REMOTE_PORT" < "$CLIP_FILE" 2>/dev/null
        fi
        sleep 1
    done
) >/dev/null 2>&1 &

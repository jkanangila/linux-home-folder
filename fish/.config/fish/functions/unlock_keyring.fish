# ==============================================================================
# unlock_keyring            Unlock an existing GNOME login keyring
# unlock_keyring --create   Create the login keyring (first time only)
#
# Prompts for the keyring password silently, unlocks (or creates) the keyring,
# exports any environment variables the daemon reports, and clears the password
# from memory. Does nothing if gnome-keyring-daemon isn't installed.
# ==============================================================================
function unlock_keyring --description 'Unlock (or --create) the GNOME login keyring'
    # Bail out quietly if the daemon isn't available
    type -q gnome-keyring-daemon; or return 0
    argparse c/create -- $argv; or return 1

    set -l data_home $HOME/.local/share
    set -q XDG_DATA_HOME; and set data_home $XDG_DATA_HOME
    set -l keyring_file $data_home/keyrings/login.keyring
    set -l out

    if set -q _flag_create
        read -l -s -P "New keyring password: " pw; echo
        read -l -s -P "Confirm password: " pw2; echo
        if test -z "$pw"; or test "$pw" != "$pw2"
            echo "Password empty or not matching; keyring not created." >&2
            return 1
        end

        # Login mode creates the login keyring from the stdin password,
        # so any running daemon has to be restarted first
        pkill -x gnome-keyring-d 2>/dev/null
        set out (printf '%s' "$pw" | gnome-keyring-daemon --daemonize --login --components=secrets 2>/dev/null)
    else
        if not test -f $keyring_file
            echo "No login keyring found. Run: unlock_keyring --create" >&2
            return 1
        end
        read -l -s -P "Keyring password: " pw; echo
        set out (printf '%s' "$pw" | gnome-keyring-daemon --unlock --components=secrets 2>/dev/null)
        set -a out (gnome-keyring-daemon --start --components=secrets 2>/dev/null)
    end
    set -e pw pw2

    # Export only VAR=value lines, ignore any other daemon output
    for line in $out
        if string match -qr '^[A-Z_]+=' -- $line
            set -l kv (string split -m1 = -- $line)
            set -gx $kv[1] $kv[2]
        end
    end
    return 0
end

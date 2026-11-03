# yazi wrapper: quit with `q` to cd into the last directory, `Q` to quit without cd.
function y --description 'yazi, but cd to the last directory on quit'
    type -q yazi; or return

    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end

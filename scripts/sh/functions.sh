function isinstalled() {
    PACKAGE_NAME=$(echo $1 | cut -d "/" -f 2)
    TEST=$(which PACKAGE_NAME)

    if [[ ! -z $TEST ]]; then
        true
    else
        false
    fi
}

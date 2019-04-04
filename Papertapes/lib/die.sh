# die.sh - source this file

warn() {
    echo "$@" 1>&2
}

die() {
    warn "$@"
    exit 2
}

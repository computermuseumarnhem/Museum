#!/bin/sh

export bin="$( dirname "$( readlink -f "$0" )" )"
export lib="$bin/../lib"

. "$lib/die.sh"

[ -n "$1" ] || die "Usage: ppt <command> <arguments>"

[ -x "$bin/$1.sh" ] && exec "$bin/$1.sh"
[ -x "$bin/$1.py" ] && exec "$bin/$1.py"
[ -x "$bin/$1.pl" ] && exec "$bin/$1.pl"

die "$1.{sh,py,pl} not found."


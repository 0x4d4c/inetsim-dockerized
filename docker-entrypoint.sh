#!/bin/sh
set -eu

if [ "$1" = 'inetsim' ]; then
    generate-inetsim-config.sh
fi

exec "$@"

#!/bin/sh
set -eu

if [ "$1" = 'inetsim' ]; then
    ./setup.sh
    generate-inetsim-config.sh
    populate-data-directory.sh
fi

exec "$@"

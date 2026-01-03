#!/usr/bin/env bash

set -ueo pipefail

cd "$(dirname "$0")"

if [ -L config.kdl ]; then
    # normal niri config, we need to edit the scale
    mv config.kdl config.kdl.old
    cp config.kdl.old config.kdl
    chmod 644 config.kdl
    sed -i "s/scale .*/scale 1/" config.kdl
else
    # scale 1 config, revert to normal
    rm config.kdl
    mv config.kdl.old config.kdl
fi

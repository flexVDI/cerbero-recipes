#!/bin/sh
SRC_DIR="$(dirname "$(readlink -f $0)")"
CONFIG_DIR="$SRC_DIR"/cerbero/config

[ -d "$CONFIG_DIR" ] || {
    cd "$SRC_DIR"
    git submodule init && git submodule update
} || {
    echo Downloading the Cerbero submodule failed
    exit 1
}

cd "$CONFIG_DIR"
../cerbero-uninstalled -c ../../flexvdi.cbc "$@"


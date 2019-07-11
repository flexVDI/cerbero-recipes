#!/bin/sh
SRC_DIR=$(python -c 'import os,sys; print(os.path.dirname(os.path.realpath(sys.argv[1])))' "$0")
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


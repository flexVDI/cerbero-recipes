#!/bin/sh
cd $(dirname "$0")/cerbero/config
../cerbero-uninstalled -c ../../flexvdi.cbc "$@"


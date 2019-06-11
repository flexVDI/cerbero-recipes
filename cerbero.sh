#!/bin/sh
cd $(dirname "$(readlink -f $0)")/cerbero/config
../cerbero-uninstalled -c ../../flexvdi.cbc "$@"


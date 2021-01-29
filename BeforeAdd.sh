#!/usr/bin/env bash
# BADD V2
# From https://github.com/YuZJLab/LinuxMiniPrograms, commit  19ec030cdc2dee900577e4df620b2b3b6bfb5a2d, branch BSD
set -evu
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
dos2unix $(find . 2> /dev/null | xargs)

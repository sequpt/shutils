#!/bin/sh
# SPDX-License-Identifier: 0BSD
################################################################################
## @file
## @date 21.01.2024
## @license
## BSD Zero Clause License
##
## Copyright (c) 2024 by the shutils authors
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
## REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
## AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
## INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
## LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
## OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
## PERFORMANCE OF THIS SOFTWARE.
##
## @brief
## Tests for the `xdg_basedir.sh` script
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
tests_xdg_basedir() (
    unset XDG_CACHE_HOME
    unset XDG_CONFIG_DIRS
    unset XDG_CONFIG_HOME
    unset XDG_DATA_DIRS
    unset XDG_DATA_HOME
    unset XDG_STATE_HOME

    . "../lib/xdg_basedir.sh"

    [ "$XDG_CACHE_HOME"  != "$HOME/.cache" ]                  && return 1
    [ "$XDG_CONFIG_DIRS" != "/etc/xdg" ]                      && return 1
    [ "$XDG_CONFIG_HOME" != "$HOME/.config" ]                 && return 1
    [ "$XDG_DATA_DIRS"   != "/usr/local/share/:/usr/share/" ] && return 1
    [ "$XDG_DATA_HOME"   != "$HOME/.local/share" ]            && return 1
    [ "$XDG_STATE_HOME"  != "$HOME/.local/state" ]            && return 1

    return 0
)

#!/bin/sh
# SPDX-License-Identifier: 0BSD
################################################################################
## @file
## @date 27.01.2024
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
## Tests for the `xdg_basedir_ext.sh` script
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
tests_xdg_basedir_ext() (
    unset XDG_APPLICATIONS_HOME
    unset XDG_APP_HOME
    unset XDG_BACKUP_HOME
    unset XDG_BIN_HOME
    unset XDG_BUILD_HOME
    unset XDG_FONTS_HOME
    unset XDG_ICONS_HOME
    unset XDG_INCLUDE_HOME
    unset XDG_LIB_HOME
    unset XDG_LOCAL_HOME
    unset XDG_LOG_HOME
    unset XDG_MAN_HOME
    unset XDG_MIME_HOME
    unset XDG_SRC_HOME

    . "$1/xdg_basedir_ext.sh"

    [ "$XDG_LOCAL_HOME"        != "$(dirname "$XDG_DATA_HOME")" ] && return 1
    [ "$XDG_APP_HOME"          != "$XDG_LOCAL_HOME/app" ]         && return 1
    [ "$XDG_BACKUP_HOME"       != "$XDG_LOCAL_HOME/backup" ]      && return 1
    [ "$XDG_BIN_HOME"          != "$XDG_LOCAL_HOME/bin" ]         && return 1
    [ "$XDG_BUILD_HOME"        != "$XDG_LOCAL_HOME/build" ]       && return 1
    [ "$XDG_INCLUDE_HOME"      != "$XDG_LOCAL_HOME/include" ]     && return 1
    [ "$XDG_LIB_HOME"          != "$XDG_LOCAL_HOME/lib" ]         && return 1
    [ "$XDG_SRC_HOME"          != "$XDG_LOCAL_HOME/src" ]         && return 1
    [ "$XDG_APPLICATIONS_HOME" != "$XDG_DATA_HOME/applications" ] && return 1
    [ "$XDG_FONTS_HOME"        != "$XDG_DATA_HOME/fonts" ]        && return 1
    [ "$XDG_ICONS_HOME"        != "$XDG_DATA_HOME/icons" ]        && return 1
    [ "$XDG_MAN_HOME"          != "$XDG_DATA_HOME/man" ]          && return 1
    [ "$XDG_MIME_HOME"         != "$XDG_DATA_HOME/mime" ]         && return 1
    [ "$XDG_LOG_HOME"          != "$XDG_STATE_HOME/log" ]         && return 1

    return 0
)

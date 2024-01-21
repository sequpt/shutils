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
## Set and export environment variables from the XDG Base Directory
## Specification.
##
## @details
## The `XDG_*` variables are set to the default values suggested by the
## specification if they are either empty or not set.
##
## The specification doesn't suggest a default value for `XDG_RUNTIME_DIR`,
## therefore that variable is not given one. Although pam_systemd should set it
## to `/run/user/$UID`.
##
## @see
## - https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
## - https://www.freedesktop.org/software/systemd/man/latest/pam_systemd.html
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export XDG_CACHE_HOME
XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-"/etc/xdg"}"
export XDG_CONFIG_DIRS
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_CONFIG_HOME
XDG_DATA_DIRS="${XDG_DATA_DIRS:-"/usr/local/share/:/usr/share/"}"
export XDG_DATA_DIRS
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_DATA_HOME
XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME/.local/state"}"
export XDG_STATE_HOME

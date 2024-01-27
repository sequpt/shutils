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
## Set and export environment variables extending the XDG Base Directory
## Specification to include many subfolders of `~/.local`.
##
## @details
## All these variables are set according to the values of the standard XDG ones.
##
## The standard doesn't define the location of `~/.local`, only some of its
## subfolders, therefore it's defined here as the parent folder of
## `XDG_DATA_HOME`.
##
## As of the date of 27.01.2024, the following non-standard variables were found
## in nature:
## - XDG_LOCAL_HOME
## - XDG_APP_HOME
## - XDG_BIN_HOME
## - XDG_LIB_HOME
## - XDG_LOG_HOME
##
## @see
## - https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
_xdg_data_home="${XDG_DATA_HOME:-"$HOME/.local/share"}"
_xdg_state_home="${XDG_STATE_HOME:-"$HOME/.local/state"}"
# Subfolders of `XDG_LOCAL_HOME`
XDG_LOCAL_HOME="${XDG_LOCAL_HOME:-"$(dirname "$_xdg_data_home")"}"
export XDG_LOCAL_HOME
XDG_APP_HOME="${XDG_APP_HOME:-"$XDG_LOCAL_HOME/app"}"
export XDG_APP_HOME
XDG_BACKUP_HOME="${XDG_BACKUP_HOME:-"$XDG_LOCAL_HOME/backup"}"
export XDG_BACKUP_HOME
XDG_BIN_HOME="${XDG_BIN_HOME:-"$XDG_LOCAL_HOME/bin"}"
export XDG_BIN_HOME
XDG_BUILD_HOME="${XDG_BUILD_HOME:-"$XDG_LOCAL_HOME/build"}"
export XDG_BUILD_HOME
XDG_INCLUDE_HOME="${XDG_INCLUDE_HOME:-"$XDG_LOCAL_HOME/include"}"
export XDG_INCLUDE_HOME
XDG_LIB_HOME="${XDG_LIB_HOME:-"$XDG_LOCAL_HOME/lib"}"
export XDG_LIB_HOME
XDG_SRC_HOME="${XDG_SRC_HOME:-"$XDG_LOCAL_HOME/src"}"
export XDG_SRC_HOME
# Subfolders of `XDG_DATA_HOME`
XDG_APPLICATIONS_HOME="${XDG_APPLICATIONS_HOME:-"$_xdg_data_home/applications"}"
export XDG_APPLICATIONS_HOME
XDG_FONTS_HOME="${XDG_FONTS_HOME:-"$_xdg_data_home/fonts"}"
export XDG_FONTS_HOME
XDG_ICONS_HOME="${XDG_ICONS_HOME:-"$_xdg_data_home/icons"}"
export XDG_ICONS_HOME
XDG_MAN_HOME="${XDG_MAN_HOME:-"$_xdg_data_home/man"}"
export XDG_MAN_HOME
XDG_MIME_HOME="${XDG_MIME_HOME:-"$_xdg_data_home/mime"}"
export XDG_MIME_HOME
# Subfolders of `XDG_STATE_HOME`
XDG_LOG_HOME="${XDG_LOG_HOME:-"$_xdg_state_home/log"}"
export XDG_LOG_HOME

unset _xdg_data_home _xdg_state_home

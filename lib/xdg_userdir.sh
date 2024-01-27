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
## Set and export environment variables defined by the `xdg-user-dirs` tool.
##
## @see
## - https://www.freedesktop.org/wiki/Software/xdg-user-dirs/
## - https://wiki.archlinux.org/title/XDG_user_directories
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-"$HOME/Desktop"}"
export XDG_DESKTOP_DIR
XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-"$HOME/Documents"}"
export XDG_DOCUMENTS_DIR
XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-"$HOME/Downloads"}"
export XDG_DOWNLOAD_DIR
XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-"$HOME/Music"}"
export XDG_MUSIC_DIR
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-"$HOME/Pictures"}"
export XDG_PICTURES_DIR
XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-"$HOME/Public"}"
export XDG_PUBLICSHARE_DIR
XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-"$HOME/Templates"}"
export XDG_TEMPLATES_DIR
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-"$HOME/Videos"}"
export XDG_VIDEOS_DIR

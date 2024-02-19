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
## Tests for the `xdg_userdir.sh` script
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
main() (
  unset XDG_DESKTOP_DIR
  unset XDG_DOCUMENTS_DIR
  unset XDG_DOWNLOAD_DIR
  unset XDG_MUSIC_DIR
  unset XDG_PICTURES_DIR
  unset XDG_PUBLICSHARE_DIR
  unset XDG_TEMPLATES_DIR
  unset XDG_VIDEOS_DIR

  . "$1/xdg_userdir.sh"

  [ "$XDG_DESKTOP_DIR"     != "$HOME/Desktop" ]   && return 1
  [ "$XDG_DOCUMENTS_DIR"   != "$HOME/Documents" ] && return 1
  [ "$XDG_DOWNLOAD_DIR"    != "$HOME/Downloads" ] && return 1
  [ "$XDG_MUSIC_DIR"       != "$HOME/Music" ]     && return 1
  [ "$XDG_PICTURES_DIR"    != "$HOME/Pictures" ]  && return 1
  [ "$XDG_PUBLICSHARE_DIR" != "$HOME/Public" ]    && return 1
  [ "$XDG_TEMPLATES_DIR"   != "$HOME/Templates" ] && return 1
  [ "$XDG_VIDEOS_DIR"      != "$HOME/Videos" ]    && return 1

  return 0
)

main "$@"

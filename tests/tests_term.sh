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
## Tests for the `term.sh` script
################################################################################
# Triggered by `return 0` at then end of `term.sh` when it's sourced
# shellcheck disable=SC2317 # "Command appears to be unreachable"

# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
tests_dumb_terminal() (
  TERM="dumb"
  . "$1/term.sh"

  [ "$t_has_blink" = true ] && return 1
  [ "$t_has_bold" = true ] && return 1
  [ "$t_has_dim" = true ] && return 1
  [ "$t_has_invis" = true ] && return 1
  [ "$t_has_op" = true ] && return 1
  [ "$t_has_rev" = true ] && return 1
  [ "$t_has_ritm" = true ] && return 1
  [ "$t_has_rmso" = true ] && return 1
  [ "$t_has_rmul" = true ] && return 1
  [ "$t_has_rmxx" = true ] && return 1
  [ "$t_has_setab" = true ] && return 1
  [ "$t_has_setaf" = true ] && return 1
  [ "$t_has_sgr0" = true ] && return 1
  [ "$t_has_sitm" = true ] && return 1
  [ "$t_has_smso" = true ] && return 1
  [ "$t_has_smul" = true ] && return 1
  [ "$t_has_smxx" = true ] && return 1

  return 0
)

tests_xterm_color_terminal() (
  TERM="xterm-color"
  . "$1/term.sh"

  [ "$t_has_blink" = true ] && return 1
  [ "$t_has_bold" = false ] && return 1
  [ "$t_has_dim" = true ] && return 1
  [ "$t_has_invis" = true ] && return 1
  [ "$t_has_op" = false ] && return 1
  [ "$t_has_rev" = false ] && return 1
  [ "$t_has_ritm" = true ] && return 1
  [ "$t_has_rmso" = false ] && return 1
  [ "$t_has_rmul" = false ] && return 1
  [ "$t_has_rmxx" = true ] && return 1
  [ "$t_has_setab" = false ] && return 1
  [ "$t_has_setaf" = false ] && return 1
  [ "$t_has_sgr0" = false ] && return 1
  [ "$t_has_sitm" = true ] && return 1
  [ "$t_has_smso" = false ] && return 1
  [ "$t_has_smul" = false ] && return 1
  [ "$t_has_smxx" = true ] && return 1

  return 0
)

tests_capabilities() (
  TERM="$1"
  . "$2/term.sh"

  [ "$t_has_blink" = false ] && return 1
  [ "$t_has_bold" = false ] && return 1
  [ "$t_has_dim" = false ] && return 1
  [ "$t_has_invis" = false ] && return 1
  [ "$t_has_op" = false ] && return 1
  [ "$t_has_rev" = false ] && return 1
  [ "$t_has_ritm" = false ] && return 1
  [ "$t_has_rmso" = false ] && return 1
  [ "$t_has_rmul" = false ] && return 1
  [ "$t_has_rmxx" = false ] && return 1
  [ "$t_has_setab" = false ] && return 1
  [ "$t_has_setaf" = false ] && return 1
  [ "$t_has_sgr0" = false ] && return 1
  [ "$t_has_sitm" = false ] && return 1
  [ "$t_has_smso" = false ] && return 1
  [ "$t_has_smul" = false ] && return 1
  [ "$t_has_smxx" = false ] && return 1

  return 0
)

main() (
  ! tests_dumb_terminal "$1" && return 1
  ! tests_xterm_color_terminal "$1" && return 1
  ! tests_capabilities "xterm" "$1" && return
  ! tests_capabilities "xterm-256color" "$1" && return 1

  return 0
)

main "$@"

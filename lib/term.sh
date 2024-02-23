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
## Provide functions for terminal colors and formatting
##
## @see
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
## - https://en.wikipedia.org/wiki/ANSI_escape_code
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
## Terminal capabilities
##
## @see
## - https://invisible-island.net/ncurses/man/terminfo.5.html
## - https://invisible-island.net/ncurses/man/tput.1.html
t_has_blink=false; tput blink > "/dev/null" 2>&1 && t_has_blink=true
t_has_bold=false;  tput bold  > "/dev/null" 2>&1 && t_has_bold=true
t_has_dim=false;   tput dim   > "/dev/null" 2>&1 && t_has_dim=true
t_has_invis=false; tput invis > "/dev/null" 2>&1 && t_has_invis=true
t_has_op=false;    tput op    > "/dev/null" 2>&1 && t_has_op=true
t_has_rev=false;   tput rev   > "/dev/null" 2>&1 && t_has_rev=true
t_has_ritm=false;  tput ritm  > "/dev/null" 2>&1 && t_has_ritm=true
t_has_rmso=false;  tput rmso  > "/dev/null" 2>&1 && t_has_rmso=true
t_has_rmul=false;  tput rmul  > "/dev/null" 2>&1 && t_has_rmul=true
t_has_rmxx=false;  tput rmxx  > "/dev/null" 2>&1 && t_has_rmxx=true
t_has_setab=false; tput setab > "/dev/null" 2>&1 && t_has_setab=true
t_has_setaf=false; tput setaf > "/dev/null" 2>&1 && t_has_setaf=true
t_has_sgr0=false;  tput sgr0  > "/dev/null" 2>&1 && t_has_sgr0=true
t_has_sitm=false;  tput sitm  > "/dev/null" 2>&1 && t_has_sitm=true
t_has_smso=false;  tput smso  > "/dev/null" 2>&1 && t_has_smso=true
t_has_smul=false;  tput smul  > "/dev/null" 2>&1 && t_has_smul=true
t_has_smxx=false;  tput smxx  > "/dev/null" 2>&1 && t_has_smxx=true

## ASCII code for escape character
##
## Setting `t_esc` to the output of `printf "\033"` instead of only `\033`
## allows to use the `%s` format specifier instead of `%b` when used with
## `printf`.
##
## @see
## - https://en.wikipedia.org/wiki/Escape_character#ASCII_escape_character
t_esc="$(printf "\033")"

## CSI (Control Sequence Introducer)
##
## @see
## - https://en.wikipedia.org/wiki/ANSI_escape_code#CSIsection
t_csi="${t_esc}["

## SGR (Select Graphic Rendition)
##
## @see
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Pm-m.1CA7
## - https://en.wikipedia.org/wiki/ANSI_escape_code#SGR
t_clr=; $t_has_sgr0  && t_clr="$(tput sgr0)"             # Reset all            CSI 0 m
# Set mode
t_bold=;   $t_has_bold  && t_bold="$(tput bold)"         # Bold                 CSI 1 m
t_dim=;    $t_has_dim   && t_dim="$(tput dim)"           # Dim                  CSI 2 m
t_it=;     $t_has_sitm  && t_it="$(tput sitm)"           # Italic               CSI 3 m
t_ul=;     $t_has_smul  && t_ul="$(tput smul)"           # Underline            CSI 4 m
t_blink=;  $t_has_blink && t_blink="$(tput blink)"       # Blink                CSI 5 m
t_rev=;    $t_has_rev   && t_rev="$(tput rev)"           # Reverse              CSI 7 m
t_so=;     $t_has_smso  && t_so="$(tput smso)"           # Standout             CSI 7 m
t_invis=;  $t_has_invis && t_invis="$(tput invis)"       # Invisible            CIS 8 m
t_strike=; $t_has_smxx  && t_strike="$(tput smxx)"       # Strike               CSI 9 m
t_ul2="${t_csi}21m"                                      # Underline x2         CSI 21 m
# Remove mode
t_rm_bold=;   $t_has_bold  && t_rm_bold="${t_csi}22m"    # Not Bold             CSI 22 m
t_rm_dim=;    $t_has_dim   && t_rm_dim="${t_csi}22m"     # Not Dim              CSI 22 m
t_rm_it=;     $t_has_ritm  && t_rm_it="$(tput ritm)"     # Not Italic           CSI 23 m
t_rm_ul=;     $t_has_rmul  && t_rm_ul="$(tput rmul)"     # Not Underline        CSI 24 m
t_rm_ul2=;    $t_has_rmul  && t_rm_ul2="$(tput rmul)"    # Not Underline x2     CSI 24 m
t_rm_blink=;  $t_has_blink && t_rm_blink="${t_csi}25m"   # Not Blink            CSI 25 m
t_rm_so=;     $t_has_rmso  && t_rm_so="$(tput rmso)"     # Not Standout         CSI 27 m
t_rm_invis=;  $t_has_invis && t_rm_invis="${t_csi}28m"   # Not Invisible        CSI 28 m
t_rm_strike=; $t_has_rmxx  && t_rm_strike="$(tput rmxx)" # Not Strike           CSI 29 m

## Colors
##
## @see
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Pm-m.1CA7
t_f_default="${t_csi}39m" # Set foreground color to default value               CSI 39m
t_b_default="${t_csi}49m" # Set background color to default value               CSI 49m
# Set both foreground and background colors to their default values
t_fb_default=; $t_has_op && t_fb_default="$(tput op)"
## Normal foreground colors
t_f_black=;    $t_has_setaf && t_f_black="$(tput setaf 0)"     # Black          CSI 30 m
t_f_red=;      $t_has_setaf && t_f_red="$(tput setaf 1)"       # Red            CSI 31 m
t_f_green=;    $t_has_setaf && t_f_green="$(tput setaf 2)"     # Green          CSI 32 m
t_f_yellow=;   $t_has_setaf && t_f_yellow="$(tput setaf 3)"    # Yellow         CSI 33 m
t_f_blue=;     $t_has_setaf && t_f_blue="$(tput setaf 4)"      # Blue           CSI 34 m
t_f_magenta=;  $t_has_setaf && t_f_magenta="$(tput setaf 5)"   # Magenta        CSI 35 m
t_f_cyan=;     $t_has_setaf && t_f_cyan="$(tput setaf 6)"      # Cyan           CSI 36 m
t_f_lgray=;    $t_has_setaf && t_f_lgray="$(tput setaf 7)"     # Light Gray     CSI 37 m
t_f_dgray=;    $t_has_setaf && t_f_dgray="$(tput setaf 8)"     # Dark Gray      CSI 90 m
t_f_lred=;     $t_has_setaf && t_f_lred="$(tput setaf 9)"      # Light Red      CSI 91 m
t_f_lgreen=;   $t_has_setaf && t_f_lgreen="$(tput setaf 10)"   # Light Green    CSI 92 m
t_f_lyellow=;  $t_has_setaf && t_f_lyellow="$(tput setaf 11)"  # Light Yellow   CSI 93 m
t_f_lblue=;    $t_has_setaf && t_f_lblue="$(tput setaf 12)"    # Light Yellow   CSI 94 m
t_f_lmagenta=; $t_has_setaf && t_f_lmagenta="$(tput setaf 13)" # Light Magenta  CSI 95 m
t_f_lcyan=;    $t_has_setaf && t_f_lcyan="$(tput setaf 14)"    # Light Cyan     CSI 96 m
t_f_white=;    $t_has_setaf && t_f_white="$(tput setaf 15)"    # White          CSI 97 m
## Bold foreground colors
t_f_bblack="$t_bold$t_f_black"
t_f_bred="$t_bold$t_f_red"
t_f_bgreen="$t_bold$t_f_green"
t_f_byellow="$t_bold$t_f_yellow"
t_f_bblue="$t_bold$t_f_blue"
t_f_bmagenta="$t_bold$t_f_magenta"
t_f_bcyan="$t_bold$t_f_cyan"
t_f_blgray="$t_bold$t_f_lgray"
t_f_bdgray="$t_bold$t_f_dgray"
t_f_blred="$t_bold$t_f_lred"
t_f_blgreen="$t_bold$t_f_lgreen"
t_f_blyellow="$t_bold$t_f_lyellow"
t_f_blblue="$t_bold$t_f_lblue"
t_f_blmagenta="$t_bold$t_f_lmagenta"
t_f_blcyan="$t_bold$t_f_lcyan"
t_f_bwhite="$t_bold$t_f_white"
## Dim foreground colors
t_f_dblack="$t_dim$t_f_black"
t_f_dred="$t_dim$t_f_red"
t_f_dgreen="$t_dim$t_f_green"
t_f_dyellow="$t_dim$t_f_yellow"
t_f_dblue="$t_dim$t_f_blue"
t_f_dmagenta="$t_dim$t_f_magenta"
t_f_dcyan="$t_dim$t_f_cyan"
t_f_dlgray="$t_dim$t_f_lgray"
t_f_ddgray="$t_dim$t_f_dgray"
t_f_dlred="$t_dim$t_f_lred"
t_f_dlgreen="$t_dim$t_f_lgreen"
t_f_dlyellow="$t_dim$t_f_lyellow"
t_f_dlblue="$t_dim$t_f_lblue"
t_f_dlmagenta="$t_dim$t_f_lmagenta"
t_f_dlcyan="$t_dim$t_f_lcyan"
t_f_dwhite="$t_dim$t_f_white"
## Background colors
t_b_black=;    $t_has_setab && t_b_black="$(tput setab 0)"     # Black          CSI 40 m
t_b_red=;      $t_has_setab && t_b_red="$(tput setab 1)"       # Red            CSI 41 m
t_b_green=;    $t_has_setab && t_b_green="$(tput setab 2)"     # Green          CSI 42 m
t_b_yellow=;   $t_has_setab && t_b_yellow="$(tput setab 3)"    # Yellow         CSI 43 m
t_b_blue=;     $t_has_setab && t_b_blue="$(tput setab 4)"      # Blue           CSI 44 m
t_b_magenta=;  $t_has_setab && t_b_magenta="$(tput setab 5)"   # Magenta        CSI 45 m
t_b_cyan=;     $t_has_setab && t_b_cyan="$(tput setab 6)"      # Cyan           CSI 46 m
t_b_lgray=;    $t_has_setab && t_b_lgray="$(tput setab 7)"     # Light Gray     CSI 47 m
t_b_dgray=;    $t_has_setab && t_b_dgray="$(tput setab 8)"     # Dark Gray      CSI 100 m
t_b_lred=;     $t_has_setab && t_b_lred="$(tput setab 9)"      # Light Red      CSI 101 m
t_b_lgreen=;   $t_has_setab && t_b_lgreen="$(tput setab 10)"   # Light Green    CSI 102 m
t_b_lyellow=;  $t_has_setab && t_b_lyellow="$(tput setab 11)"  # Light Yellow   CSI 103 m
t_b_lblue=;    $t_has_setab && t_b_lblue="$(tput setab 12)"    # Light Yellow   CSI 104 m
t_b_lmagenta=; $t_has_setab && t_b_lmagenta="$(tput setab 13)" # Light Magenta  CSI 105 m
t_b_lcyan=;    $t_has_setab && t_b_lcyan="$(tput setab 14)"    # Light Cyan     CSI 106 m
t_b_white=;    $t_has_setab && t_b_white="$(tput setab 15)"    # White          CSI 107 m

return 0

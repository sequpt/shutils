#!/bin/sh
# SPDX-License-Identifier: 0BSD
# shellcheck disable=SC2034 # "Unused"
################################################################################
# @license
# BSD Zero Clause License
#
# Copyright (c) 2022 by the shutils authors
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# @brief
# Provides some utilities for POSIX sh scripts.
#
# @detail
# Shutils is a POSIX sh script providing some utilities functions and variables
# for the following things:
# - Exit codes
# - Terminal color and formating
#
# Functions and variables starting with an underscore(e.g., _var) are for
# internal use only and shouldn't be used outside of this file.
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to POSIX
LC_ALL=C
export LC_ALL
################################################################################
# EXIT CODES
################################################################################
# Success
ERR_SUCCESS=0
# Failure
ERR_FAILURE=1
# Command wasn't used correctly
ERR_USAGE=2
# Command can't be executed
ERR_EXEC=126
# Command not found
ERR_NOCMD=127
################################################################################
# AVAILABILITY FLAG
#
# Boolean flags testing the availability of some common commands
################################################################################
has_apt_get=false;  command -v apt-get  > "/dev/null" && has_apt_get=true
has_curl=false;     command -v curl     > "/dev/null" && has_curl=true
has_cut=false;      command -v cut      > "/dev/null" && has_cut=true
has_date=false;     command -v date     > "/dev/null" && has_date=true
has_dirname=false;  command -v dirname  > "/dev/null" && has_dirname=true
has_dpkg=false;     command -v dpkg     > "/dev/null" && has_dpkg=true
has_git=false;      command -v git      > "/dev/null" && has_git=true
has_grep=false;     command -v grep     > "/dev/null" && has_grep=true
has_gzip=false;     command -v gzip     > "/dev/null" && has_gzip=true
has_head=false;     command -v head     > "/dev/null" && has_head=true
has_mkdir=false;    command -v mkdir    > "/dev/null" && has_mkdir=true
has_realpath=false; command -v realpath > "/dev/null" && has_realpath=true
has_rm=false;       command -v rm       > "/dev/null" && has_rm=true
has_rsync=false;    command -v rsync    > "/dev/null" && has_rsync=true
has_sed=false;      command -v sed      > "/dev/null" && has_sed=true
has_shasum=false;   command -v shasum   > "/dev/null" && has_shasum=true
has_su=false;       command -v su       > "/dev/null" && has_su=true
has_sudo=false;     command -v sudo     > "/dev/null" && has_sudo=true
has_tar=false;      command -v tar      > "/dev/null" && has_tar=true
has_tput=false;     command -v tput     > "/dev/null" && has_tput=true
has_wget=false;     command -v wget     > "/dev/null" && has_wget=true
has_xz=false;       command -v xz       > "/dev/null" && has_xz=true
################################################################################
# TERMINAL
#
# Commands starting with `${_csi}` need to be used with the `%b` format
# specifier when passed as arguments to `printf()` to be interpreted correctly
# as escape sequences.
# Example:
# printf "%b\n" "${t_strike}Text${t_clr}" # Print a struck "Text" string
# printf "%s\n" "${t_strike}Text${t_clr}" # Print "\033[9mText"
#
#
# see:
# - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
# - https://en.wikipedia.org/wiki/ANSI_escape_code
################################################################################
# ASCII code for escape character
# Octal: 033 | Decimal: 27 | Hexadecimal: 0x1B(_esc="\x1b")
# See:
# - https://en.wikipedia.org/wiki/Escape_character#ASCII_escape_character
_esc="\033"

# CSI (Control Sequence Introducer)
# See:
# - https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences
_csi="${_esc}["
#-------------------------------------------------------------------------------
# SGR (Select Graphic Rendition)
# See:
# - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Pm-m.1CA7
# - https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
#-------------------------------------------------------------------------------
has_tput_blink=false; tput blink > "/dev/null" 2>&1 && has_tput_blink=true
has_tput_bold=false;  tput bold  > "/dev/null" 2>&1 && has_tput_bold=true
has_tput_dim=false;   tput dim   > "/dev/null" 2>&1 && has_tput_dim=true
has_tput_invis=false; tput invis > "/dev/null" 2>&1 && has_tput_invis=true
has_tput_rev=false;   tput rev   > "/dev/null" 2>&1 && has_tput_rev=true
has_tput_ritm=false;  tput ritm  > "/dev/null" 2>&1 && has_tput_ritm=true
has_tput_rmul=false;  tput rmul  > "/dev/null" 2>&1 && has_tput_rmul=true
has_tput_rmxx=false;  tput rmxx  > "/dev/null" 2>&1 && has_tput_rmxx=true
has_tput_setab=false; tput setab > "/dev/null" 2>&1 && has_tput_setab=true
has_tput_setaf=false; tput setaf > "/dev/null" 2>&1 && has_tput_setaf=true
has_tput_sgr0=false;  tput sgr0  > "/dev/null" 2>&1 && has_tput_sgr0=true
has_tput_sitm=false;  tput sitm  > "/dev/null" 2>&1 && has_tput_sitm=true
has_tput_smul=false;  tput smul  > "/dev/null" 2>&1 && has_tput_smul=true
has_tput_smxx=false;  tput smxx  > "/dev/null" 2>&1 && has_tput_smxx=true

# Set mode
t_bold=;   $has_tput_bold  && t_bold="$(tput bold)"      # Bold         - CSI 1 m
t_dim=;    $has_tput_dim   && t_dim="$(tput dim)"        # Dim          - CSI 2 m
t_it=;     $has_tput_sitm  && t_it="$(tput sitm)"        # Italic       - CSI 3 m
t_ul=;     $has_tput_smul  && t_ul="$(tput smul)"        # Underline    - CSI 4 m
t_blink=;  $has_tput_blink && t_blink="$(tput blink)"    # Blink        - CSI 5 m
t_rev=;    $has_tput_rev   && t_rev="$(tput rev)"        # Reverse      - CSI 7 m
t_invis=;  $has_tput_invis && t_invis="$(tput invis)"    # Invisible    - CIS 8 m
t_strike=; $has_tput_smxx  && t_strike="$(tput smxx)"    # Strike       - CSI 9 m
t_ul2="${_csi}21m"                                       # Underline x2 - CSI 21 m
# Remove mode
t_clr=;       $has_tput_sgr0  && t_clr="$(tput sgr0)"       # Reset all    - CSI 0 m
t_rm_bold=;   $has_tput_bold  && t_rm_bold="${_csi}22m"     # Bold         - CSI 22 m
t_rm_dim=;    $has_tput_dim   && t_rm_dim="${_csi}22m"      # Dim          - CSI 22 m
t_rm_it=;     $has_tput_ritm  && t_rm_it="$(tput ritm)"     # Italic       - CSI 23 m
t_rm_ul=;     $has_tput_rmul  && t_rm_ul="$(tput rmul)"     # Underline    - CSI 24 m
t_rm_ul2=;    $has_tput_rmul  && t_rm_ul2="${t_rm_ul}"      # Underline x2 - CSI 24 m
t_rm_blink=;  $has_tput_blink && t_rm_blink="${_csi}25m"    # Blink        - CSI 25 m
t_rm_invis=;  $has_tput_invis && t_rm_invis="${_csi}28m"    # Invisible    - CSI 28 m
t_rm_strike=; $has_tput_rmxx  && t_rm_strike="$(tput rmxx)" # Strike       - CSI 29 m
#-------------------------------------------------------------------------------
# Foreground colors
#-------------------------------------------------------------------------------
# Default - CSI 39 m
t_default="${_csi}39m"
# Normal
t_black=;    $has_tput_setaf && t_black="$(tput setaf 0)"     # Black         - CSI 30 m
t_red=;      $has_tput_setaf && t_red="$(tput setaf 1)"       # Red           - CSI 31 m
t_green=;    $has_tput_setaf && t_green="$(tput setaf 2)"     # Green         - CSI 32 m
t_yellow=;   $has_tput_setaf && t_yellow="$(tput setaf 3)"    # Yellow        - CSI 33 m
t_blue=;     $has_tput_setaf && t_blue="$(tput setaf 4)"      # Blue          - CSI 34 m
t_magenta=;  $has_tput_setaf && t_magenta="$(tput setaf 5)"   # Magenta       - CSI 35 m
t_cyan=;     $has_tput_setaf && t_cyan="$(tput setaf 6)"      # Cyan          - CSI 36 m
t_lgray=;    $has_tput_setaf && t_lgray="$(tput setaf 7)"     # Light Gray    - CSI 37 m
t_dgray=;    $has_tput_setaf && t_dgray="$(tput setaf 8)"     # Dark Gray     - CSI 90 m
t_lred=;     $has_tput_setaf && t_lred="$(tput setaf 9)"      # Light Red     - CSI 91 m
t_lgreen=;   $has_tput_setaf && t_lgreen="$(tput setaf 10)"   # Light Green   - CSI 92 m
t_lyellow=;  $has_tput_setaf && t_lyellow="$(tput setaf 11)"  # Light Yellow  - CSI 93 m
t_lblue=;    $has_tput_setaf && t_lblue="$(tput setaf 12)"    # Light Yellow  - CSI 94 m
t_lmagenta=; $has_tput_setaf && t_lmagenta="$(tput setaf 13)" # Light Magenta - CSI 95 m
t_lcyan=;    $has_tput_setaf && t_lcyan="$(tput setaf 14)"    # Light Cyan    - CSI 96 m
t_white=;    $has_tput_setaf && t_white="$(tput setaf 15)"    # White         - CSI 97 m
# Bold
t_b_black="$t_bold$t_black"
t_b_red="$t_bold$t_red"
t_b_green="$t_bold$t_green"
t_b_yellow="$t_bold$t_yellow"
t_b_blue="$t_bold$t_blue"
t_b_magenta="$t_bold$t_magenta"
t_b_cyan="$t_bold$t_cyan"
t_b_lgray="$t_bold$t_lgray"
t_b_dgray="$t_bold$t_dgray"
t_b_lred="$t_bold$t_lred"
t_b_lgreen="$t_bold$t_lgreen"
t_b_lyellow="$t_bold$t_lyellow"
t_b_lblue="$t_bold$t_lblue"
t_b_lmagenta="$t_bold$t_lmagenta"
t_b_lcyan="$t_bold$t_lcyan"
t_b_white="$t_bold$t_white"
# Dim
t_d_black="$t_dim$t_black"
t_d_red="$t_dim$t_red"
t_d_green="$t_dim$t_green"
t_d_yellow="$t_dim$t_yellow"
t_d_blue="$t_dim$t_blue"
t_d_magenta="$t_dim$t_magenta"
t_d_cyan="$t_dim$t_cyan"
t_d_lgray="$t_dim$t_lgray"
t_d_dgray="$t_dim$t_dgray"
t_d_lred="$t_dim$t_lred"
t_d_lgreen="$t_dim$t_lgreen"
t_d_lyellow="$t_dim$t_lyellow"
t_d_lblue="$t_dim$t_lblue"
t_d_lmagenta="$t_dim$t_lmagenta"
t_d_lcyan="$t_dim$t_lcyan"
t_d_white="$t_dim$t_white"
#-------------------------------------------------------------------------------
# Background colors
#-------------------------------------------------------------------------------
# Default - CSI 49 m
t_bg_default="${_csi}49m"
# Normal
t_bg_black=;    $has_tput_setab && t_bg_black="$(tput setab 0)"     # Black         - CSI 40 m
t_bg_red=;      $has_tput_setab && t_bg_red="$(tput setab 1)"       # Red           - CSI 41 m
t_bg_green=;    $has_tput_setab && t_bg_green="$(tput setab 2)"     # Green         - CSI 42 m
t_bg_yellow=;   $has_tput_setab && t_bg_yellow="$(tput setab 3)"    # Yellow        - CSI 43 m
t_bg_blue=;     $has_tput_setab && t_bg_blue="$(tput setab 4)"      # Blue          - CSI 44 m
t_bg_magenta=;  $has_tput_setab && t_bg_magenta="$(tput setab 5)"   # Magenta       - CSI 45 m
t_bg_cyan=;     $has_tput_setab && t_bg_cyan="$(tput setab 6)"      # Cyan          - CSI 46 m
t_bg_lgray=;    $has_tput_setab && t_bg_lgray="$(tput setab 7)"     # Light Gray    - CSI 47 m
t_bg_dgray=;    $has_tput_setab && t_bg_dgray="$(tput setab 8)"     # Dark Gray     - CSI 100 m
t_bg_lred=;     $has_tput_setab && t_bg_lred="$(tput setab 9)"      # Light Red     - CSI 101 m
t_bg_lgreen=;   $has_tput_setab && t_bg_lgreen="$(tput setab 10)"   # Light Green   - CSI 102 m
t_bg_lyellow=;  $has_tput_setab && t_bg_lyellow="$(tput setab 11)"  # Light Yellow  - CSI 103 m
t_bg_lblue=;    $has_tput_setab && t_bg_lblue="$(tput setab 12)"    # Light Yellow  - CSI 104 m
t_bg_lmagenta=; $has_tput_setab && t_bg_lmagenta="$(tput setab 13)" # Light Magenta - CSI 105 m
t_bg_lcyan=;    $has_tput_setab && t_bg_lcyan="$(tput setab 14)"    # Light Cyan    - CSI 106 m
t_bg_white=;    $has_tput_setab && t_bg_white="$(tput setab 15)"    # White         - CSI 107 m
################################################################################
# LOGGING
################################################################################
_LOG_INFO="${t_b_blue}INFO${t_clr}"
_LOG_WARNING="${t_b_yellow}WARNING${t_clr}"
_LOG_ERROR="${t_b_red}ERROR${t_clr}"
#-------------------------------------------------------------------------------
# _log_msg()
#-------------------------------------------------------------------------------
# Print a message prefixed with a timestamp, the file and the function in which
# the logging is done and a log level.
# Format:
# <timestamp> - <file>:<function>() - [<log_level>] <message>
#
# @args
# $1 [REQ]: One of the `_LOG_{INFO, WARNING, ERROR}` variable.
# $2 [OPT]: Message to log.
# $2 [OPT]: Function name.
#-------------------------------------------------------------------------------
_log_msg() {
    _arg_cnt="$#"
    # Exit with `$ERR_USAGE` if wrong number of arguments is given
    if [ "$_arg_cnt" -lt 1 ] || [ "$_arg_cnt" -gt 3 ]; then
        _log_msg "$_LOG_ERROR" "_log_msg() needs either 1, 2 or 3 arguments($_arg_cnt given)!"
        exit "$ERR_USAGE"
    fi
    _timestamp="<Timestamp unavailable>"
    if [ "$has_date" = true ]; then
        _timestamp="$(date --utc --iso-8601=seconds)"
    fi
    _path="$0"
    _level="$1"
    _msg="${2:-"<No message>"}"
    _func="${3:-"<Unknown function>"}"
    printf "%s - %s:%s() - [%s] %s\n" "$_timestamp" "$_path" "$_func" "$_level" "$_msg"
}
################################################################################
# INTERNAL UTILITIES
################################################################################
#-------------------------------------------------------------------------------
# _assert_str_not_empty()
#-------------------------------------------------------------------------------
# Assert that a string is not empty.
#
# @args
# $1 [REQ]: Name of the variable to check passed as a string without the `$`.
#           (see examples)
#
# @return
# - Nothing
#
# @warning
# - Exit with `$ERR_USAGE` if no argument is given.
#
# @example
# path="/home"
# _assert_str_not_empty "path" # OK
# path=""
# _assert_str_not_empty "path" # FAIL
# path=
# _assert_str_not_empty "path" # FAIL
#-------------------------------------------------------------------------------
_assert_str_not_empty() {
    _arg_cnt="$#"
    # Exit with `$ERR_USAGE` if number of arguments isn't 1
    if [ "$_arg_cnt" -ne 1 ]; then
        printf "Error: _assert_str_not_empty() needs exactly 1 argument(%d given)!" "$_arg_cnt" 1>&2
        exit "$ERR_USAGE"
    fi
    _var_name="$1"
    _var_value=""
    eval _var_value=\"\$"$_var_name"\"
    if [ -z "$_var_value" ]; then
        printf "Assertion failed: '$%s' string is empty!\n" "$_var_name"
        exit "$ERR_FAILURE"
    fi
}

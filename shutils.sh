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
# - Terminal text/background color and formating
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
#-------------------------------------------------------------------------------
# _has_cmd()
#-------------------------------------------------------------------------------
# Check if a given command exists and return true if it does and false
# otherwise.
#
# The command name and each of its arguments(if they exist) must be given as
# separate arguments to `_has_cmd()`. Example for `ls -l -a`:
# RIGHT: - `_has_cmd "ls" "-l" "-a"`
#        - `_has_cmd ls -l -a`
# WRONG: - `_has_cmd "ls -l -a"`
#        - `_has_cmd "ls -l" "-a"`
#        - `_has_cmd "ls" "-l -a"`
#
# If arguments are passed to the command, the existence of the command AND the
# arguments are tested. In this case, `_has_cmd()` will return false if the
# command exists but its arguments are invalid.
#
# @args
# $1 [REQ]: Command name
# $2+[OPT]: Arguments to the command
#
# @return
# - @success: true
# - @failure: false
#
# @warning
# - Exit with `$ERR_USAGE` if no argument is given.
#
# @example
# _has_cmd="$(_has_cmd "ls")"
# _has_cmd="$(_has_cmd "tput" "sgr")"
# _has_cmd "grep" && printf "Has grep: true\n"
#-------------------------------------------------------------------------------
_has_cmd() {
    _arg_cnt="$#"
    # Exit with `$ERR_USAGE` if no argument is given.
    if [ "$_arg_cnt" -eq 0 ]; then
        printf "Error: _has_cmd() needs at least 1 argument!\n" 1>&2
        exit "$ERR_USAGE"
    fi
    _cmd="$1"
    # Command is passed without arguments
    if [ "$_arg_cnt" -eq 1 ]; then
        command -v "$_cmd" > "/dev/null"
    # Command is passed with one ore more arguments
    else
        shift 1
        _args="$*"
        command "$_cmd" "$_args" > "/dev/null" 2>&1
    fi
}
################################################################################
# TERMINAL
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

# SGR (Select Graphic Rendition)
# See:
# - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Pm-m.1CA7
# - https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
# Clear all formatting - CSI 0 m
t_clr=; _has_cmd "tput" "sgr0" && t_clr="$(tput sgr0)"
# Bold ON - CSI 1 m
fg_bold=; _has_cmd tput bold && fg_bold="$(tput bold)"
# Bold OFF - CSI 22 m(same as dim off)
fg_clr_bold="${_csi}22m"
# Dim ON - CSI 2 m
fg_dim=; _has_cmd tput dim && fg_dim="$(tput dim)"
# Dim OFF - CSI 22 m(same as bold off)
fg_clr_dim="${_csi}22m"
# Italic ON - CSI 3 m
fg_it=; _has_cmd tput sitm && fg_it="$(tput sitm)"
# Italic OFF - CSI 23 m
fg_clr_it=; _has_cmd tput ritm && fg_clr_it="$(tput ritm)"
# Underline ON - CSI 4 m
fg_ul=; _has_cmd tput smul && fg_ul="$(tput smul)"
# Underline OFF - CSI 24 m
fg_clr_ul=; _has_cmd tput rmul && fg_clr_ul="$(tput rmul)"
# Blink - CSI 5 m
fg_blink=; _has_cmd tput blink && fg_blink="$(tput blink)"
# Blink OFF - CSI 25 m
fg_clr_blink="${_csi}25m"
# Invert text/background colors - CSI 7 m
t_rev=; _has_cmd tput rev && t_rev="$(tput rev)"
# Strike ON - CSI 9 m
fg_strike="${_csi}9m"
# Strike OFF - CSI 29 m
fg_clr_strike="${_csi}29m"

# Check if `tput setaf` is available
_has_tput_setaf=$(_has_cmd tput setaf)
# Default foreground color - CSI 39 m
fg_default="${_csi}39m"
# Foreground normal colors - CSI 30-37 m
fg_black=;    $_has_tput_setaf && fg_black="$(tput setaf 0)"
fg_red=;      $_has_tput_setaf && fg_red="$(tput setaf 1)"
fg_green=;    $_has_tput_setaf && fg_green="$(tput setaf 2)"
fg_yellow=;   $_has_tput_setaf && fg_yellow="$(tput setaf 3)"
fg_blue=;     $_has_tput_setaf && fg_blue="$(tput setaf 4)"
fg_magenta=;  $_has_tput_setaf && fg_magenta="$(tput setaf 5)"
fg_cyan=;     $_has_tput_setaf && fg_cyan="$(tput setaf 6)"
fg_lgray=;    $_has_tput_setaf && fg_lgray="$(tput setaf 7)"
fg_dgray=;    $_has_tput_setaf && fg_dgray="$(tput setaf 8)"
fg_lred=;     $_has_tput_setaf && fg_lred="$(tput setaf 9)"
fg_lgreen=;   $_has_tput_setaf && fg_lgreen="$(tput setaf 10)"
fg_lyellow=;  $_has_tput_setaf && fg_lyellow="$(tput setaf 11)"
fg_lblue=;    $_has_tput_setaf && fg_lblue="$(tput setaf 12)"
fg_lmagenta=; $_has_tput_setaf && fg_lmagenta="$(tput setaf 13)"
fg_lcyan=;    $_has_tput_setaf && fg_lcyan="$(tput setaf 14)"
fg_white=;    $_has_tput_setaf && fg_white="$(tput setaf 15)"
# Foreground bold colors
fg_b_black="$fg_bold$fg_black"
fg_b_red="$fg_bold$fg_red"
fg_b_green="$fg_bold$fg_green"
fg_b_yellow="$fg_bold$fg_yellow"
fg_b_blue="$fg_bold$fg_blue"
fg_b_magenta="$fg_bold$fg_magenta"
fg_b_cyan="$fg_bold$fg_cyan"
fg_b_lgray="$fg_bold$fg_lgray"
fg_b_dgray="$fg_bold$fg_dgray"
fg_b_lred="$fg_bold$fg_lred"
fg_b_lgreen="$fg_bold$fg_lgreen"
fg_b_lyellow="$fg_bold$fg_lyellow"
fg_b_lblue="$fg_bold$fg_lblue"
fg_b_lmagenta="$fg_bold$fg_lmagenta"
fg_b_lcyan="$fg_bold$fg_lcyan"
fg_b_white="$fg_bold$fg_white"
# Foreground dim colors
fg_d_black="$fg_dim$fg_black"
fg_d_red="$fg_dim$fg_red"
fg_d_green="$fg_dim$fg_green"
fg_d_yellow="$fg_dim$fg_yellow"
fg_d_blue="$fg_dim$fg_blue"
fg_d_magenta="$fg_dim$fg_magenta"
fg_d_cyan="$fg_dim$fg_cyan"
fg_d_lgray="$fg_dim$fg_lgray"
fg_d_dgray="$fg_dim$fg_dgray"
fg_d_lred="$fg_dim$fg_lred"
fg_d_lgreen="$fg_dim$fg_lgreen"
fg_d_lyellow="$fg_dim$fg_lyellow"
fg_d_lblue="$fg_dim$fg_lblue"
fg_d_lmagenta="$fg_dim$fg_lmagenta"
fg_d_lcyan="$fg_dim$fg_lcyan"
fg_d_white="$fg_dim$fg_white"

# Check if `tput setab` is available
_has_tput_setab="$(_has_cmd tput setab)"
# Default background color - CSI 49 m
bg_default="${_csi}49m"
# Background colors - CSI 40-47 m
bg_black=;    $_has_tput_setab && bg_black="$(tput setab 0)"
bg_red=;      $_has_tput_setab && bg_red="$(tput setab 1)"
bg_green=;    $_has_tput_setab && bg_green="$(tput setab 2)"
bg_yellow=;   $_has_tput_setab && bg_yellow="$(tput setab 3)"
bg_blue=;     $_has_tput_setab && bg_blue="$(tput setab 4)"
bg_magenta=;  $_has_tput_setab && bg_magenta="$(tput setab 5)"
bg_cyan=;     $_has_tput_setab && bg_cyan="$(tput setab 6)"
bg_lgray=;    $_has_tput_setab && bg_lgray="$(tput setab 7)"
bg_dgray=;    $_has_tput_setab && bg_dgray="$(tput setab 8)"
bg_lred=;     $_has_tput_setab && bg_lred="$(tput setab 9)"
bg_lgreen=;   $_has_tput_setab && bg_lgreen="$(tput setab 10)"
bg_lyellow=;  $_has_tput_setab && bg_lyellow="$(tput setab 11)"
bg_lblue=;    $_has_tput_setab && bg_lblue="$(tput setab 12)"
bg_lmagenta=; $_has_tput_setab && bg_lmagenta="$(tput setab 13)"
bg_lcyan=;    $_has_tput_setab && bg_lcyan="$(tput setab 14)"
bg_white=;    $_has_tput_setab && bg_white="$(tput setab 15)"

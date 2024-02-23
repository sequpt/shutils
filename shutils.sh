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

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
## Main script running all the tests
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
    _self_path="$(realpath "$0")"
    _tests_path="$(dirname "$_self_path")"
    _lib_path="$(realpath "$_tests_path/../lib")"

    . "$_tests_path/tests_xdg_basedir.sh"
    printf "xdg_basedir: "
    if tests_xdg_basedir "$_lib_path"; then printf "OK\n"; else printf "FAILED\n"; fi

    . "$_tests_path/tests_xdg_userdir.sh"
    printf "xdg_userdir: "
    if tests_xdg_userdir "$_lib_path"; then printf "OK\n"; else printf "FAILED\n"; fi

    . "$_tests_path/tests_xdg_basedir_ext.sh"
    printf "xdg_basedir_ext: "
    if tests_xdg_basedir_ext "$_lib_path"; then printf "OK\n"; else printf "FAILED\n"; fi

    unset _self_path _tests_path _lib_path
)

main "$@"

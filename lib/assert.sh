#!/bin/sh
# SPDX-License-Identifier: 0BSD
################################################################################
## @file
## @date 19.02.2024
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
## Provides assertion functions such as `assert_arg_cnt_eq()` and
## `assert_str_not_empty()`
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
. "${SHUTILS_PATH:?}/log.sh"
# . "$(dirname "$(realpath "$0")")/log.sh"
## assert_arg_cnt_eq()
##
## Assert that the number of arguments passed as `$1` is equal to the expected
## value passed as `$2`.
##
## @args
## $1 [REQ]: Number of argument.
## $2 [REQ]: Expected value.
## $3 [OPT]: Function name.
##
## @example
## foo () {
##     assert_arg_cnt_eq "$#" 1 "foo"
## }
## foo "bar"       # OK
## foo "bar" "baz" # FAIL
## foo             # FAIL
assert_arg_cnt_eq() {
  _self="assert_arg_cnt_eq()"
  _arg_cnt="$#"
  _func="${3:-}"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given.
  if [ "$_arg_cnt" -lt 2 ] && [ "$_arg_cnt" -gt 3 ]; then
    log_error "$_self needs either 2 or 3 arguments($_arg_cnt given)!" "$_func"
  fi
  _actual="$1"
  _expected="$2"
  if [ "$_actual" -ne "$_expected" ]; then
    log_error "Assertion failed: exactly $_expected arguments needed($_actual given)!" "$_func"
  fi
}

## assert_str_not_empty()
##
## Assert that a string is not empty.
##
## @args
## $1 [REQ]: Name of the variable to check passed as a string without the `$`.
##           (see examples)
## $2 [OPT]: Function name.
##
## @example
## path="/home"
## assert_str_not_empty "path" # OK
## path=""
## assert_str_not_empty "path" # FAIL
## path=
## assert_str_not_empty "path" # FAIL
assert_str_not_empty() {
  _arg_cnt="$#"
  _func="${2:-}"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given
  if [ "$_arg_cnt" -lt 1 ] || [ "$_arg_cnt" -gt 2 ]; then
    log_error "assert_str_not_empty() needs either 1 or 2 arguments($_arg_cnt given)!" "$_func"
  fi
  _var_name="$1"
  eval _var_value="\$$_var_name"
  if [ -z "$_var_value" ]; then
    log_error "Assertion failed: '\$$_var_name' string is empty!" "$_func"
  fi
}

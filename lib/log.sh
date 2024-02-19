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
## Provides logging functions such as `log_info()` `log_warning()` and
## `log_error()`
################################################################################
# Exit script on error
set -e
# Exit on variable not set
set -u
# Set locale to C/POSIX
LC_ALL=C
export LC_ALL
################################################################################
_clear="$(printf "\033[22;39m")"
_LOG_INFO="$(tput bold setaf 4)INFO$_clear"
_LOG_WARNING="$(tput bold setaf 3)WARNING$_clear"
_LOG_ERROR="$(tput bold setaf 1)ERROR$_clear"

## _log_msg()
##
## Print a message prefixed with a timestamp, the file and the function in which
## the logging is done and a log level.
## Format:
## <timestamp> - <file>:<function>() - [<log_level>] <message>
##
## @args
## $1 [REQ]: One of the `_LOG_{INFO, WARNING, ERROR}` variable.
## $2 [OPT]: Message to log.
## $3 [OPT]: Function name.
_log_msg() {
  _arg_cnt="$#"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given
  if [ "$_arg_cnt" -lt 1 ] || [ "$_arg_cnt" -gt 3 ]; then
    _log_msg "$_LOG_ERROR" "_log_msg() needs either 1, 2 or 3 arguments($_arg_cnt given)!"
    exit 2
  fi
  _timestamp="<Timestamp unavailable>"
  if command -v date > "/dev/null"; then
    _timestamp="$(date --utc --iso-8601=seconds)"
  fi
  _path="$0"
  _level="$1"
  _msg="${2:-"<No message>"}"
  _func="${3:-"<Unknown function>"}"
  printf "%s - %s:%s() - [%s] %s\n" "$_timestamp" "$_path" "$_func" "$_level" "$_msg"
}

## log_info()
##
## Print a message with the `info` level with the following format:
## <timestamp> - <file>:<function>() - [INFO] <message>
## Example:
## "2022-12-01T10:34:46+00:00 - ./test.sh:main() - [INFO] Main script started"
##
## @args
## $1 [OPT]: Message to log.
## $2 [OPT]: Function name.
##
## @example
## log_info "Main script started" "main" # Logging a message and the function name
## log_info "Main script started"        # Logging a message only
## log_info "" "main"                    # Logging the function name only
## log_info                              # Logging no message and no function name
log_info() {
  _arg_cnt="$#"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given
  if [ "$_arg_cnt" -gt 2 ]; then
    _log_msg "$_LOG_ERROR" "log_info() needs either 0, 1 or 2 arguments($_arg_cnt given)!"
    exit 2
  fi
  _log_msg "$_LOG_INFO" "$@"
}

## log_warning()
##
## Print a message with the `warning` level with the following format:
## <timestamp> - <file>:<function>() - [WARNING] <message>
## Example:
## "2022-12-01T10:34:46+00:00 - ./test.sh:main() - [WARNING] This is a warning message"
##
## @args
## $1 [OPT]: Message to log.
## $2 [OPT]: Function name.
##
## @example
## log_warning "This is a warning message" "main" # Logging a message and the function name
## log_warning "This is a warning message"        # Logging a message only
## log_warning "" "main"                          # Logging the function name only
## log_warning                                    # Logging no message and no function name
log_warning() {
  _arg_cnt="$#"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given
  if [ "$_arg_cnt" -gt 2 ]; then
    _log_msg "$_LOG_ERROR" "log_warning() needs either 0, 1 or 2 arguments($_arg_cnt given)!"
    exit 2
  fi
  _log_msg "$_LOG_WARNING" "$@"
}

## log_error()
##
## Print an error message and exit.
## The message has the following format:
## `<timestamp> - <file>:<function>() - [ERROR] <message>`
## Example:
## `2022-12-01T10:34:46+00:00 - ./test.sh:main() - [ERROR] This is an error message``
##
## @args
## $1 [OPT]: Message to log.
## $2 [OPT]: Function name.
##
## @example
## log_error "This is an error message" "main" # Logging a message and the function name
## log_error "This is an error message"        # Logging a message only
## log_error "" "main"                         # Logging the function name only
## log_error                                   # Logging no message and no function name
log_error() {
  _arg_cnt="$#"
  # Exit with `$ERR_USAGE` if wrong number of arguments is given
  if [ "$_arg_cnt" -gt 2 ]; then
    _log_msg "$_LOG_ERROR" "log_error() needs either 0, 1 or 2 arguments($_arg_cnt given)!"
    exit 2
  fi
  _log_msg "$_LOG_ERROR" "$@"
  exit 1
}

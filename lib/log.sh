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
SHUTILS_LOG_INFO="$(tput bold setaf 4)INFO$_clear"
SHUTILS_LOG_WARNING="$(tput bold setaf 3)WARNING$_clear"
SHUTILS_LOG_ERROR="$(tput bold setaf 1)ERROR$_clear"
unset _clear

## write_log() [<log-lvl>] [<msg>] [<fn-name>]
##
## Write log to output according to the following format:
## <timestamp> - <script-path>:<fn-name>() - [<log-lvl>] <msg>
##
## @args
## $1 <log-lvl> [OPT]: One of the `SHUTILS_LOG_{INFO, WARNING, ERROR}` variables
## $2 <msg>     [OPT]: Message to write
## $3 <fn-name> [OPT]: Name of the function logging the message
##
## @example
## write_log
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [<log-lvl>] <msg>
##
## write_log "$SHUTILS_LOG_INFO"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [INFO] <msg>
##
## write_log "$SHUTILS_LOG_WARNING" "Fooing the bar!"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [WARNING] Fooing the bar!
##
## write_log "$SHUTILS_LOG_ERROR" "Fooing the bar failed!" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [ERROR] Fooing the bar failed!
write_log() {
  _timestamp="<timestamp>"
  if command -v date > "/dev/null"; then
    _timestamp="$(date --utc --iso-8601=seconds)"
  fi
  if [ "$#" -gt 3 ]; then
    printf "%s - %s:%s() - [%s] write_log() needs between 0 and 3 arguments(%s given)!\n" \
      "$_timestamp" "$0" "${3:-"<fn-name>"}" "$SHUTILS_LOG_WARNING" "$#" 1>&2
    unset _timestamp
  fi
  printf "%s - %s:%s() - [%s] %s\n" \
    "$_timestamp" "$0" "${3:-"<fn-name>"}" "${1:-"<log-lvl>"}" "${2:-"<msg>"}"
  unset _timestamp
}

## log_info() [<msg>] [<fn-name>]
##
## Write log to output according to the following format:
## <timestamp> - <script-path>:<fn-name>() - [INFO] <msg>
##
## @args
## $1 <msg>     [OPT]: Message to write
## $2 <fn-name> [OPT]: Name of the function logging the message
##
## @examples
## log_info
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [INFO] <msg>
## log_info "Fooing the bar"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [INFO] Fooing the bar
## log_info "Fooing the bar" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [INFO] Fooing the bar
## log_info "" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [INFO]
log_info() {
  if [ "$#" -gt 2 ]; then
    write_log "$SHUTILS_LOG_WARNING" "log_info() needs either 0, 1 or 2 arguments($# given)!" "${2:-}"
  fi
  write_log "$SHUTILS_LOG_INFO" "${1:-}" "${2:-}"
}

## log_warning() [<msg>] [<fn-name>]
##
## Write log to output according to the following format:
## <timestamp> - <script-path>:<fn-name>() - [WARNING] <msg>
##
## @args
## $1 <msg>     [OPT]: Message to write
## $2 <fn-name> [OPT]: Name of the function logging the message
##
## @examples
## log_warning
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [WARNING] <msg>
## log_warning "Fooing the bar!"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [WARNING] Fooing the bar!
## log_warning "Fooing the bar!" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [WARNING] Fooing the bar!
## log_warning "" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [WARNING]
log_warning() {
  if [ "$#" -gt 2 ]; then
    write_log "$SHUTILS_LOG_WARNING" "log_warning() needs either 0, 1 or 2 arguments($# given)!" "${2:-}"
  fi
  write_log "$SHUTILS_LOG_WARNING" "${1:-}" "${2:-}"
}

## log_error() [<msg>] [<fn-name>]
##
## Write log to output according to the following format:
## <timestamp> - <script-path>:<fn-name>() - [ERROR] <msg>
##
## @args
## $1 <msg>     [OPT]: Message to write
## $2 <fn-name> [OPT]: Name of the function logging the message
##
## @examples
## log_error
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [ERROR] <msg>
## log_error "Fooing the bar failed!"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:<fn-name>() - [ERROR] Fooing the bar failed!
## log_error "Fooing the bar failed!" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [ERROR] Fooing the bar failed!
## log_error "" "foo"
## => 0000-00-00T00:00:00+00:00 - ./tests.sh:foo() - [ERROR]
log_error() {
  if [ "$#" -gt 2 ]; then
    write_log "$SHUTILS_LOG_WARNING" "log_error() takes between 0 and 2 arguments($# given)!" "${2:-}"
  fi
  write_log "$SHUTILS_LOG_ERROR" "${1:-}" "${2:-}" 1>&2
}

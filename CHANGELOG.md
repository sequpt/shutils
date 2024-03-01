# Changelog

This file is based on [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/)

This project adheres to [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html),
which says in its summary:

    Given a version number MAJOR.MINOR.PATCH, increment the:
      1. MAJOR version when you make incompatible API changes,
      2. MINOR version when you add functionality in a backwards compatible manner, and
      3. PATCH version when you make backwards compatible bug fixes.

## [Unreleased]

## [0.3.0]

(2024-03-01)

### Added

- Terminal formatting
  - `t_has_smso` and `t_has_rmso` to test availability of `smso` and `rmso` capabilities
  - `t_has_op` to test availability of `op` capability
  - `t_fb_default` to set both foreground and background colors to their default values

### Changed

- Assertion
  - Code moved to `lib/assert.sh`

- Logging
  - Code moved to `lib/log.sh`
  - `_LOG_INFO` renamed to `SHUTILS_LOG_INFO`
  - `_LOG_WARNING` renamed to `SHUTILS_LOG_WARNING`
  - `_LOG_ERROR` renamed to `SHUTILS_LOG_ERROR`
  - `_log_msg()`
    - Renamed to `write_log()`
    - First argument is now optional too
  - `log_info()`, `log_warning()`, `log_error()`
    - Doesn't exit on extra parameters anymore
    - Print a warning message instead of an error in case of extra parameters
    - Extra parameters are ignored
  - `log_error()` doesn't exit anymore

- Terminal formatting
  - Code moved to `lib/term.sh`
  - `%b` format specifier no longer needed when using `t_csi` with `printf`
  - `_esc` and `_csi` renamed to `t_esc` and `t_csi`
  - `_has_tput_<capname>` renamed to `t_has_<capname>`
  - Foreground colors
    - `t_default` renamed to `t_f_default`
    - `t_<color>` renamed to `t_f_<color>`
    - `t_b_<color>` renamed to `t_b<color>`
    - `t_d_<color>` renamed to `t_d<color>`
  - Background colors
    - `t_bg_<color>` renamed to `t_b_<color>`
    - `t_bg_default` renamed to `t_b_default`

## [0.2.0]

(2024-01-27)

### Added

- `lib/xdg_basedir.sh`: Set `XDG_*` variables from the XDG Base Directory specification
- `lib/xdg_userdir.sh`: Set `XDG_*` variables from the `xdg-user-dirs` tool
- `lib/xdg_basedir_ext.sh`: Set non-standard `XDG_*` variables as extension of the XDG Base Directory specification

## [0.1.0]

(2022-12-11)

### Added

- Terminal formatting
  - `_has_tput_<capname>` to check availability of terminal capabilities
  - `t_blink` and `t_rm_blink` to set/remove blink mode
  - `t_bold` and `t_rm_bold` to set/remove bold mode
  - `t_clr` to clear all formatting
  - `t_dim` and `t_rm_dim` to set/remove dim mode
  - `t_invis` and `t_rm_invis` to set/remove invisible mode
  - `t_it` and `t_rm_it` to set/remove italic mode
  - `t_rev` to set reverse mode
  - `t_strike` and `t_rm_strike` to /remove strike mode
  - `t_ul2` and `t_rm_ul2` to set/remove double underline mode
  - `t_ul` and `t_rm_ul` to set/remove underline mode
  - `t_<color>` to set common foreground colors
  - `t_d_<color>` to set dimmed common foreground colors
  - `t_b_<color>` to set bold common foreground colors
  - `t_default` to set the foreground color to its default value
  - `t_bg_<color>` to set common background colors
  - `t_bg_default` to set the background color to its default value

- Logging
  - `log_info()`
  - `log_warning()`
  - `log_error()`
- Assertion
  - `assert_arg_cnt_eq()`
  - `assert_str_not_empty()`

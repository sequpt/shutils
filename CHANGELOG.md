# Changelog

This file is based on [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) but
doesn't follow it to the letter.

This project adheres to [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html),
which says in its summary:

    Given a version number MAJOR.MINOR.PATCH, increment the:
      1. MAJOR version when you make incompatible API changes,
      2. MINOR version when you add functionality in a backwards compatible manner, and
      3. PATCH version when you make backwards compatible bug fixes.

## [Unreleased]

## [0.1.0]

(2022-12-11)

### Added

- Terminal formatting
  - `t_bold` to set bold mode.
  - `t_dim` to set dim mode.
  - `t_it` to set italic mode.
  - `t_ul` to set underline mode.
  - `t_blink` to set blink mode.
  - `t_rev` to set reverse mode.
  - `t_invis` to set invisible mode.
  - `t_strike` to set strike mode.
  - `t_ul2` to set double underline mode.
  - `t_clr` to clear all formatting.
  - `t_rm_bold` to remove bold mode.
  - `t_rm_dim` to remove dim mode.
  - `t_rm_it` to remove italic mode.
  - `t_rm_ul` to remove underline mode.
  - `t_rm_ul2` to remove double underline mode.
  - `t_rm_blink` to remove blink mode.
  - `t_rm_invis` to remove invisible mode.
  - `t_rm_strike` to remove strike mode.
- Logging
  - `log_info()`
  - `log_warning()`
  - `log_error()`
- Assertion
  - `assert_arg_cnt_eq()`
  - `assert_str_not_empty()`

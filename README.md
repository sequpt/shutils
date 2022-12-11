# Shutils - Shell utils

[![license](https://img.shields.io/badge/license-0BSD-blue)](LICENSE)

Shutils is a POSIX compatible set of useful shell utilities fot terminal
formatting, logging and runtime assertions.

## Table of Contents

- [Quick overview](#quick-overview)
- [Versioning](#versioning)
- [Changelog](#changelog)
- [License](#license)

## Quick overview

Terminal formatting

```sh
#!/bin/sh
# Import shutils
. "shutils.sh"
# Set text color
printf "%s\n" "${t_red}Red text on default background${t_clr}"
# Set background color
printf "%s\n" "${t_bg_blue}Default text on blue background${t_clr}"
# Set text and background color
printf "%s\n" "${t_red}${t_bg_blue}Red text on blue background${t_clr}"
```

Logging

```sh
#!/bin/sh
# foo.sh
# Import shutils
. "shutils.sh"

main() {
    # Print "2022-12-01T10:34:46+00:00 - ./foo.sh:main() - [INFO] Main script started"
    log_info "Main script started" "main"
    # Print "2022-12-01T10:34:46+00:00 - ./foo.sh:main() - [WARNING] This function won't terminate normally"
    log_warning "This function won't terminate normally" "main"
    # Print "2022-12-01T10:34:46+00:00 - ./foo.sh:main() - [ERROR] Main script started"
    # and exit
    log_error "Exiting early with error code -1" "main"
    # Won't print
    log_info "Main script ended" "main"
}
main
```

Assertions

```sh
#!/bin/sh
# foo.sh
# Import shutils
. "shutils.sh"

# assert_str_not_empty()
path="/home"
assert_str_not_empty "path" # OK
path=""
assert_str_not_empty "path" # FAIL
path=
assert_str_not_empty "path" # FAIL

# assert_arg_cnt_eq()
main() {
    assert_arg_cnt_eq $# 1 "main"
}
main "bar"       # OK
main "bar" "baz" # FAIL
main             # FAIL
```

## Versioning

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file.

## License

This project is licensed under the [BSD Zero Clause License](LICENSE).

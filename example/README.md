# Clean Coverage

A dart tool clean up LCOV files.
Remove unwanted files from the coverage record using globs.
Heavily inspired by [remove_from_coverage](https://pub.dev/packages/remove_from_coverage)

```
Usage: clean_coverage clean [arguments]
-h, --help                      Print this usage information.
    --exclusions=<glob>         Exclude files with names matching the given glob. This option can be repeated.
    --exclusions-file=<file>    Exclude files with names matching the given globs in the file.
```

## Getting Started

Install `clean_coverage`
```
  pub global activate clean_coverage
```

Run the `clean` command

```
  pub global run clean_coverage clean --exclusions-file exclusions.txt coverage/lcov.info
```
or
```
  pub global run clean_coverage clean --exclusions '**/.g.dart', '**/directory/**' coverage/lcov.info
```

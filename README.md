# today

[![ISC License](https://img.shields.io/badge/License-ISC-green.svg)](LICENSE)

A POSIX shell script for parsing plain-text todo lists and writing today's
tasks to stdout.

## Features

- **Recurring tasks**: `@monday` `@daily` `@weekend` etc
- **Prioritized tasks**: `- [A]` `- [B]`...`- [Z]`
- **Tags**: `+tag` `+project` `+group`
- **Calendar events**: `@2025-02-28`

## Documentation

To get started with `today`, run the following commands:

```bash
echo '- [A] my most important task' >> todo.md
today
```

and the output will look something like:

```console
Sunday January 19, 2025

- my most important task
```

For the full documentation and file format information, run:

```bash
today -h
```

Also, check out [an example todo.md file][example] to see the file format in
use.

[example]: https://github.com/rasch/today/blob/main/example/todo.md?plain=1
    
## Build and Installation

To lint, test, and build `today` locally, run the following commands:

```bash
git clone https://github.com/rasch/today.git
cd today
./run
```

or to just build (and skip the linting and tests):

```bash
./run build
```

To install, move the `today` script somewhere in your $PATH. For example:

```bash
mv today /usr/local/bin/
```

## Roadmap

- Rewrite in a more feature-rich language so I can write a real parser and
  enable more complex contexts, such as:
  - compound contexts: `@friday-and-13th`
  - ternary contexts: `@if-monday-and-12-25-then-tuesday-else-monday`
- Add option to read todo file from stdin, `--file -`, to make it easier to
  concatenate multiple todo files before parsing:
  `cat tasks.md holidays.md birthdays.md | today -f -`

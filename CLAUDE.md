# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal fork of [Prezto](https://github.com/sorin-ionescu/prezto) — a Zsh configuration framework. It must work on both macOS and Ubuntu Linux.

## Architecture

**Bootstrap flow:** `zshenv` → `zprofile` → `zshrc` (sources `init.zsh`, which sources `zpreztorc` and loads modules via `pmodload`) → `zlogin`

**Key files:**
- `init.zsh` — Core loader. Defines `pmodload` which finds and sources modules from `modules/`, `contrib/`, and user-defined dirs.
- `runcoms/zpreztorc` — Declares which modules to load and their zstyle configuration.
- `runcoms/zshrc` — Interactive shell setup: Powerlevel10k, fzf, PATH, aliases, history.
- `runcoms/zshenv` — Environment variables (EDITOR, NVM_DIR). Sources `~/.local-env.zsh` for machine-specific secrets.

**Module structure:** Each module in `modules/<name>/` has an `init.zsh` (required) and optionally `functions/`, `external/` (git submodule), and `*.plugin.zsh`. Modules check their own prerequisites and return early if unavailable.

**External dependencies** are git submodules (12 total) under `modules/*/external/`. Update with `git submodule update --init --recursive`.

## OS Portability

- Use `is-darwin`, `is-linux`, `is-bsd` helper functions from `modules/helper/init.zsh` (checks `$OSTYPE`) — not `uname`.
- Never hardcode paths like `/opt/homebrew/...`. Use `brew --prefix` or `$NVM_DIR` etc.
- Modules with OS guards (homebrew, osx, macports) are safe to load unconditionally — they no-op on unsupported platforms.

## Code Style

Follows [Google Shell Style Guide](https://google.github.io/styleguide/shell.xml) with:
- 2-space indent, LF line endings (see `.editorconfig`)
- Use `local` variables whenever possible
- Prefer `zstyle` over environment variables for module configuration
- Prefer `(( ... ))` over `[[ ... ]]` for arithmetic
- Use the `function` keyword to define functions
- 80 char limit can be waived for readability

## Development Setup

To test changes without affecting the active shell:
```sh
ZDOTDIR=/path/to/devel-zprezto zsh
```

There is no test suite or linter at the repository level. Test changes by launching a new shell session.

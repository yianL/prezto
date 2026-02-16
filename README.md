# Prezto — Instantly Awesome Zsh (yian's fork)

Prezto is the configuration framework for [Zsh][1]; it enriches the command line
interface environment with sane defaults, aliases, functions, auto completion,
and prompt themes.

## Installation

### Manual

Prezto will work with any recent release of Zsh, but the minimum required
version is **4.3.11**.

1.  Launch Zsh:

    ```console
    zsh
    ```

2.  Clone the repository:

    ```console
    git clone --recursive https://github.com/yianL/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    ```

3.  Create a new Zsh configuration by copying/linking the Zsh configuration
    files provided:

    ```console
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    ```

    Alternatively, run the included helper script which does the same thing
    (using `ln -sf` to overwrite existing symlinks):

    ```console
    ~/.zprezto/link.sh
    ```

    **Note:** If you already have any of the given configuration files, `ln` in
    the manual operation will cause an error. In simple cases, you can load
    Prezto by adding the line `source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"` to
    the bottom of your _`${ZDOTDIR:-$HOME}/.zshrc`_ and keep the rest of your
    Zsh configuration intact. For more complicated setups, we recommend that you
    back up your original configs and replace them with the provided Prezto
    [_`runcoms`_][10].

4.  Set Zsh as your default shell:

    ```console
    chsh -s /bin/zsh
    ```

5.  Open a new Zsh terminal window or tab.

### Troubleshooting

If you are not able to find certain commands after switching to Prezto, modify
the `PATH` variable in _`${ZDOTDIR:-$HOME}/.zprofile`_ then open a new Zsh
terminal window or tab.

## Updating

Run `zprezto-update` to automatically check if there is an update to Prezto.
If there are no file conflicts, Prezto and its submodules will be automatically
updated. If there are conflicts you will be instructed to go into the
`$ZPREZTODIR` directory and resolve them yourself.

To pull the latest changes and update submodules manually:

```console
cd $ZPREZTODIR
git pull
git submodule sync --recursive
git submodule update --init --recursive
```

## Usage

Prezto has many features disabled by default. Read the source code and the
accompanying README files to learn about what is available.

### Modules

1.  Browse [_`modules`_][9] to see what is available.
2.  Load the modules you need in _`${ZDOTDIR:-$HOME}/.zpreztorc`_ and then open
    a new Zsh terminal window or tab.

### Themes

1.  For a list of themes, type `prompt -l`.
2.  To preview a theme, type `prompt -p name`.
3.  Load the theme you like in _`${ZDOTDIR:-$HOME}/.zpreztorc`_ and then
    open a new Zsh terminal window or tab.

    ![sorin theme][2]
    Note that the [_`git`_][11] module may be required for special symbols to
    appear, such as those on the right of the above image. Add `'git'` to the
    `pmodule` list (under `zstyle ':prezto:load' pmodule \` in your
    _`${ZDOTDIR:-$HOME}/.zpreztorc`_) to enable this module.

### External Modules

1.  By default modules will be loaded from [_`/modules`_][9] and _`/contrib`_.
2.  Additional module directories can be added to the
    `:prezto:load:pmodule-dirs` setting in _`${ZDOTDIR:-$HOME}/.zpreztorc`_.

    Note that module names need to be unique or they will cause an error when
    loading.

    ```sh
    zstyle ':prezto:load' pmodule-dirs $HOME/.zprezto-contrib
    ```

## What's in This Fork

### Modules

The following modules are loaded (order matters), configured in
_`zpreztorc`_:

| Module                     | Description                                               |
| -------------------------- | --------------------------------------------------------- |
| `environment`              | Shell options, smart URLs, termcap colors                 |
| `terminal`                 | Window/tab title management                               |
| `tmux`                     | Tmux auto-start and session management                    |
| `utility`                  | General-purpose aliases and functions (safe-ops disabled) |
| `syntax-highlighting`      | Real-time command syntax highlighting                     |
| `history`                  | History options and aliases                               |
| `directory`                | Directory navigation aliases and options                  |
| `spectrum`                 | 256-color terminal utilities                              |
| `history-substring-search` | Arrow-key history search                                  |
| `autosuggestions`          | Fish-like autosuggestions                                 |
| `prompt`                   | Prompt theme loader (set to **Powerlevel10k**)            |
| `python`                   | Virtualenv auto-switch and virtualenvwrapper init         |
| `completion`               | TAB completion via zsh-completions                        |
| `homebrew`                 | Homebrew aliases (works on macOS and Linux)                |
| `fzf-tab`                  | FZF-powered tab completion                                |
| `zsh-fzf-history-search`   | FZF-powered history search                                |

### Prompt

- The prompt theme is [**Powerlevel10k**][12] (configured in _`p10k.zsh`_).

### Custom Aliases & Functions

Defined in _`zshrc`_:

| Alias / Function | Command                                     |
| ---------------- | ------------------------------------------- |
| `venv`           | `source env/bin/activate`                   |
| `guc`            | `git reset --soft HEAD~` (undo last commit) |
| `gco`            | `git checkout`                              |
| `gs`             | `git status`                                |
| `gaa`            | `git add .`                                 |
| `gcm`            | `git commit -m`                             |
| `gsm`            | `git stash -m`                              |
| `gsp`            | `git stash pop`                             |
| `gsl`            | `git stash list`                            |
| `tma <name>`     | Create or attach to a tmux session          |

### Development Tool Integration

- **NVM** (Node.js) — loaded from `$NVM_DIR` or via `brew --prefix nvm` (no hardcoded paths)
- **pyenv** — Python version management (loaded if `pyenv` is on `PATH`)
- **Python virtualenv** — auto-switches on `cd` into a project directory
- **Cargo** — Rust toolchain (`~/.cargo/bin`)
- **pnpm** — added to `PATH` from `~/.local/share/pnpm`
- **dotnet** — `DOTNET_ROOT` set dynamically via `brew --prefix` if available

### Platform-Specific Behavior

The configuration uses dynamic detection (no hardcoded paths) and adjusts:

|              | macOS                                          | Linux                                           |
| ------------ | ---------------------------------------------- | ----------------------------------------------- |
| **NVM**      | Loaded via `brew --prefix nvm`                 | Loaded from `$NVM_DIR/nvm.sh`                   |
| **Homebrew** | `brew shellenv` (auto-detects prefix)          | `brew shellenv` (if Linuxbrew is installed)     |
| **Docker**   | Default socket                                 | `DOCKER_HOST` set via `$XDG_RUNTIME_DIR`        |

### Private Configuration

Machine-specific or secret environment variables can be placed in
`~/.local-env.zsh`, which is sourced from _`zshenv`_ if it exists. This
file is not tracked by git.

## Tmux

This fork includes a custom tmux configuration in [`modules/tmux/`](modules/tmux#readme)
with a setup script for bootstrapping on a new machine.

**Quick start:**

```console
bash ~/.zprezto/modules/tmux/setup.sh
```

This installs tmux (via Homebrew or apt), symlinks the config to
`~/.config/tmux/tmux.conf`, clones [TPM](https://github.com/tmux-plugins/tpm),
and installs plugins.

Key customizations: `C-Space` prefix, mouse mode, Alt-arrow pane switching
(cross-platform), and the [minimal-tmux-status](https://github.com/niksingh710/minimal-tmux-status)
theme. See the [module README](modules/tmux#readme) for full details.

## Customization

The project is managed via [Git][3]. We highly recommend that you fork this
project so that you can commit your changes and push them to your fork on
[GitHub][4] to preserve them. If you do not know how to use Git, follow this
[tutorial][5] and bookmark this [reference][6].

## Resources

The [Zsh Reference Card][7] and the [zsh-lovers][8] man page are indispensable.

## License

This project is licensed under the MIT License.

[1]: https://www.zsh.org
[2]: https://i.imgur.com/nrGV6pg.png "sorin theme"
[3]: https://git-scm.com
[4]: https://github.com
[5]: https://gitimmersion.com
[6]: https://git.github.io/git-reference/
[7]: http://www.bash2zsh.com/zsh_refcard/refcard.pdf
[8]: https://grml.org/zsh/zsh-lovers.html
[9]: modules#readme
[10]: runcoms#readme
[11]: modules/git#readme
[12]: https://github.com/romkatv/powerlevel10k

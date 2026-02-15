# Tmux

Defines [_tmux_][1] aliases and provides for auto launching it at start-up.

## Settings

### Auto-Start

Starts a tmux session automatically when Zsh is launched.

To enable this feature when launching Zsh in a local terminal, add the following
line to _`${ZDOTDIR:-$HOME}/.zpreztorc`_:

```sh
zstyle ':prezto:module:tmux:auto-start' local 'yes'
```

To enable this feature when launching Zsh in a SSH connection, add the following
line to _`${ZDOTDIR:-$HOME}/.zpreztorc`_:

```sh
zstyle ':prezto:module:tmux:auto-start' remote 'yes'
```

In both cases, it will create a background session named _prezto_ if the tmux
server is not started.

You can change the default session name with:

```sh
zstyle ':prezto:module:tmux:session' name '<YOUR DEFAULT SESSION NAME>'
```

With `auto-start` enabled, you may want to control how multiple sessions are
managed. The `destroy-unattached` option of tmux controls if the unattached
sessions must be kept alive, making sessions available for later use, configured
in _tmux.conf_:

```conf
set-option -g destroy-unattached [on | off]
```

#### iTerm2 Integration

[iTerm2][6] offers significant integration with tmux. This can be enabled by
adding the following line to _`${ZDOTDIR:-$HOME}/.zpreztorc`_:

```sh
zstyle ':prezto:module:tmux:iterm' integrate 'yes'
```

Read [iTerm2 and tmux Integration][7] for more information.

## Aliases

- `tmuxa` attaches or switches to a tmux session.
- `tmuxl` lists sessions managed by the tmux server.

## Caveats

On macOS, launching tmux can cause the error **launch_msg(...): Socket is not
connected** to be displayed, which can be fixed by installing
[reattach-to-user-namespace][3], available in [Homebrew][4], and adding the
following to _tmux.conf_:

```conf
set-option -g default-command "reattach-to-user-namespace -l $SHELL -l"
```

Furthermore, tmux is known to cause **kernel panics** on macOS. A discussion
about this and Prezto has already been [opened][2].

## Custom Configuration

This module includes a custom `tmux.conf` and a `setup.sh` script for
bootstrapping tmux on a new machine.

### What's in the config

| Setting | Value |
|---|---|
| Prefix | `C-Space` (instead of default `C-b`) |
| Mouse | Enabled |
| Base index | 1 |
| Split panes | `prefix "` horizontal, `prefix =` vertical (opens in current path) |
| Switch panes | Alt-arrow keys (cross-platform, see below) |
| Switch windows | `Shift-Left` / `Shift-Right` |
| Reload config | `prefix r` |
| Terminal | `tmux-256color` |

**Plugins** (managed by [TPM](https://github.com/tmux-plugins/tpm)):

- `tmux-plugins/tmux-sensible` — sensible defaults
- `nhdaly/tmux-better-mouse-mode` — improved scroll behavior
- `niksingh710/minimal-tmux-status` — minimal status bar theme

### Setup on a new machine

```sh
bash ~/.zprezto/modules/tmux/setup.sh
```

The script will:
1. Install tmux via Homebrew (macOS) or apt (Ubuntu/Debian)
2. Symlink the repo's `tmux.conf` to `~/.config/tmux/tmux.conf`
3. Clone TPM and install plugins

If `~/.config/tmux/tmux.conf` already exists (and isn't a symlink), it will be
backed up to `tmux.conf.bak` before linking.

### Platform differences

The Alt-arrow pane-switching keybindings differ by OS:

- **macOS**: The Option key produces special characters (`¬`, `æ`, `π`, `…`),
  which are bound directly.
- **Linux**: Uses standard `M-Left`, `M-Right`, `M-Up`, `M-Down` Meta-key
  sequences.

The config handles this automatically via `if-shell "uname | grep -q Darwin"`.

## Authors

_The authors of this module should be contacted via the [issue tracker][5]._

- [Sorin Ionescu](https://github.com/sorin-ionescu)
- [Colin Hebert](https://github.com/ColinHebert)
- [Georges Discry](https://github.com/gdiscry)
- [Xavier Cambar](https://github.com/xcambar)

[1]: https://tmux.github.io/
[2]: https://github.com/sorin-ionescu/prezto/issues/62
[3]: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
[4]: https://github.com/mxcl/homebrew
[5]: https://github.com/sorin-ionescu/prezto/issues
[6]: https://iterm2.com
[7]: https://gitlab.com/gnachman/iterm2/wikis/TmuxIntegration

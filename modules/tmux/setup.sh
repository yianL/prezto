#!/usr/bin/env bash
#
# setup.sh — Install tmux, link config, and bootstrap TPM plugins.
# Works on macOS (Homebrew) and Ubuntu/Debian (apt).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_SRC="${SCRIPT_DIR}/tmux.conf"
TMUX_CONF_DIR="${HOME}/.config/tmux"
TMUX_CONF_DST="${TMUX_CONF_DIR}/tmux.conf"
TPM_DIR="${TMUX_CONF_DIR}/plugins/tpm"

OS="$(uname -s)"

# 1. Install tmux if missing
if ! command -v tmux &>/dev/null; then
  echo "Installing tmux..."
  case "${OS}" in
    Darwin)
      if ! command -v brew &>/dev/null; then
        echo "Error: Homebrew is required on macOS. Install it from https://brew.sh" >&2
        exit 1
      fi
      brew install tmux
      ;;
    Linux)
      sudo apt update && sudo apt install -y tmux
      ;;
    *)
      echo "Error: Unsupported platform: ${OS}" >&2
      exit 1
      ;;
  esac
else
  echo "tmux is already installed: $(tmux -V)"
fi

# 2. Create config directory
mkdir -p "${TMUX_CONF_DIR}"

# 3. Symlink tmux.conf
if [ -L "${TMUX_CONF_DST}" ]; then
  existing="$(readlink "${TMUX_CONF_DST}")"
  if [ "${existing}" = "${TMUX_CONF_SRC}" ]; then
    echo "tmux.conf symlink already points to repo copy."
  else
    echo "Updating tmux.conf symlink (was: ${existing})"
    ln -sf "${TMUX_CONF_SRC}" "${TMUX_CONF_DST}"
  fi
elif [ -e "${TMUX_CONF_DST}" ]; then
  echo "Backing up existing tmux.conf to ${TMUX_CONF_DST}.bak"
  mv "${TMUX_CONF_DST}" "${TMUX_CONF_DST}.bak"
  ln -s "${TMUX_CONF_SRC}" "${TMUX_CONF_DST}"
else
  ln -s "${TMUX_CONF_SRC}" "${TMUX_CONF_DST}"
fi
echo "Linked: ${TMUX_CONF_DST} -> ${TMUX_CONF_SRC}"

# 4. Clone TPM if not present
if [ ! -d "${TPM_DIR}" ]; then
  echo "Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"
else
  echo "TPM already installed at ${TPM_DIR}"
fi

# 5. Install plugins via TPM
if [ -x "${TPM_DIR}/bin/install_plugins" ]; then
  echo "Installing tmux plugins..."
  "${TPM_DIR}/bin/install_plugins"
else
  echo "Note: Start tmux and press prefix + I to install plugins."
fi

echo ""
echo "Done! Launch tmux to verify your config."

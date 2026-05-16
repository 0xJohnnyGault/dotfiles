#!/usr/bin/env bash

set -eEo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# --- Detect OS ---
case "$OSTYPE" in
  darwin*)
    ID="macos"
    ID_LIKE="darwin"
    ;;
  linux*)
    if [[ -r /etc/os-release ]]; then
      # shellcheck source=/dev/null
      source /etc/os-release
    else
      echo "Cannot detect Linux distro (no /etc/os-release)" >&2
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OSTYPE" >&2
    exit 1
    ;;
esac

# shellcheck source=/dev/null
source "$DOTFILES_DIR/lib/common.sh"
source_distro_file "$DOTFILES_DIR/lib/packages.sh"

info "OS:      $ID_LIKE-$ID"
info ""

prepare_distro
install_packages
stow_packages

info ""
info "Installation complete."

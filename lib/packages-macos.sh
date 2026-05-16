#!/usr/bin/env bash
# macOS package map. Sourced by install.sh.

is_installed() {
  brew list "$1" &>/dev/null || brew list --cask "$1" &>/dev/null
}

PKG_INSTALL="brew install"

# Always install
CORE_PKGS=(
  git zsh stow fzf eza zoxide neovim tmux ripgrep mosh asdf
)

# Server profile additions
SERVER_PKGS=(
  lazygit yazi btop
)

# Desktop profile additions (macOS GUI apps via cask)
DESKTOP_CASKS=(
  zed ghostty
)

# Stow lists per profile
STOW_CORE=(zsh git nvim tmux ssh)
STOW_SERVER=(lazygit yazi btop)
STOW_DESKTOP=(macos-tools ideavim)

# macOS-specific bootstrap
bootstrap_pkgmgr() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $(uname -m) == 'arm64' ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}

brew bundle --file="$DOTFILES_DIR/Brewfile"

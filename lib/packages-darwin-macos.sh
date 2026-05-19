#!/usr/bin/env bash

prepare_distro() {
  info "Preparing distro..."
  bootstrap_pkgmgr
}

install_packages() {
  info "Installing packages..."
  brew install \
    atuin \
    btop \
    curl \
    eza \
    fd \
    fzf \
    git \
    jq \
    just \
    lazydocker \
    lazygit \
    mise \
    neovim \
    ripgrep \
    starship \
    stow \
    tig \
    vim \
    wget \
    zellij \
    zoxide 

  brew services start atuin
  brew install --cask font-0xProto-nerd-font
  brew install --cask ghostty

  
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
}

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

stow_packages() {
  info "Stowing packages..."
  backup_dotfiles
  stow -t "$HOME" -R zsh
  stow -t "$HOME" -R atuin
  stow -t "$HOME" -R starship
  stow -t "$HOME" -R ghostty
}

backup_dotfiles() {
  local DATE
  DATE=$(date +%Y%m%d%H%M%S)

  for F in "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.config/atuin/config.toml" "$HOME/.config/starship.toml"; do
    if [ -f "$F" ]; then
      mv "$F" "${F}-${DATE}"
      info "Backed up $F to ${F}-${DATE}"
    fi
  done
}


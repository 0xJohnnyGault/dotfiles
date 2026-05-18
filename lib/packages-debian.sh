#!/usr/bin/env bash

prepare_distro() {
  info "Preparing distro..."
}

install_packages() {
  info "Installing packages..."
  sudo apt install -y --no-install-recommends \
    build-essential \
    btop \
    curl \
    eza \
    fd-find \
    fzf \
    git \
    jq \
    just \
    neovim \
    ripgrep \
    stow \
    tig \
    vim \
    wget \
    zoxide \
    zsh 

  # fd is fdfind on Ubuntu, so we need to symlink it to ~/.local/bin/fd
  mkdir -p ~/.local/bin
  [ -e ~/.local/bin/fd ] || ln -s "$(which fdfind)" ~/.local/bin/fd

  curl --proto '=https' --tlsv1.2 -LsSf https://mise.run | sh
  curl --proto '=https' --tlsv1.2 -LsSf https://starship.rs/install.sh | sh -s -- --yes -b ~/.local/bin
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
}

stow_packages() {
  info "Stowing packages..."
  backup_dotfiles
  stow -t "$HOME" -R zsh
  stow -t "$HOME" -R atuin
  stow -t "$HOME" -R starship
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

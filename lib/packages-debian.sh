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
    fastfetch \
    fd-find \
    fzf \
    gcc \
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
  curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

stow_packages() {
  info "Stowing packages..."
  # atuin creates a .zshrc so we need to delete it
  rm -f "$HOME/.zshrc"
  stow -t "$HOME" -R zsh
  stow -t "$HOME" -R atuin
  stow -t "$HOME" -R starship
}

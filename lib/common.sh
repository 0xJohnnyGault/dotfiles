#!/usr/bin/env bash
# Shared helpers
# Source this file; do not execute directly.

# --- Color output ---
if [[ -t 1 ]]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[1;33m'
  NC=$'\033[0m'
else
  RED=""; GREEN=""; YELLOW=""; NC=""
fi

info()  { echo -e "${GREEN}==>${NC} $*"; }
warn()  { echo -e "${YELLOW}WARN:${NC} $*" >&2; }
error() { echo -e "${RED}ERROR:${NC} $*" >&2; }


# Usage: source_distro_file <basefile>
# Sources: <basefile>-$ID_LIKE-$ID, else <basefile>-$ID_LIKE, else <basefile>, else error.
source_distro_file() {
  local basefile="${1%.*}"
  local try
  local sourced=0

  if [[ -n "$ID_LIKE" && -n "$ID" && -f "${basefile}-${ID_LIKE}-${ID}.sh" ]]; then
    try="${basefile}-${ID_LIKE}-${ID}.sh"
    # shellcheck source=/dev/null
    source "$try"
    sourced=1
  elif [[ -n "$ID_LIKE" && -f "${basefile}-${ID_LIKE}.sh" ]]; then
    try="${basefile}-${ID_LIKE}.sh"
    # shellcheck source=/dev/null
    source "$try"
    sourced=1
  elif [[ -f "$basefile.sh" ]]; then
    try="$basefile.sh"
    # shellcheck source=/dev/null
    source "$try"
    sourced=1
  fi

  if [[ $sourced -eq 0 ]]; then
    error "No suitable distro file found for ${basefile} (tried ${basefile}-${ID_LIKE}-${ID}.sh, ${basefile}-${ID_LIKE}.sh, $basefile.sh)"
    exit 1
  fi
}

# --- Assumes caller has set DOTFILES_DIR and PKG_INSTALL ---

# is_installed PKG — return 0 if installed, 1 otherwise.
# Per-OS implementations override this in packages-<os>.sh.

# install_packages PKG... — install only the missing ones.
install_packages() {
  local to_install=()
  local pkg
  for pkg in "$@"; do
    if is_installed "$pkg"; then
      info "$pkg already installed"
    else
      to_install+=("$pkg")
    fi
  done
  if [[ ${#to_install[@]} -gt 0 ]]; then
    info "Installing: ${to_install[*]}"
    # PKG_INSTALL is intentionally unquoted so multi-word commands
    # (e.g. "sudo apt-get install -y") word-split into argv correctly.
    # shellcheck disable=SC2086
    $PKG_INSTALL "${to_install[@]}"
  fi
}

# stow_packages PKG... — restow each (idempotent).
stow_packages() {
  local pkg
  cd "$DOTFILES_DIR" || return 1
  for pkg in "$@"; do
    if [[ -d "$pkg" ]]; then
      info "Stowing: $pkg"
      stow -R "$pkg"
    else
      warn "Package directory not found: $pkg"
    fi
  done
}

# backup_file PATH — if PATH exists and isn't a symlink, mv it to PATH.bak-TIMESTAMP.
backup_file() {
  local path="$1"
  if [[ -e "$path" && ! -L "$path" ]]; then
    local backup
    backup="${path}.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$path" "$backup"
    info "Backed up $path → $backup"
  fi
}
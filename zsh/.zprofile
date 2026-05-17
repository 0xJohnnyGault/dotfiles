# Use .zprofile instead of .zshenv to prevent weirdness with Mac /usr/libexec/path_helper

# Zsh ties the PATH variable to a path array. This allows you to manipulate PATH by simply modifying the path array.
typeset -U PATH path

path=(~/.local/bin $path)
export PATH

export EDITOR='nvim'
export VISUAL="nvim"
export GPG_TTY="${TTY:-$(tty)}"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

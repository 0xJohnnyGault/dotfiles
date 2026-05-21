# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(starship fzf-tab zoxide zsh-autosuggestions mise)
source $ZSH/oh-my-zsh.sh

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT
# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER
# Case insensitive globbing
setopt NO_CASE_GLOB
# Be Reasonable!
setopt NUMERIC_GLOB_SORT
# I don't know why I never set this before.
setopt EXTENDED_GLOB
# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

# Home key
bindkey '^[[H' beginning-of-line
bindkey '\e[H' beginning-of-line
bindkey '\eOH' beginning-of-line

# End key
bindkey '^[[F' end-of-line
bindkey '\e[F' end-of-line
bindkey '\eOF' end-of-line

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a -1 --no-quotes --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -a -1 --no-quotes --color=always $realpath'
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

export ZOXIDE_CMD_OVERRIDE="cd"
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aaaaaa"


# Aliases
alias aliases='alias | sort'
alias cp='cp -vr'
alias du='du -kh -d 1'       # Makes a more readable output.
alias df='df -kTh'
alias dux='du -x --max-depth=1 | sort -n' # Large directories
alias envs='printenv | sort'
alias gitzip="git archive HEAD -o ${PWD##*/}.zip" # zip but ignore anything not in git
alias ls='eza --git --smart-group --group-directories-first --icons=auto'
alias ll='eza --git --smart-group --group-directories-first --icons=auto -bl'
alias llt='eza --git --smart-group --icons=auto --sort=modified -bl'
alias la='eza --git --smart-group --group-directories-first --icons=auto -bla'
alias mkdir='mkdir -pv'
alias mv='mv -v'
alias rm='rm -vr'
alias vi="nvim"
alias vim="nvim"
alias z='zoxide'
alias za='zellij attach'
alias zls='zellij ls'
alias znew='zellij new'
alias zz='zoxide query'

# OS / distro detection — selects the right shell fragment.
case "$OSTYPE" in
  darwin*)
    DOTFILES_OS="darwin"
    ;;
  linux*)
    DOTFILES_OS="linux"
    if [[ -r /etc/os-release ]]; then
      . /etc/os-release
      case "${ID_LIKE:-$ID}" in
        *arch*)              DOTFILES_OS="linux-arch" ;;
        *debian*|*ubuntu*)   DOTFILES_OS="linux-debian" ;;
      esac
    fi
    ;;
esac

[[ -r "$HOME/.zsh-${DOTFILES_OS}" ]] && source "$HOME/.zsh-${DOTFILES_OS}"

# Machine-local fragment (gitignored, holds gcloud paths, work aliases, etc.)
[[ -r "$HOME/.zsh-local.sh" ]] && source "$HOME/.zsh-local.sh"

# Up arrow does regular search, and ctrl-R uses Atuin TUI
unset HISTFILE
eval "$(atuin init zsh --disable-up-arrow)"
fc -R =(atuin search --cmd-only --limit 500)
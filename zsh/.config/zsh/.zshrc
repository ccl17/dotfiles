# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

# cmp options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

setopt append_history inc_append_history share_history
setopt auto_menu menu_complete
setopt auto_cd
setopt auto_param_slash
setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
setopt interactive_comments

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

PROMPT="  %1~ $ "

# binds
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^j" backward-word
bindkey "^k" forward-word

# fzf setup
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# aliases
alias vim='nvim'

alias ls='ls --color=auto'
alias ll='ls -la'

alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glo='git log'
alias grs='git restore'
alias gd='git diff'
alias grb='git rebase'

source "$ZDOTDIR/macos.zsh"

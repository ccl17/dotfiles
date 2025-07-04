autoload -U compinit; compinit

zstyle ':completion:*' menu select

setopt auto_cd # auto cd if command is a directory and not executable

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt SHARE_HISTORY

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# edit commandline in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# search backward
bindkey '^R' history-incremental-search-backward

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

alias t='tmux'
alias ts='tmux new -s'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tkss='tmux kill-session -t'
alias tksv='tmux kill-server'

source "$ZDOTDIR/macos.zsh"

# this file needs to be located in $HOME

# XDG based specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export VISUAL="nvim"
export EDITOR="nvim"

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000 # max events for internal history
export SAVEHIST=10000 # max events in history file

# exclude path separator from wordchars
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# environment
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH

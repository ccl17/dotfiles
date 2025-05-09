export ZDOTDIR="$HOME/.config/zsh"

export VISUAL="nvim"
export EDITOR="nvim"

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000 # max events for internal history
export SAVEHIST=10000 # max events in history file

# exclude path separator from wordchars
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# environment
export PATH=${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH

# starship
export STARSHIP_HOME="$HOME/.config/starship"
export STARSHIP_CONFIG="$STARSHIP_HOME/starship.toml"
export STARSHIP_CACHE="$STARSHIP_HOME/cache"

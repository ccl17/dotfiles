# environment
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/opt/nvim-linux64/bin:/usr/local/go/bin:$HOME/go/bin:$PATH

# text editor
export EDITOR=nvim
export VISUAL=nvim

# history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$ZDOTDIR/.zsh_history"

# autosuggestions
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# autocomplete
source "$ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# case insensitive matching
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# syntax highlighting colortheme
source "$ZDOTDIR/plugins/catppuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# syntax highlighting
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# aliases
alias vim=nvim

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# prompt
if exists starship; then
  export STARSHIP_HOME="$HOME/.config/starship"
  export STARSHIP_CONFIG="$STARSHIP_HOME/starship.toml"
  export STARSHIP_CACHE="$STARSHIP_HOME/cache"
  eval "$(starship init zsh)"
fi

# zoxide
if exists zoxide; then
  eval "$(zoxide init zsh)"
fi

# rbenv
if exists rbenv; then
  eval "$(rbenv init - zsh)"
fi

# nvm
if exists nvm; then
  export NVIM_DIR="$HOME/.nvm"
  [ -s "$NVIM_DIR/nvm.sh" ] && \. $"NVM_DIR/nvm.sh" # this loads nvm
  [ -s "NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # this load nvm bash completion
fi

if exists pyenv; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

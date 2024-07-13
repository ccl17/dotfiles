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

# brew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# case insensitive matching
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# syntax highlighting colortheme
source "$ZDOTDIR/plugins/catppuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# aliases
alias vim=nvim
alias ff="fzf --preview '$ZDOTDIR/scripts/fzf_preview.sh {}'"

# git
alias ga="git add"
alias gb="git branch"
alias gcm="git commit -m"
alias gco="git checkout"
alias gp="git push"
alias gst="git status"

# starship
export STARSHIP_HOME="$HOME/.config/starship"
export STARSHIP_CONFIG="$STARSHIP_HOME/starship.toml"
export STARSHIP_CACHE="$STARSHIP_HOME/cache"
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# load all env specific configs
for config (${ZDOTDIR}/*.zsh) source $config

# syntax highlighting
# needs to be sourced last
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# environment
export PATH=$PATH

# text editor
export EDITOR=nvim
export VISUAL=nvim

# history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$ZDOTDIR/.zsh_history"

# prompt
export STARSHIP_HOME="$HOME/.config/starship"
export STARSHIP_CONFIG="$STARSHIP_HOME/starship.toml"
export STARSHIP_CACHE="$STARSHIP_HOME/cache"
eval "$(starship init zsh)"

# autosuggestions
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# autocomplete
source "$ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# syntax highlighting colortheme
source "$ZDOTDIR/plugins/catppuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# syntax highlighting
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# environment
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/opt/nvim-linux64/bin:/usr/local/go/bin:$HOME/go/bin:$PATH

# text editor
export EDITOR=nvim
export VISUAL=nvim

# brew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# aliases
alias vim=nvim

# starship
export STARSHIP_HOME="$HOME/.config/starship"
export STARSHIP_CONFIG="$STARSHIP_HOME/starship.toml"
export STARSHIP_CACHE="$STARSHIP_HOME/cache"
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# load all env specific configs
for config (${ZDOTDIR}/*.zsh) source $config

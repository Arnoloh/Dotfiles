# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.

export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="mytheme"


plugins=(
    copypath
    colored-man-pages
    git
    zsh-autosuggestions
    virtualenv
)
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$PATH:~/.config/command
export EDITOR='nvim'
export VISUAL='nvim'


vim() {

    if command -v nvim >/dev/null 2>&1; then
        nvim "$@"
    else
        /usr/bin/vim "$@"
    fi
}


function cat() {
  emulate -L zsh

  if command -v bat >/dev/null 2>&1; then
    if bat "$@" >/dev/null 2>&1; then
      bat -pp "$@"
      return
    fi
  fi

  command cat "$@"
}

export PATH=$PATH:~/.local/bin
unsetopt autocd
eval "$(zoxide init --cmd cd zsh)"

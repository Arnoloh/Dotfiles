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
)
source $ZSH/oh-my-zsh.sh

# User configuration
PATH=$PATH:~/.config/command
alias py="python3"
alias vim="nvim"
alias cat="bat -pp"

unsetopt autocd


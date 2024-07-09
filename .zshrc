# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.

export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="mytheme"

command -v macchina >/dev/null && macchina || echo "Macchina command do not exits, please install it"

plugins=(
    copypath
    colored-man-pages
    git
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# User configuration



alias tree="eza -T "
alias py="python3"
alias vim="nvim"
alias vi="nvim"
alias ls="eza "
alias cat="bat -pp"

unsetopt autocd

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="$HOME/bin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public:/opt/X11/bin:~/.dotnet/tools:/Library/Apple/usr/bin:/Users/arnoloh/Library/Application Support/JetBrains/Toolbox/scripts:/Users/arnoloh/bin:/Users/arnoloh/.config/command:/Users/arnoloh/.docker/bin"
source "$HOME/.cargo/env"

alias make="make -j16"
alias utmlctl=/Applications/UTM.app/Contents/MacOS/utmctl
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"

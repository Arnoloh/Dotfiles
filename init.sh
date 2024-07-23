RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

pass() {
    echo "${GREEN}$1${WHITE}" 
}
echec() {
    echo "${RED}$1${WHITE}" 
}

git clone  git@github.com:Arnoloh/Dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

cp /tmp/dotfiles/.zshrc ~/
cp /tmp/dotfiles/mytheme.zsh-theme ~/.oh-my-zsh/themes/

cp /tmp/dotfiles/.gitignore ~/
cp /tmp/dotfiles/.gitconfig ~/
cp /tmp/dotfiles/.clang-format ~/

[ -d ~/.config/ ] || mkdir ~/.config && pass ".config already exist"
[ -d ~/.config/command ] || mkdir ~/.config/command && pass ".config/command already exist"


cp /tmp/dotfiles/sub ~/.config/command/
chmod 777 ~/.config/command/sub 

sed -i "s/macos/$(grep -E '^(NAME)=' /etc/os-release | sed 's/NAME="\(.*\)"/\1/g')/g" ~/.oh-my-zsh/themes/mytheme.zsh-theme

echec "Please install manually all plugin"

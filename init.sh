#!/bin/sh

RED='\033[1;31M'
GREEN='\033[1;32m'
WHITE='\033[1;37m'


pass() {
    echo "${GREEN}$1${WHITE}"
}
fail() {
    echo "${RED}$1${WHITE}"
    exit 1
}

warn() {
    echo "\033[1;33m$1\033[0m"
}

# Prompt for sudo at the beginning to cache credentials
warn "I need to be in sudo mode, can I ?"
if ! sudo -v; then
    fail "This script requires sudo privileges."
fi
pass "Sudo privileges confirmed."

# Define and install required packages
PACKAGES="git curl wget zsh vim batcat bat gcc tldr zsh-syntax-highlighting clangd make clang-format"

if command -v apt >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
    sudo apt update && sudo apt upgrade
elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
elif command -v brew >/dev/null 2>&1; then
    PACKAGE_MANAGER="brew"
else
    fail "No supported package manager found (apt, yum, or brew)."
fi

pass "Using $PACKAGE_MANAGER as the package manager."


# Install packages
for PACKAGE in $PACKAGES; do
    if ! command -v "$PACKAGE" >/dev/null 2>&1; then
        sudo $PACKAGE_MANAGER install -y "$PACKAGE" && pass "$PACKAGE installed successfully." || warn "Failed to install $PACKAGE."
    else
        pass "$PACKAGE is already installed."
    fi
done

# Check if Zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
    fail "Zsh is not installed. Please install it before continuing."
else
    pass "Zsh is already installed."
fi

# Clone the Dotfiles repository
git clone https://github.com/Arnoloh/Dotfiles.git /tmp/dotfiles
pass "Successfully cloned the Dotfiles repository."

cd /tmp/dotfiles || fail "Failed to access the /tmp/dotfiles directory."

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || fail "Failed to install Oh My Zsh."
pass "Oh My Zsh installed successfully."

# Copy configuration files
cp .zshrc "$HOME" || fail "Failed to copy .zshrc."
cp mytheme.zsh-theme "$HOME/.oh-my-zsh/themes/" || fail "Failed to copy the Zsh theme."
pass "Zsh configuration files copied successfully."

cp .gitignore "$HOME" || fail "Failed to copy .gitignore."
cp .gitconfig "$HOME" || fail "Failed to copy .gitconfig."
cp .clang-format "$HOME" || fail "Failed to copy .clang-format."
pass "Git and clang configuration files copied successfully."

# Create necessary directories
[ -d "$HOME/.config/" ] || mkdir "$HOME/.config" || fail "Failed to create the .config directory."
pass "The .config directory exists or has been created successfully."

[ -d "$HOME/.config/command" ] || mkdir "$HOME/.config/command" || fail "Failed to create the .config/command directory."
pass "The .config/command directory exists or has been created successfully."

# Copy and configure scripts
cp sub "$HOME/.config/command/" || fail "Failed to copy the sub script."
chmod 777 "$HOME/.config/command/sub" || fail "Failed to set permissions for the sub script."
pass "The sub script has been copied and configured successfully."

# Modify the theme with the detected operating system
OS_NAME=$(grep -E '^(NAME)=' /etc/os-release | sed 's/NAME="\(.*\)"/\1/')
sed -i "s@macos@$OS_NAME@g" "$HOME/.oh-my-zsh/themes/mytheme.zsh-theme" || warn "Failed to modify the theme."
pass "Theme updated successfully with the detected operating system."

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || warn "Failed to install the zsh-autosuggestions plugin."
pass "The zsh-autosuggestions plugin has been installed successfully."

git clone https://github.com/Arnoloh/nvim-config.git ~/.config/nvim || warn "nvim config already installed"

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh && pass "zoxide installed" 

if [ "$PACKAGE_MANAGER" = "brew" ]; then
    brew install neovim
    pass "neovim has been installed."
elif [ "$PACKAGE_MANAGER" = "apt" ]; then
    curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz || fail "neovim installation failed." &&
    sudo rm -rf /opt/nvim &&
    sudo tar -C /opt -xzf nvim*.tar.gz &&
    nvim_path=$(find /opt -type f -name nvim 2>/dev/null | head -n 1) || fail "Cannot find nvim in /opt"
    ln -sf "$nvim_path" ~/.config/command/nvim || fail "cannot symlink nvim in ~/.config/command/" &&
    ${nvim_path} --headless "+Lazy! sync" +qa && 
    pass "neovim has been installed."
else
    warn "Please install neovim https://github.com/neovim/neovim/releases/"
fi

#  Cleanup
rm -rf /tmp/dotfiles || fail "Failed to clean up temporary files."
pass "Temporary files cleaned up successfully."
zsh


#!/bin/bash

set -e #Exit immediately if a command exits with a non-zero status
ROOT_PATH=$(pwd -P)


main() {

    # get_arch
    # ARCH="$RETVAL"

    # setup_git
    install_homebrew
    install_languages
    install_shell
    install_terminal
    install_tools
    # #NOTE terminal installation needs to be partially manual until alacritty is updated in homebrew for M1's 
    install_neovim
}


install_homebrew() {
    if ! which /opt/homebrew/bin/brew >/dev/null 2>&1; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        info "Homebrew has already been installed."
    fi
}

install_languages() {
    brew install go || true

    if ! which rustup >/dev/null 2>&1; then
        info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source ~/.cargo/env

        # Rust toolchains and commands
        rustup component add clippy
        rustup target add \
            wasm32-wasi wasm32-unknown-unknown wasm32-unknown-unknown --toolchain nightly

    else
        info "Rust has already been installed. Updating Rust..."
        rustup update
    fi
}


install_shell() {
    # Settings for zsh plugins are in .zshrc
    brew tap homebrew/cask-fonts
    brew install --cask font-code-new-roman-nerd-font
    brew install --cask font-jetbrains-mono-nerd-font
    # Hack nerd font has to be installed manually for now.
    # https://github.com/ryanoasis/nerd-fonts/issues/1003
    # brew install --cask font-hack-nerd-font
    # brew install romkatv/powerlevel10k/powerlevel10k

    sym_link $ROOT_PATH/.zshrc ~/.zshrc
}


install_terminal() {
    brew install --cask alacritty

    info "Configuring terminal..."
    mkdir -p ~/.config
    sym_link $ROOT_PATH/alacritty ~/.config/alacritty

    # if [[ $ARCH == *"darwin"* ]] || [[ $ARCH == *"arm64"* ]]; then
    #     info "macOs detected, 'open' alacritty in finder to seed permissions"
    #     open /Applications
    # fi
}


install_tools() {
    brew install zellij htop
    brew install --cask visual-studio-code || true

    mkdir -p ~/.config
    sym_link $ROOT_PATH/zellij ~/.config/zellij

    mkdir -p ~/Library/Application\ Support/Code/User
    cp -rf vscode/* ~/Library/Application\ Support/Code/User/
}


install_neovim() {
    brew install neovim || true
    info "Configuring neovim..."

    mkdir -p ~/.config
    sym_link $ROOT_PATH/nvim ~/.config/nvim

    nvim --headless +so $ROOT_PATH/nvim/lua/lc/packer.lua +PackerSync +qall
}


## Utils

info() {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

sym_link() {
    if [ -e "$2" ]; then
        if [ "$(readlink "$2")" = "$1" ]; then
            info "Symlink skipped $1"
            return 0
        else
            mv "$2" "$2.bak"
            info "Symlink moved $2 to $2.bak"
        fi
    fi
    ln -sf "$1" "$2"
    info "Symlinked $1 to $2"
}


main "$@"

#!/bin/bash

set -e

PACKAGE_MANAGER=""
SUDO_CMD="sudo "
PACKAGES=""
PACKAGES_FULL=""

INF() {
    MSG="$1"
    echo "[$(date)][INF] --- $MSG"
}

ERR() {
    MSG="$1"
    echo "[$(date)][ERR] --- $MSG"
}

declare -r COMMON_BASE=" \
    vim \
    neovim \
    gcc \
    make \
    binutils \
    zsh \
    autoconf \
    automake \
    cmake \
    shellcheck \
"

declare -r UBUNTU_BASE=" \
    build-essential \
    libyajl-dev \
    libev-dev \
    python3-dev \
    exuberant-ctags \
    clang-format \
"
declare -r FEDORA_BASE=" \
    yajl-devel \
    libverto-libev-devel \
    ctags \
    vim-omnicppcomplete \
    python3-devel \
"

declare -r FEDORA_DEV_GROUP="C Development Tools and Libraries"

declare -r COMMON_GRAPHICAL=" \
    emacs \
    i3 \
    autorandr \
    feh \
    i3-gaps \
    i3blocks \
"

prepare_ubuntu() {
    INF "Updating ubuntu"
    ${SUDO_CMD} "${PACKAGE_MANAGER}" update -y
    ${SUDO_CMD} "${PACKAGE_MANAGER}" upgrade -y
    ${SUDO_CMD} "${PACKAGE_MANAGER}" dist-upgrade -y
}

prepare_fedora() {
    INF "Updating fedora"
    ${SUDO_CMD} "${PACKAGE_MANAGER}" update -y
    ${SUDO_CMD} "${PACKAGE_MANAGER}" upgrade -y

    # Unfortunately, in Fedora you can group applications cannot be installed via yum install but need to be handled differently
    # Since I don't want to differentiate between ubuntu & fedora later, I need to install them here
    ${SUDO_CMD} "${PACKAGE_MANAGER}" group install -y "${FEDORA_DEV_GROUP}"
}

configure_zsh() {
    INF "Configure zsh"
    
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cd ~/.oh-my-zsh/custom/plugins/ && git clone https://github.com/zsh-users/zsh-autosuggestions && cd -

    install $(pwd)/.bashrc "$HOME"
    install $(pwd)/.zshrc "$HOME"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    install $(pwd)/.p10k.zsh "$HOME"
}

configure_vim() {
    INF "Configure vim"

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    install -d $(pwd)/.vim 
    cp -a $(pwd)/.vim/* -t "$HOME"/.vim
    install $(pwd)/.vimrc "$HOME"
}

configure_graphics() {
    INF "Configure i3"
    install -d $HOME/.config/i3
    install $(pwd)/i3/* "$HOME/.config/i3"
}

show_postinstall_instructions() {
    echo ""
    echo "=================== INSTALLATION COMPLETE ===================" 
    echo " Open vim and run \':PluginInstall\'"
    echo ""
    echo " afterwards install YCM: python ~/.vim/bundle/YouCompleteMe/install.py"
    echo ""
}

install_base() {
    INF "Start base installation"

    if [[ "$PACKAGE_MANAGER" == "yum" ]]; then
        prepare_fedora
    elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        prepare_ubuntu
    fi

    ${SUDO_CMD} "${PACKAGE_MANAGER}" install -y ${PACKAGES}

    configure_zsh
    configure_vim

    show_postinstall_instructions
}


install_graphics() {
    INF "Start installation of i3 packages"

    ${SUDO_CMD} "${PACKAGE_MANAGER}" install -y ${PACKAGES_FULL}

    # don't forget to install i3 gaps
    configure_graphics
}

usage() {
    echo "Usage: "
    echo "      $0 -ibuh"
    echo "      -h|--help:      Print this message"
    echo "      -i|--install:   Install the current configuration for grphical usage on the machine (this also installs the console config)"
    echo "      -b|--base:      Install the current configuration for console only usage on the machine"
    echo "      -u|--update:    Copy the configuration and update the repository"
    echo "                      This option is ment to be run as a coronjon"
}


update_config() {
    ERR "Not Yet Implemented"
    #DIRTY_FILES
    exit 1
}

FULL_PATH=$(realpath "$0")
REL_DIR=$(dirname "$FULL_PATH")
SOURCE_DIR="$REL_DIR/home"

if [[ $(which apt) ]]; then
    INF "Ubuntu found. Using apt"
    PACKAGE_MANAGER="apt"
    PACKAGES="$COMMON_BASE $UBUNTU_BASE"
    PACKAGES_FULL="$PACKAGES $COMMON_GRAPHICAL"  
elif [[ $(which yum) ]]; then
    INF "Fedora found. Using yum"
    PACKAGE_MANAGER="yum"
    PACKAGES="$COMMON_BASE $FEDORA_BASE"
    PACKAGES_FULL="$PACKAGES $COMMON_GRAPHICAL"
else
    ERR "Unsupported distribuion. I don't like change. Bailing out."
    exit 1
fi

for i in "$@"; do
  case $i in
    -i|--install)
        install_graphics
        ;&
    -b|--base)
        install_base
        ;;
    -u|--update)
        update_config
        exit 0;;
    -h|--help)
        usage
        exit 0;;
    *)
        ERR "Could not determine command line argument."
        usage
        exit 0
        ;;
  esac
done

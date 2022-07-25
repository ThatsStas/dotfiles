#!/bin/bash

INF()
{
    MSG="$1"
    echo "[$(date)][INF] --- $MSG"
}

ERR()
{
    MSG="$1"
    echo "[$(date)][ERR] --- $MSG"
}


# Now, only ubuntu based OS are supported. This approach should be simple to extend
declare -r I3_PACKAGES_COMMON=" \
    libstartup-notification0-dev \
    libxcb-xrm0 \
    i3 \
    i3blocks \
    libxcb1-dev \
    libxcb-keysyms1-dev \
    libpango1.0-dev \
    libxcb-util0-dev \
    libxcb-icccm4-dev \
    libxcb-randr0-dev \
    libxcb-cursor-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxcb-shape0-dev \
    compton \
    feh \
    libxcb-xrm-dev \
    libxvidcore4 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-alsa \
    gstreamer1.0-fluendo-mp3 \
    gstreamer1.0-libav \
    "

declare -r CMD_PACKAGES_COMMON=" \
    vim \
    gcc \
    make \
    build-essential \
    binutils \
    zsh \
    autoconf \
    automake \
    cmake \
    libyajl-dev \
    libev-dev \
    python3-dev \
    python2.7-dev \
    exuberant-ctags \
    clang-format \
    "

# sudo add-apt-repository -y ppa:regolith-linux/stable 
install_i3_gaps()
{
    VER="$(lsb_release -a 2>&1 | grep Release | xargs | cut -d ' ' -f2)"

    if [[ "$VER" == "22.04" ]]; then
        wget -qO - https://regolith-desktop.org/regolith.key | \
        gpg --dearmor | tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

        echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
            https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
            sudo tee /etc/apt/sources.list.d/regolith.list

    elif [[ "$VER" == "20.04" ]]; then
        wget -qO - https://regolith-desktop.org/regolith.key | apt-key add -

        echo deb "[arch=amd64] https://regolith-desktop.org/release-ubuntu-focal-amd64 focal main" | \
            sudo tee /etc/apt/sources.list.d/regolith.list
    fi
    
    rm -rf regolith.key

    sudo apt update
    sudo apt install i3-gaps
}


install_files()
{

    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    install $(pwd)/.bashrc ~
    install $(pwd)/.vimrc ~
    install $(pwd)/.zshrc ~
    install -d $(pwd)/.i3 ~/.config/
    install -d $(pwd)/.vim ~

   #find $SOURCE_DIR -type f -exec install -Dm 755 "{}" "$TARGET_DIR/{}" \;
}

show_postinstall_instructions()
{
    echo ""
    echo "=================== INSTALLATION COMPLETE ===================" 
    echo " Open vim and run \':PluginInstall\'"
    echo ""
    echo " afterwards install YCM: python ~/.vim/bundle/YouCompleteMe/install.py"
    echo ""

}


install_i3()
{
    INF "Start installation of i3"
    sudo apt install -y "$I3_PACKAGES_COMMON"
}

install_cmd()
{
    INF "Start installation of cmd packages"
    sudo apt install -y "$CMD_PACKAGES_COMMON"

}

install_all()
{
    INF "Starting full installation"

    install_cmd

    install_i3 
   
    install_files

    show_postinstall_instructions
}

usage()
{
    echo "Usage: "
    echo "      $0 -iuh"
    echo "      -h|--help:      Print this message"
    echo "      -i|--install:   Install the current configuratio on the machine"
    echo "      -u|--update:    Copy the configuration and update the repository"
    echo "                      This option is ment to be run as a coronjon"
}


update_config()
{
    ERR "Not Yet Implemented"
    #DIRTY_FILES
}

FULL_PATH=$(realpath $0)
REL_DIR=$(dirname $FULL_PATH)
SOURCE_DIR="$REL_DIR/home"

for i in "$@"; do
  case $i in
    -i|--install)
        install_all
        exit 0 ;;
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


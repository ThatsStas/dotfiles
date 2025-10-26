#!/bin/bash

if [[ ! -f "$HOME/.p10k.zsh" ]]; then                                                                                                                      
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"                      
else
    echo "p10k already install. Skipping"
fi

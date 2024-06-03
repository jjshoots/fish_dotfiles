#!/bin/bash

# try to install fish if it doesn't already exist
if ! command -v fish &> /dev/null
then
    echo "fish not found, installing latest from apt..."
    if ! grep -r "fish-shell/release-3" /etc/apt/sources.list /etc/apt/sources.list.d/; then
        sudo apt-add-repository -y ppa:fish-shell/release-3
    else
        echo "Repository fish-shell/release-3 is already added. Skipping..."
    fi
    sudo apt update && sudo apt upgrade
    sudo apt install fish
    sudo chsh -s /usr/bin/fish
fi

sudo apt install fzf
sudo apt install trash-cli
sudo apt install exa
sudo apt install resolvconf
sudo apt install wireguard
sudo apt install bat
sudo ln -s /usr/bin/batcat ~/.local/bin/bat

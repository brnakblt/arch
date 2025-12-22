#!/bin/bash

setup_aur_helper() {
    if command -v yay &> /dev/null; then
        echo ":: 'yay' is already installed."
        return
    fi

    if command -v paru &> /dev/null; then
        echo ":: 'paru' is installed. Using it."
        # We might need to handle the alias or variable later, but for now assuming yay logic or adapting.
        # Ideally we stick to one. If user has paru, we can just alias yay=paru for this script context or vice versa.
        return
    fi

    echo ":: AUR helper not found. Installing yay..."
    cd /tmp || exit
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd - || exit
    echo ":: yay installed successfully."
}

#!/bin/bash

setup_asus() {
    echo ":: ASUS ROG/TUF Laptop Setup"
    echo "   This setup is for ASUS ROG/Zephyrus/TUF laptops."
    echo "   It enables the g14 repository and installs control tools."
    
    read -p ":: Do you want to set up ASUS ROG/TUF tools (rog-control-center, asusctl)? [y/N] " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        return
    fi

    echo ":: Adding G14 repository keys..."
    # Import keys as per documentation
    sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

    # Add repo to pacman.conf if not exists
    if ! grep -q "^\[g14\]" /etc/pacman.conf; then
        echo ":: Adding g14 repo to pacman.conf..."
        echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
    else
        echo ":: [g14] repo already exists in pacman.conf."
    fi

    echo ":: Updating package database..."
    sudo pacman -Sy

    echo ":: Installing rog-control-center..."
    # rog-control-center depends on asusctl
    sudo pacman -S --needed --noconfirm rog-control-center

    echo ":: Enabling asusd service..."
    sudo systemctl enable --now asusd

    # Optional kernel
    read -p ":: Do you want to install the custom linux-g14 kernel? [y/N] " kernel_choice
    if [[ "$kernel_choice" =~ ^[Yy]$ ]]; then
        echo ":: Installing linux-g14 and headers..."
        sudo pacman -S --needed --noconfirm linux-g14 linux-g14-headers
        echo ":: Custom kernel installed."
        echo ":: IMPORTANT: You must update your bootloader configuration manually (e.g., grub-mkconfig) to boot into this kernel."
    fi
}

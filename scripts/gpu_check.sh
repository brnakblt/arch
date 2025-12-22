#!/bin/bash

# Function to detect GPU and handle NVIDIA drivers
setup_gpu() {
    echo ":: Checking for GPU..."
    
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "nvidia"; then
        echo ":: NVIDIA GPU detected."
        read -p ":: Do you want to install NVIDIA DKMS drivers and Wayland support? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ":: Adding NVIDIA packages to installation list..."
            # Return these packages to be added to the pacman command
            echo "nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver"
        else
            echo ":: Skipping NVIDIA driver installation."
        fi
    else
        echo ":: No NVIDIA GPU detected or using other vendor (Intel/AMD). Skipping NVIDIA specific drivers."
    fi
}

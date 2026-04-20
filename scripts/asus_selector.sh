#!/bin/bash

setup_asus() {
    print_header "ASUS ROG/TUF Laptop Setup"
    echo "   This setup is for ASUS ROG/Zephyrus/TUF laptops."
    echo "   It enables the g14 repository and installs control tools."
    
    read -p ":: Do you want to set up ASUS ROG/TUF tools (rog-control-center, asusctl)? [y/N] " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        return
    fi

    # 1. G14 Repo Setup
    echo ":: Adding G14 repository keys..."
    if ! sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35; then
        echo ":: Key server failed, attempting manual import..."
        wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8b15a6b0e9a3fa35" -O /tmp/g14.sec
        sudo pacman-key -a /tmp/g14.sec
        rm /tmp/g14.sec
    fi
    sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

    if ! grep -q "^\[g14\]" /etc/pacman.conf; then
        echo ":: Adding [g14] repo to pacman.conf..."
        echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
    fi

    echo ":: Updating package database..."
    sudo pacman -Sy

    # 2. Core Tools Installation
    echo ":: Installing asusctl and power-profiles-daemon..."
    sudo pacman -S --needed --noconfirm asusctl power-profiles-daemon rog-control-center
    
    echo ":: Enabling power-profiles-daemon..."
    sudo systemctl enable --now power-profiles-daemon.service

    # 3. NVIDIA Power Management (ASUS Specific)
    if lspci | grep -iq "nvidia"; then
        print_header "ASUS NVIDIA Power Management"
        echo ":: Configuring NVIDIA power management for ASUS laptops..."
        
        # Architecture detection (rough)
        GPU_NAME=$(lspci | grep -i "nvidia" | cut -d ":" -f3)
        echo ":: Detected: $GPU_NAME"
        
        # Turing: GTX 16xx, RTX 20xx (Some sources say 2000 is Ampere in the guide, but let's follow naming)
        # The guide says: Turing (GTX 1000/1600), Ampere (RTX 2000+)
        if echo "$GPU_NAME" | grep -iE "GTX (10|16)|RTX 20"; then
            echo ":: Turing/Pascal detected. Applying manual power configuration..."
            
            # Create modprobe config
            echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
            echo "options nvidia NVreg_EnableGpuFirmware=0 NVreg_EnableS0ixPowerManagement=1 NVreg_DynamicPowerManagement=0x02" | sudo tee -a /etc/modprobe.d/nvidia.conf
            
            # Create udev rule
            sudo mkdir -p /usr/lib/udev/rules.d/
            sudo wget "https://gitlab.com/asus-linux/nvidia-laptop-power-cfg/-/raw/main/nvidia.rules" -O /usr/lib/udev/rules.d/80-nvidia-pm.rules
            
        else
            echo ":: Ampere or later (RTX 3000+) detected. Installing nvidia-laptop-power-cfg..."
            # Using yay for the AUR package
            if command -v yay &> /dev/null; then
                yay -S --needed --noconfirm nvidia-laptop-power-cfg
            else
                echo ":: yay not found. Please install nvidia-laptop-power-cfg manually from AUR."
            fi
        fi
        
        # Enable NVIDIA services
        echo ":: Enabling NVIDIA power management services..."
        sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
        sudo systemctl enable --now nvidia-powerd
    fi

    # 4. Optional Kernel
    read -p ":: Do you want to install the custom linux-g14 kernel? [y/N] " kernel_choice
    if [[ "$kernel_choice" =~ ^[Yy]$ ]]; then
        echo ":: Installing linux-g14 and headers..."
        sudo pacman -S --needed --noconfirm linux-g14 linux-g14-headers
        
        if [ -f /etc/default/grub ]; then
            echo ":: Detected GRUB. Updating configuration..."
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        else
            echo ":: IMPORTANT: Update your bootloader manually to boot into linux-g14."
        fi
    fi

    echo ":: ASUS setup complete."
}

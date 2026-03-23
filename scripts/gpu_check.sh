#!/bin/bash

# Function to detect GPU and handle NVIDIA drivers
setup_gpu() {
    print_header "GPU Detection & Driver Configuration"
    echo ":: Checking for GPU hardware..."
    
    GPU_INFO=$(lspci -k | grep -A 3 -E "(VGA|3D)")
    echo "$GPU_INFO"
    
    GPU_PACKAGES=""
    
    if echo "$GPU_INFO" | grep -iq "nvidia"; then
        echo ":: NVIDIA GPU detected."
        echo "   According to the Arch Wiki, you have several choices for NVIDIA drivers:"
        echo "   1) Proprietary (Latest/Standard - recommended for most)"
        echo "   2) Open-Source (GSP-only for Turing+ / 16xx series and newer)"
        echo "   3) Legacy 470xx (For Kepler cards, e.g., GT 6xx/7xx)"
        echo "   4) Legacy 390xx (For Fermi cards, e.g., GT 4xx/5xx)"
        echo "   5) Skip (I will handle my own drivers or use Nouveau)"

        read -p ":: Choose NVIDIA driver type: " nv_choice
        
        case $nv_choice in
            1)
                echo ":: Selecting Proprietary drivers..."
                GPU_PACKAGES="nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver nvidia-settings"
                ;;
            2)
                echo ":: Selecting Open-Source (GSP) drivers..."
                GPU_PACKAGES="nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver"
                ;;
            3)
                echo ":: Selecting Legacy 470xx drivers (AUR)..."
                # Note: These usually require AUR
                GPU_PACKAGES="nvidia-470xx-utils lib32-nvidia-470xx-utils nvidia-470xx-dkms"
                ;;
            4)
                echo ":: Selecting Legacy 390xx drivers (AUR)..."
                GPU_PACKAGES="nvidia-390xx-utils lib32-nvidia-390xx-utils nvidia-390xx-dkms"
                ;;
            *)
                echo ":: Skipping NVIDIA specific driver installation."
                return
                ;;
        esac

        # Post-install instructions for NVIDIA (to be automated later)
        echo ""
        echo ":: NVIDIA configuration will be automated after package installation:"
        echo "   - Adding 'nvidia_drm.modeset=1' to kernel parameters (GRUB)."
        echo "   - Updating mkinitcpio MODULES for Early KMS."
        echo "   - Setting LIBVA_DRIVER_NAME environment variable."
        echo ""
        read -p ":: Press Enter to acknowledge..."
        
    elif echo "$GPU_INFO" | grep -iq "intel"; then
        echo ":: Intel GPU detected."
        GPU_PACKAGES="vulkan-intel intel-media-driver libva-intel-driver"
    elif echo "$GPU_INFO" | grep -iq "amdgpu" || echo "$GPU_INFO" | grep -iq "ati"; then
        echo ":: AMD GPU detected."
        GPU_PACKAGES="xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau"
    else
        echo ":: Standard VGA or Virtual GPU detected. Using default mesa."
        GPU_PACKAGES="mesa"
    fi
}

# Function to apply NVIDIA specific system configurations
apply_nvidia_config() {
    # Only run if an NVIDIA GPU is detected
    if ! lspci -k | grep -A 3 -E "(VGA|3D)" | grep -iq "nvidia"; then
        return
    fi

    print_header "Automating NVIDIA Post-Configuration"

    # 1. mkinitcpio modules for Early KMS
    echo ":: Updating /etc/mkinitcpio.conf MODULES..."
    if grep -q "MODULES=()" /etc/mkinitcpio.conf; then
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        echo ":: Regenerating mkinitcpio initramfs..."
        sudo mkinitcpio -P
    else
        echo ":: Warning: /etc/mkinitcpio.conf MODULES already has content."
        echo "   Please manually ensure (nvidia nvidia_modeset nvidia_uvm nvidia_drm) are present."
    fi

    # 2. Environment Variables for Wayland support
    echo ":: Setting LIBVA_DRIVER_NAME=nvidia in /etc/environment..."
    if ! grep -q "LIBVA_DRIVER_NAME=nvidia" /etc/environment; then
        echo "LIBVA_DRIVER_NAME=nvidia" | sudo tee -a /etc/environment > /dev/null
    fi

    # 3. GRUB Kernel Parameters (if GRUB is present)
    if [ -f /etc/default/grub ]; then
        echo ":: Checking for 'nvidia_drm.modeset=1' in GRUB_CMDLINE_LINUX_DEFAULT..."
        if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
            echo ":: Appending nvidia_drm.modeset=1 to /etc/default/grub..."
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1 /' /etc/default/grub
            echo ":: Updating GRUB configuration..."
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    else
        echo ":: No /etc/default/grub found. Skipping GRUB configuration."
        echo "   If you use systemd-boot or another bootloader, add 'nvidia_drm.modeset=1' manually."
    fi

    echo ":: NVIDIA post-configuration complete."
}
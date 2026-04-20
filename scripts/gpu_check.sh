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
        echo "   Recommendations for Wayland (Hyprland/Niri):"
        echo "   - Blackwell (GBxxx) / Ada (RTX 40xx) / Ampere (RTX 30xx):"
        echo "     'Open Drivers' (nvidia-open-dkms) are strongly recommended."
        echo "   - Turing (RTX 20xx / GTX 16xx):"
        echo "     'Open Drivers' work but might have power management issues on some laptops."
        echo "   - Pascal (GTX 10xx) / Maxwell (GTX 9xx/7xx):"
        echo "     Use proprietary drivers (nvidia-580xx-dkms from AUR)."
        echo ""
        echo "   1) Open-Source (nvidia-open-dkms - Recommended for RTX 30xx/40xx/50xx)"
        echo "   2) Proprietary (nvidia-dkms - Standard for older cards)"
        echo "   3) Legacy Pascal/Maxwell (nvidia-580xx-dkms - AUR)"
        echo "   4) Legacy Kepler (nvidia-470xx-dkms - AUR)"
        echo "   5) Skip"

        read -p ":: Choose NVIDIA driver type: " nv_choice
        
        case $nv_choice in
            1)
                echo ":: Selecting Open-Source kernel modules..."
                GPU_PACKAGES="nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver"
                ;;
            2)
                echo ":: Selecting Proprietary drivers..."
                GPU_PACKAGES="nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland libva-nvidia-driver nvidia-settings"
                ;;
            3)
                echo ":: Selecting Legacy 580xx drivers (AUR)..."
                GPU_PACKAGES="nvidia-580xx-dkms lib32-nvidia-580xx-utils nvidia-580xx-utils"
                ;;
            4)
                echo ":: Selecting Legacy 470xx drivers (AUR)..."
                GPU_PACKAGES="nvidia-470xx-utils lib32-nvidia-470xx-utils nvidia-470xx-dkms"
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

    # 1. mkinitcpio modules for Early KMS & Hybrid Fix
    echo ":: Updating /etc/mkinitcpio.conf MODULES..."
    MODULE_LIST="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    if lspci | grep -iq "intel" && lspci | grep -iq "vga"; then
        echo ":: Hybrid graphics detected (Intel + NVIDIA). Loading i915 first..."
        MODULE_LIST="i915 $MODULE_LIST"
    fi

    if grep -q "MODULES=()" /etc/mkinitcpio.conf; then
        sudo sed -i "s/MODULES=()/MODULES=($MODULE_LIST)/" /etc/mkinitcpio.conf
        echo ":: Regenerating mkinitcpio initramfs..."
        sudo mkinitcpio -P
    else
        echo ":: Warning: /etc/mkinitcpio.conf MODULES already has content."
        echo "   Please manually ensure ($MODULE_LIST) are present."
    fi

    # 2. Modprobe Configuration (Modeset, fbdev, and Power Management)
    echo ":: Configuring /etc/modprobe.d/nvidia.conf..."
    {
        echo "options nvidia_drm modeset=1 fbdev=1"
        echo "options nvidia NVreg_UsePageAttributeTable=1"
        echo "options nvidia NVreg_RegistryDwords=\"OverrideMaxPerf=0x1\""
        # Saving all video memory on suspend (Both old and new params for safety)
        echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1"
        echo "options nvidia NVreg_UseKernelSuspendNotifiers=1"
        echo "options nvidia NVreg_TemporaryFilePath=/var/tmp"
    } | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

    # 3. Environment Variables for Wayland support
    echo ":: Setting NVIDIA environment variables in /etc/environment..."
    {
        echo "LIBVA_DRIVER_NAME=nvidia"
        echo "__GLX_VENDOR_LIBRARY_NAME=nvidia"
        echo "ELECTRON_OZONE_PLATFORM_HINT=auto"
        echo "NVD_BACKEND=direct"
    } | while read -r line; do
        if ! grep -q "^${line%%=*}=" /etc/environment; then
            echo "$line" | sudo tee -a /etc/environment > /dev/null
        fi
    done

    # 4. GRUB Kernel Parameters (if GRUB is present)
    if [ -f /etc/default/grub ]; then
        # modeset, preserve video memory, and PAT
        EXTRA_PARAMS="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_UseKernelSuspendNotifiers=1"
        echo ":: Checking for NVIDIA parameters in GRUB_CMDLINE_LINUX_DEFAULT..."

        UPDATE_GRUB=false
        for param in $EXTRA_PARAMS; do
            if ! grep -q "$param" /etc/default/grub; then
                echo ":: Appending $param to /etc/default/grub..."
                sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$param /" /etc/default/grub
                UPDATE_GRUB=true
            fi
        done

        if [ "$UPDATE_GRUB" = true ]; then
            echo ":: Updating GRUB configuration..."
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi

    # 5. Enable Power Management Services
    echo ":: Enabling NVIDIA power management services..."
    # These are needed for drivers < 595, or GDM. Harmless on newer.
    sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
    if pacman -Qs nvidia-powerd > /dev/null; then
        sudo systemctl enable --now nvidia-powerd
    fi

    echo ":: NVIDIA post-configuration complete."
    }

    # Function to apply Niri-specific NVIDIA fix for idle VRAM consumption
    apply_niri_nvidia_fix() {
    if ! lspci | grep -iq "nvidia"; then return; fi

    print_header "Niri NVIDIA Optimization"
    echo ":: Applying GLVidHeapReuseRatio fix to reduce idle VRAM consumption..."

    sudo mkdir -p /etc/nvidia/nvidia-application-profiles-rc.d/
    cat <<EOF | sudo tee /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json > /dev/null
    {
    "rules": [
        {
            "pattern": {
                "feature": "procname",
                "matches": "niri"
            },
            "profile": "Limit free buffer pool on Wayland compositors"
        }
    ],
    "profiles": [
        {
            "name": "Limit free buffer pool on Wayland comopsitors",
            "settings": [
                {
                    "key": "GLVidHeapReuseRatio",
                    "value": 0
                }
            ]
        }
    ]
    }
    EOF
    echo ":: Niri NVIDIA fix applied."
    }
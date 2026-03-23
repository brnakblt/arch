#!/bin/bash

setup_audio_bluetooth() {
    while true; do
        print_header "Audio & Bluetooth Setup"
        echo "   Enter numbers separated by spaces (e.g., '1 2 3')"
        echo "   Note: Pipewire and Bluez are recommended for modern setups."
        echo "1) Pipewire Audio Stack (pipewire, pipewire-pulse, wireplumber) [Recommended]"
        echo "2) Audio Control GUI (pavucontrol)"
        echo "3) Advanced Audio Tools (easyeffects, pipewire-alsa, pipewire-jack)"
        echo "4) Bluetooth Stack (bluez, bluez-utils) [Recommended]"
        echo "5) Bluetooth GUI (blueman)"

        read -p ":: Choose packages to install (default: 1 2 4 5): " -a choices
        
        # Default to 1 2 4 5 if empty
        if [ ${#choices[@]} -eq 0 ]; then
            choices=(1 2 4 5)
        fi

        PACKAGES=""
        SELECTED_NAMES=""

        for choice in "${choices[@]}"; do
            case $choice in
                1) PACKAGES="$PACKAGES pipewire pipewire-pulse wireplumber"; SELECTED_NAMES="$SELECTED_NAMES Pipewire" ;;
                2) PACKAGES="$PACKAGES pavucontrol"; SELECTED_NAMES="$SELECTED_NAMES Pavucontrol" ;;
                3) PACKAGES="$PACKAGES easyeffects pipewire-alsa pipewire-jack"; SELECTED_NAMES="$SELECTED_NAMES AdvancedAudio" ;;
                4) PACKAGES="$PACKAGES bluez bluez-utils"; SELECTED_NAMES="$SELECTED_NAMES Bluez" ;;
                5) PACKAGES="$PACKAGES blueman"; SELECTED_NAMES="$SELECTED_NAMES Blueman" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No Audio/Bluetooth packages selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$PACKAGES" ]; then
            echo ":: Installing Audio & Bluetooth packages: $PACKAGES"
            yay -S --needed --noconfirm $PACKAGES
            
            # Enable Bluetooth service if installed and not already enabled
            if [[ "$PACKAGES" == *"bluez"* ]]; then
                 if ! systemctl is-active --quiet bluetooth; then
                    echo ":: Enabling Bluetooth service..."
                    sudo systemctl enable --now bluetooth
                 fi
            fi
        fi
        break
    done
}

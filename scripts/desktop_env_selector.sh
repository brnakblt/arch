#!/bin/bash

setup_desktop_env() {
    while true; do
        print_header "Desktop Environment & Window Manager Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 2')"
        echo "1) Hyprland (Wayland Compositor - Dynamic tiling)"
        echo "2) Niri (Wayland Compositor - Scrollable tiling)"
        echo "3) Sway (Wayland Compositor - i3-compatible)"
        echo "4) i3 (X11 Window Manager - Manual tiling)"
        echo "5) KDE Plasma (Desktop Environment - Customizable, feature-rich)"
        echo "6) GNOME (Desktop Environment - Modern, streamlined)"
        echo "7) XFCE (Desktop Environment - Lightweight, traditional)"
        echo "8) Cosmic (Desktop Environment - New Rust-based DE)"

        read -p ":: Choose environments to install: " -a de_choices

        DE_PKGS=""
        AUR_DE_PKGS=""
        SELECTED_NAMES=""

        for choice in "${de_choices[@]}"; do
            case $choice in
                1) # Hyprland
                   SELECTED_NAMES="$SELECTED_NAMES Hyprland"
                   DE_PKGS="$DE_PKGS hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland" 
                   # Common tools often used with Hyprland
                   DE_PKGS="$DE_PKGS waybar rofi-wayland mako grim slurp wl-clipboard swww"
                   ;;
                2) # Niri
                   SELECTED_NAMES="$SELECTED_NAMES Niri"
                   DE_PKGS="$DE_PKGS niri xdg-desktop-portal-gnome xdg-desktop-portal-gtk qt5-wayland qt6-wayland"
                   # Common tools often used with Niri
                   DE_PKGS="$DE_PKGS waybar rofi-wayland mako grim slurp wl-clipboard swww"
                   ;;
                3) # Sway
                   SELECTED_NAMES="$SELECTED_NAMES Sway"
                   DE_PKGS="$DE_PKGS sway swaybg swaylock swayidle xdg-desktop-portal-wlr qt5-wayland qt6-wayland"
                   # Common tools
                   DE_PKGS="$DE_PKGS waybar grim slurp wl-clipboard mako"
                   ;;
                4) # i3
                   SELECTED_NAMES="$SELECTED_NAMES i3"
                   DE_PKGS="$DE_PKGS i3-wm i3status i3lock dmenu xorg-server xorg-xinit picom feh"
                   ;;
                5) # KDE
                   SELECTED_NAMES="$SELECTED_NAMES KDE-Plasma"
                   DE_PKGS="$DE_PKGS plasma-meta konsole dolphin ark okular gwenview spectacle"
                   ;;
                6) # GNOME
                   SELECTED_NAMES="$SELECTED_NAMES GNOME"
                   DE_PKGS="$DE_PKGS gnome gnome-terminal nautilus gnome-tweaks"
                   ;;
                7) # XFCE
                   SELECTED_NAMES="$SELECTED_NAMES XFCE"
                   DE_PKGS="$DE_PKGS xfce4 xfce4-goodies"
                   ;;
                8) # Cosmic
                   SELECTED_NAMES="$SELECTED_NAMES Cosmic"
                   AUR_DE_PKGS="$AUR_DE_PKGS cosmic-epoch-git"
                   ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No Desktop Environment selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$DE_PKGS" ]; then
            echo ":: Installing Desktop Environment packages: $DE_PKGS"
            sudo pacman -S --needed --noconfirm $DE_PKGS
            
            # Post-install fixes
            if [[ "$SELECTED_NAMES" == *"Niri"* ]]; then
                apply_niri_nvidia_fix
            fi
        fi

        if [ -n "$AUR_DE_PKGS" ]; then
            echo ":: Installing AUR Desktop Environment packages: $AUR_DE_PKGS"
            yay -S --needed --noconfirm $AUR_DE_PKGS
        fi
        break
    done
}

#!/bin/bash

setup_utils() {
    echo ":: System Maintenance & Utilities Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 2 4')"
    echo "1) Timeshift (AUR - System restore tool)"
    echo "2) GParted (Official - Partition editor)"
    echo "3) Htop (Official - Interactive process viewer)"
    echo "4) Bottom (Official - Graphical process/system monitor in terminal)"
    echo "5) Ark (Official - Archiving tool by KDE)"
    echo "6) File Roller (Official - Archive manager for GNOME)"
    echo "7) PeaZip (AUR - Free file archiver utility)"
    echo "8) Ncdu (Official - Disk usage analyzer)"
    echo "9) BleachBit (Official - Disk space cleaner)"

    read -p ":: Choose utility tools to install: " -a util_choices

    UTIL_PKGS=""

    for choice in "${util_choices[@]}"; do
        case $choice in
            1) UTIL_PKGS="$UTIL_PKGS timeshift" ;;
            2) UTIL_PKGS="$UTIL_PKGS gparted" ;;
            3) UTIL_PKGS="$UTIL_PKGS htop" ;;
            4) UTIL_PKGS="$UTIL_PKGS bottom" ;;
            5) UTIL_PKGS="$UTIL_PKGS ark p7zip unrar" ;;
            6) UTIL_PKGS="$UTIL_PKGS file-roller" ;;
            7) UTIL_PKGS="$UTIL_PKGS peazip-qt5-bin" ;;
            8) UTIL_PKGS="$UTIL_PKGS ncdu" ;;
            9) UTIL_PKGS="$UTIL_PKGS bleachbit" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$UTIL_PKGS" ]; then
        echo ":: Installing selected utilities: $UTIL_PKGS"
        yay -S --needed --noconfirm $UTIL_PKGS
    else
        echo ":: No utility tools selected."
    fi
}

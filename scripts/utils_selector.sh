#!/bin/bash

setup_utils() {
    while true; do
        print_header "System Maintenance & Utilities Selection"
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
        echo "10) Stacer (AUR - Linux system optimizer and monitoring)"
        echo "11) Zoxide (Official - A smarter cd command)"
        echo "12) Eza (Official - Modern replacement for ls)"
        echo "13) Bat (Official - A cat clone with wings)"

        read -p ":: Choose utility tools to install: " -a util_choices

        UTIL_PKGS=""
        SELECTED_NAMES=""

        for choice in "${util_choices[@]}"; do
            case $choice in
                1) UTIL_PKGS="$UTIL_PKGS timeshift"; SELECTED_NAMES="$SELECTED_NAMES Timeshift" ;;
                2) UTIL_PKGS="$UTIL_PKGS gparted"; SELECTED_NAMES="$SELECTED_NAMES GParted" ;;
                3) UTIL_PKGS="$UTIL_PKGS htop"; SELECTED_NAMES="$SELECTED_NAMES Htop" ;;
                4) UTIL_PKGS="$UTIL_PKGS bottom"; SELECTED_NAMES="$SELECTED_NAMES Bottom" ;;
                5) UTIL_PKGS="$UTIL_PKGS ark p7zip unrar"; SELECTED_NAMES="$SELECTED_NAMES Ark" ;;
                6) UTIL_PKGS="$UTIL_PKGS file-roller"; SELECTED_NAMES="$SELECTED_NAMES FileRoller" ;;
                7) UTIL_PKGS="$UTIL_PKGS peazip-qt5-bin"; SELECTED_NAMES="$SELECTED_NAMES PeaZip" ;;
                8) UTIL_PKGS="$UTIL_PKGS ncdu"; SELECTED_NAMES="$SELECTED_NAMES Ncdu" ;;
                9) UTIL_PKGS="$UTIL_PKGS bleachbit"; SELECTED_NAMES="$SELECTED_NAMES BleachBit" ;;
                10) UTIL_PKGS="$UTIL_PKGS stacer"; SELECTED_NAMES="$SELECTED_NAMES Stacer" ;;
                11) UTIL_PKGS="$UTIL_PKGS zoxide"; SELECTED_NAMES="$SELECTED_NAMES Zoxide" ;;
                12) UTIL_PKGS="$UTIL_PKGS eza"; SELECTED_NAMES="$SELECTED_NAMES Eza" ;;
                13) UTIL_PKGS="$UTIL_PKGS bat"; SELECTED_NAMES="$SELECTED_NAMES Bat" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No utility tools selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$UTIL_PKGS" ]; then
            echo ":: Installing selected utilities: $UTIL_PKGS"
            yay -S --needed --noconfirm $UTIL_PKGS
        fi
        break
    done
}

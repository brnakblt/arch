#!/bin/bash

setup_office() {
    while true; do
        print_header "Office & Productivity Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 3 5')"
        echo "1) LibreOffice Fresh (Official - Latest features)"
        echo "2) OnlyOffice Desktop (AUR - Better MS Office compatibility)"
        echo "3) WPS Office (AUR - Familiar UI, proprietary)"
        echo "4) Obsidian (Official - Knowledge base, markdown notes)"
        echo "5) Notion App (AUR - Web wrapper for Notion)"
        echo "6) Joplin (Official - Secure, open source note taking)"
        echo "7) Zathura (Official - Minimal, keyboard-driven PDF viewer)"
        echo "8) Okular (Official - Feature-rich document viewer by KDE)"
        echo "9) Evince (Official - Simple document viewer by GNOME)"

        read -p ":: Choose productivity tools to install: " -a office_choices

        OFFICE_PKGS=""
        SELECTED_NAMES=""

        for choice in "${office_choices[@]}"; do
            case $choice in
                1) OFFICE_PKGS="$OFFICE_PKGS libreoffice-fresh"; SELECTED_NAMES="$SELECTED_NAMES LibreOffice" ;;
                2) OFFICE_PKGS="$OFFICE_PKGS onlyoffice-bin"; SELECTED_NAMES="$SELECTED_NAMES OnlyOffice" ;;
                3) OFFICE_PKGS="$OFFICE_PKGS wps-office ttf-wps-fonts"; SELECTED_NAMES="$SELECTED_NAMES WPS" ;;
                4) OFFICE_PKGS="$OFFICE_PKGS obsidian"; SELECTED_NAMES="$SELECTED_NAMES Obsidian" ;;
                5) OFFICE_PKGS="$OFFICE_PKGS notion-app-electron"; SELECTED_NAMES="$SELECTED_NAMES Notion" ;;
                6) OFFICE_PKGS="$OFFICE_PKGS joplin-desktop"; SELECTED_NAMES="$SELECTED_NAMES Joplin" ;;
                7) OFFICE_PKGS="$OFFICE_PKGS zathura zathura-pdf-mupdf"; SELECTED_NAMES="$SELECTED_NAMES Zathura" ;;
                8) OFFICE_PKGS="$OFFICE_PKGS okular"; SELECTED_NAMES="$SELECTED_NAMES Okular" ;;
                9) OFFICE_PKGS="$OFFICE_PKGS evince"; SELECTED_NAMES="$SELECTED_NAMES Evince" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No productivity tools selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$OFFICE_PKGS" ]; then
            echo ":: Installing selected productivity tools: $OFFICE_PKGS"
            yay -S --needed --noconfirm $OFFICE_PKGS
        fi
        break
    done
}

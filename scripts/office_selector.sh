#!/bin/bash

setup_office() {
    echo ":: Office & Productivity Selection"
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

    for choice in "${office_choices[@]}"; do
        case $choice in
            1) OFFICE_PKGS="$OFFICE_PKGS libreoffice-fresh" ;;
            2) OFFICE_PKGS="$OFFICE_PKGS onlyoffice-bin" ;;
            3) OFFICE_PKGS="$OFFICE_PKGS wps-office ttf-wps-fonts" ;;
            4) OFFICE_PKGS="$OFFICE_PKGS obsidian" ;;
            5) OFFICE_PKGS="$OFFICE_PKGS notion-app-electron" ;;
            6) OFFICE_PKGS="$OFFICE_PKGS joplin-desktop" ;;
            7) OFFICE_PKGS="$OFFICE_PKGS zathura zathura-pdf-mupdf" ;;
            8) OFFICE_PKGS="$OFFICE_PKGS okular" ;;
            9) OFFICE_PKGS="$OFFICE_PKGS evince" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$OFFICE_PKGS" ]; then
        echo ":: Installing selected productivity tools: $OFFICE_PKGS"
        yay -S --needed --noconfirm $OFFICE_PKGS
    else
        echo ":: No productivity tools selected."
    fi
}

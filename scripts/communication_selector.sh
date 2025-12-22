#!/bin/bash

setup_communication() {
    echo ":: Communication & Email Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 3')"
    echo "1) Thunderbird (Official - Powerful, open source email client)"
    echo "2) Geary (Official - Modern, lightweight email client for GNOME)"
    echo "3) Mailspring (AUR - Beautiful, fast email client)"
    echo "4) Mutt / NeoMutt (Official - Terminal-based email client)"
    echo "5) Element (Official - Secure Matrix collaboration client)"
    echo "6) WeeChat (Official - Extensible terminal chat client)"

    read -p ":: Choose communication tools to install: " -a comm_choices

    COMM_PKGS=""

    for choice in "${comm_choices[@]}"; do
        case $choice in
            1) COMM_PKGS="$COMM_PKGS thunderbird" ;;
            2) COMM_PKGS="$COMM_PKGS geary" ;;
            3) COMM_PKGS="$COMM_PKGS mailspring" ;;
            4) COMM_PKGS="$COMM_PKGS neomutt" ;;
            5) COMM_PKGS="$COMM_PKGS element-desktop" ;;
            6) COMM_PKGS="$COMM_PKGS weechat" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$COMM_PKGS" ]; then
        echo ":: Installing selected communication tools: $COMM_PKGS"
        yay -S --needed --noconfirm $COMM_PKGS
    else
        echo ":: No communication tools selected."
    fi
}

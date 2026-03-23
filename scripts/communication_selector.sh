#!/bin/bash

setup_communication() {
    while true; do
        print_header "Communication & Email Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 3')"
        echo "1) Thunderbird (Official - Powerful, open source email client)"
        echo "2) Geary (Official - Modern, lightweight email client for GNOME)"
        echo "3) Mailspring (AUR - Beautiful, fast email client)"
        echo "4) Mutt / NeoMutt (Official - Terminal-based email client)"
        echo "5) Element (Official - Secure Matrix collaboration client)"
        echo "6) WeeChat (Official - Extensible terminal chat client)"

        read -p ":: Choose communication tools to install: " -a comm_choices

        COMM_PKGS=""
        SELECTED_NAMES=""

        for choice in "${comm_choices[@]}"; do
            case $choice in
                1) COMM_PKGS="$COMM_PKGS thunderbird"; SELECTED_NAMES="$SELECTED_NAMES Thunderbird" ;;
                2) COMM_PKGS="$COMM_PKGS geary"; SELECTED_NAMES="$SELECTED_NAMES Geary" ;;
                3) COMM_PKGS="$COMM_PKGS mailspring"; SELECTED_NAMES="$SELECTED_NAMES Mailspring" ;;
                4) COMM_PKGS="$COMM_PKGS neomutt"; SELECTED_NAMES="$SELECTED_NAMES NeoMutt" ;;
                5) COMM_PKGS="$COMM_PKGS element-desktop"; SELECTED_NAMES="$SELECTED_NAMES Element" ;;
                6) COMM_PKGS="$COMM_PKGS weechat"; SELECTED_NAMES="$SELECTED_NAMES WeeChat" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No communication tools selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$COMM_PKGS" ]; then
            echo ":: Installing selected communication tools: $COMM_PKGS"
            yay -S --needed --noconfirm $COMM_PKGS
        fi
        break
    done
}

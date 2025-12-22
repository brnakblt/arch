#!/bin/bash

setup_social_gaming() {
    echo ":: Social & Gaming Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 2 3')"
    echo "1) Discord (Official - Chat, voice, video for communities)"
    echo "2) Steam (Official - Valve's game distribution platform)"
    echo "3) Telegram Desktop (Official - Fast, secure messaging)"
    echo "4) Slack (AUR - Business communication platform)"
    echo "5) Signal Desktop (Official - Encrypted instant messaging)"
    echo "6) Zoom (AUR - Video conferencing tool)"
    echo "7) Lutris (Manager - Unified library for Wine, Steam, Epic, etc.)"
    echo "8) Heroic Games Launcher (Epic/GOG - Open source alternative launcher)"

    read -p ":: Choose social/gaming apps to install: " -a choice_list

    TO_INSTALL=""

    for choice in "${choice_list[@]}"; do
        case $choice in
            1) TO_INSTALL="$TO_INSTALL discord" ;;
            2) TO_INSTALL="$TO_INSTALL steam" ;;
            3) TO_INSTALL="$TO_INSTALL telegram-desktop" ;;
            4) TO_INSTALL="$TO_INSTALL slack-desktop" ;;
            5) TO_INSTALL="$TO_INSTALL signal-desktop" ;;
            6) TO_INSTALL="$TO_INSTALL zoom" ;;
            7) TO_INSTALL="$TO_INSTALL lutris" ;;
            8) TO_INSTALL="$TO_INSTALL heroic-games-launcher-bin" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$TO_INSTALL" ]; then
        echo ":: Installing selected apps: $TO_INSTALL"
        yay -S --needed --noconfirm $TO_INSTALL
    else
        echo ":: No social/gaming apps selected."
    fi
}

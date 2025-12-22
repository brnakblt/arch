#!/bin/bash

setup_music_platforms() {
    echo ":: Music Platform Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 3')"
    echo "1) Spotify (Official Client - AUR - The standard desktop app)"
    echo "2) Spotify Launcher (Official - Pacman - Sandboxed wrapper)"
    echo "3) ncspot (Terminal-based - Lightweight, ncurses interface)"
    echo "4) spotify-player (Terminal-based - Feature-rich, supports visuals)"
    echo "5) Spicetify (CLI - Tool to customize/theme the official Spotify client)"
    echo "6) Amberol (Local Player - Simple, beautiful GTK4 music player)"
    echo "7) Lollypop (Local Player - Modern, organized collection manager)"

    read -p ":: Choose music platforms/tools to install: " -a music_choices

    MUSIC_TO_INSTALL=""
    RUN_SPICETIFY_INIT=false

    for choice in "${music_choices[@]}"; do
        case $choice in
            1) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify" ;;
            2) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify-launcher" ;;
            3) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL ncspot" ;;
            4) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify-player" ;;
            5) 
                MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spicetify-cli"
                RUN_SPICETIFY_INIT=true
                ;;
            6) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL amberol" ;;
            7) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL lollypop" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$MUSIC_TO_INSTALL" ]; then
        echo ":: Installing selected music tools: $MUSIC_TO_INSTALL"
        yay -S --needed --noconfirm $MUSIC_TO_INSTALL
    fi

    if [ "$RUN_SPICETIFY_INIT" = true ]; then
        echo ":: Note: To use Spicetify, you need to run it after launching Spotify once."
        echo ":: Setting up permissions for Spicetify..."
        # Spicetify often needs write access to the spotify directory
        sudo chmod a+wr /opt/spotify
        sudo chmod a+wr /opt/spotify/Apps -R
    fi

    if [ -z "$MUSIC_TO_INSTALL" ]; then
        echo ":: No music platforms selected."
    fi
}

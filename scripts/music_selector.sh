#!/bin/bash

setup_music_platforms() {
    while true; do
        print_header "Music Platform Selection"
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
        SELECTED_NAMES=""

        for choice in "${music_choices[@]}"; do
            case $choice in
                1) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify"; SELECTED_NAMES="$SELECTED_NAMES Spotify" ;;
                2) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify-launcher"; SELECTED_NAMES="$SELECTED_NAMES Spotify-Launcher" ;;
                3) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL ncspot"; SELECTED_NAMES="$SELECTED_NAMES ncspot" ;;
                4) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spotify-player"; SELECTED_NAMES="$SELECTED_NAMES spotify-player" ;;
                5) 
                    MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL spicetify-cli"
                    RUN_SPICETIFY_INIT=true
                    SELECTED_NAMES="$SELECTED_NAMES Spicetify"
                    ;;
                6) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL amberol"; SELECTED_NAMES="$SELECTED_NAMES Amberol" ;;
                7) MUSIC_TO_INSTALL="$MUSIC_TO_INSTALL lollypop"; SELECTED_NAMES="$SELECTED_NAMES Lollypop" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No music platforms selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$MUSIC_TO_INSTALL" ]; then
            echo ":: Installing selected music tools: $MUSIC_TO_INSTALL"
            yay -S --needed --noconfirm $MUSIC_TO_INSTALL
        fi

        if [ "$RUN_SPICETIFY_INIT" = true ]; then
            echo ":: Note: To use Spicetify, you need to run it after launching Spotify once."
            echo ":: Setting up permissions for Spicetify..."
            
            if [ -d "/opt/spotify" ]; then
                sudo chmod a+wr /opt/spotify || echo ":: Warning: Failed to chmod /opt/spotify"
                
                if [ -d "/opt/spotify/Apps" ]; then
                    sudo chmod a+wr /opt/spotify/Apps -R || echo ":: Warning: Failed to chmod /opt/spotify/Apps"
                fi
            else
                echo ":: Warning: /opt/spotify not found. Skipping Spicetify permission setup."
            fi
        fi
        break
    done
}

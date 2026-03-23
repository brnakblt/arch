#!/bin/bash

setup_multimedia_tools() {
    while true; do
        print_header "Multimedia & Tools Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 2 3')"
        echo "1) FFmpeg (Complete, cross-platform solution to record, convert and stream audio and video)"
        echo "2) VLC (Multimedia player)"
        echo "3) yt-dlp (Command-line YouTube video downloader)"
        echo "4) mpv (Command line video player)"
        echo "5) OBS Studio (Software for video recording and live streaming)"
        echo "6) ImageMagick (Image manipulation tools)"
        echo "7) GIMP (GNU Image Manipulation Program)"
        echo "8) Blender (3D creation suite)"

        read -p ":: Choose tools to install: " -a tool_choices

        TOOLS_TO_INSTALL=""
        SELECTED_NAMES=""

        for choice in "${tool_choices[@]}"; do
            case $choice in
                1) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL ffmpeg"; SELECTED_NAMES="$SELECTED_NAMES FFmpeg" ;;
                2) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL vlc"; SELECTED_NAMES="$SELECTED_NAMES VLC" ;;
                3) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL yt-dlp"; SELECTED_NAMES="$SELECTED_NAMES yt-dlp" ;;
                4) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL mpv"; SELECTED_NAMES="$SELECTED_NAMES mpv" ;;
                5) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL obs-studio"; SELECTED_NAMES="$SELECTED_NAMES OBS" ;;
                6) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL imagemagick"; SELECTED_NAMES="$SELECTED_NAMES ImageMagick" ;;
                7) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL gimp"; SELECTED_NAMES="$SELECTED_NAMES GIMP" ;;
                8) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL blender"; SELECTED_NAMES="$SELECTED_NAMES Blender" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No tools selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$TOOLS_TO_INSTALL" ]; then
            echo ":: Installing selected tools: $TOOLS_TO_INSTALL"
            yay -S --needed --noconfirm $TOOLS_TO_INSTALL
        fi
        break
    done
}

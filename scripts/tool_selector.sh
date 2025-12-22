#!/bin/bash

setup_multimedia_tools() {
    echo ":: Multimedia & Tools Selection"
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

    for choice in "${tool_choices[@]}"; do
        case $choice in
            1) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL ffmpeg" ;;
            2) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL vlc" ;;
            3) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL yt-dlp" ;;
            4) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL mpv" ;;
            5) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL obs-studio" ;;
            6) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL imagemagick" ;;
            7) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL gimp" ;;
            8) TOOLS_TO_INSTALL="$TOOLS_TO_INSTALL blender" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$TOOLS_TO_INSTALL" ]; then
        echo ":: Installing selected tools: $TOOLS_TO_INSTALL"
        yay -S --needed --noconfirm $TOOLS_TO_INSTALL
    else
        echo ":: No tools selected."
    fi
}

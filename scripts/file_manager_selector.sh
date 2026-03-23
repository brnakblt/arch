#!/bin/bash

setup_file_managers() {
    while true; do
        print_header "File Manager Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 2')"
        echo "1) Dolphin (KDE/Qt - Powerful, highly customizable, tabs)"
        echo "2) Thunar (XFCE/GTK - Lightweight, fast, supports plugins)"
        echo "3) Nautilus (GNOME/GTK - Clean, simple, consistent UI)"
        echo "4) Yazi (Terminal based - Rust-powered, instant previews, async)"
        echo "5) Ranger (Terminal based - Python, miller columns, vi-bindings)"
        echo "6) Nemo (Cinnamon/GTK - Classic design, dual-pane support)"

        read -p ":: Choose file managers to install: " -a fm_choices

        FMS_TO_INSTALL=""
        SELECTED_NAMES=""

        for choice in "${fm_choices[@]}"; do
            case $choice in
                1) FMS_TO_INSTALL="$FMS_TO_INSTALL dolphin"; SELECTED_NAMES="$SELECTED_NAMES Dolphin" ;;
                2) FMS_TO_INSTALL="$FMS_TO_INSTALL thunar thunar-archive-plugin thunar-volman"; SELECTED_NAMES="$SELECTED_NAMES Thunar" ;;
                3) FMS_TO_INSTALL="$FMS_TO_INSTALL nautilus"; SELECTED_NAMES="$SELECTED_NAMES Nautilus" ;;
                4) FMS_TO_INSTALL="$FMS_TO_INSTALL yazi ffmpegthumbnailer unarchiver jq poppler fd ripgrep fzf zoxide imagemagick"; SELECTED_NAMES="$SELECTED_NAMES Yazi" ;; 
                5) FMS_TO_INSTALL="$FMS_TO_INSTALL ranger"; SELECTED_NAMES="$SELECTED_NAMES Ranger" ;;
                6) FMS_TO_INSTALL="$FMS_TO_INSTALL nemo"; SELECTED_NAMES="$SELECTED_NAMES Nemo" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No file managers selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$FMS_TO_INSTALL" ]; then
            echo ":: Installing selected file managers: $FMS_TO_INSTALL"
            yay -S --needed --noconfirm $FMS_TO_INSTALL
        fi
        break
    done
}

#!/bin/bash

setup_themes() {
    echo ":: Theming & Appearance Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 3 5')"
    echo "1) Catppuccin GTK Theme (Mocha) (AUR - Soothing pastel theme)"
    echo "2) Dracula GTK Theme (Official - Dark theme for vampires)"
    echo "3) Nordic Theme (AUR - Arctic, north-bluish color palette)"
    echo "4) Arc GTK Theme (Official - Flat theme with transparent elements)"
    echo "5) Papirus Icon Theme (Official - Material design icons)"
    echo "6) Tela Circle Icon Theme (AUR - Circular, colorful icons)"
    echo "7) Bibata Cursor Theme (AUR - Material based cursor)"
    echo "8) Capitaine Cursors (AUR - Inspired by macOS and KDE Breeze)"
    echo "9) nwg-look (AUR - GTK3/4 settings editor for Wayland)"

    read -p ":: Choose themes/icons to install: " -a theme_choices

    THEME_PKGS=""

    for choice in "${theme_choices[@]}"; do
        case $choice in
            1) THEME_PKGS="$THEME_PKGS catppuccin-gtk-theme-mocha" ;;
            2) THEME_PKGS="$THEME_PKGS dracula-gtk-theme" ;;
            3) THEME_PKGS="$THEME_PKGS nordic-theme" ;;
            4) THEME_PKGS="$THEME_PKGS arc-gtk-theme" ;;
            5) THEME_PKGS="$THEME_PKGS papirus-icon-theme" ;;
            6) THEME_PKGS="$THEME_PKGS tela-circle-icon-theme-git" ;;
            7) THEME_PKGS="$THEME_PKGS bibata-cursor-theme" ;;
            8) THEME_PKGS="$THEME_PKGS capitaine-cursors" ;;
            9) THEME_PKGS="$THEME_PKGS nwg-look" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$THEME_PKGS" ]; then
        echo ":: Installing selected themes/icons: $THEME_PKGS"
        yay -S --needed --noconfirm $THEME_PKGS
    else
        echo ":: No themes selected."
    fi
}

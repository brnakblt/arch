#!/bin/bash

setup_browsers() {
    echo ":: Browser Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 3 5')"
    echo "1) Firefox (Official - Privacy-focused, highly customizable)"
    echo "2) Chromium (Official - Open-source base for Chrome)"
    echo "3) Brave (AUR - Privacy-oriented, ad-blocking built-in)"
    echo "4) Librewolf (AUR - Hardened Firefox fork for privacy)"
    echo "5) Zen Browser (AUR - Modern, performance-focused Firefox fork)"
    echo "6) Vivaldi (AUR - Highly customizable, power-user browser)"
    echo "7) Opera (Official - Fast, secure, with built-in VPN)"
    echo "8) Thorium (AUR - Optimized Chromium fork for speed)"
    
    read -p ":: Choose browsers to install: " -a browser_choices

    BROWSERS_TO_INSTALL=""

    for choice in "${browser_choices[@]}"; do
        case $choice in
            1) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL firefox" ;;
            2) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL chromium" ;;
            3) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL brave-bin" ;;
            4) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL librewolf-bin" ;;
            5) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL zen-browser-bin" ;;
            6) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL vivaldi" ;;
            7) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL opera" ;;
            8) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL thorium-browser-bin" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$BROWSERS_TO_INSTALL" ]; then
        echo ":: Installing selected browsers: $BROWSERS_TO_INSTALL"
        # Using yay to handle both official and AUR transparently
        yay -S --needed --noconfirm $BROWSERS_TO_INSTALL
    else
        echo ":: No browsers selected."
    fi
}

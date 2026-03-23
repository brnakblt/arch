#!/bin/bash

setup_browsers() {
    while true; do
        print_header "Browser Selection"
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
        SELECTED_NAMES=""

        for choice in "${browser_choices[@]}"; do
            case $choice in
                1) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL firefox"; SELECTED_NAMES="$SELECTED_NAMES Firefox" ;;
                2) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL chromium"; SELECTED_NAMES="$SELECTED_NAMES Chromium" ;;
                3) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL brave-bin"; SELECTED_NAMES="$SELECTED_NAMES Brave" ;;
                4) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL librewolf-bin"; SELECTED_NAMES="$SELECTED_NAMES Librewolf" ;;
                5) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL zen-browser-bin"; SELECTED_NAMES="$SELECTED_NAMES Zen" ;;
                6) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL vivaldi"; SELECTED_NAMES="$SELECTED_NAMES Vivaldi" ;;
                7) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL opera"; SELECTED_NAMES="$SELECTED_NAMES Opera" ;;
                8) BROWSERS_TO_INSTALL="$BROWSERS_TO_INSTALL thorium-browser-bin"; SELECTED_NAMES="$SELECTED_NAMES Thorium" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No browsers selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$BROWSERS_TO_INSTALL" ]; then
            echo ":: Installing selected browsers: $BROWSERS_TO_INSTALL"
            # Using yay to handle both official and AUR transparently
            yay -S --needed --noconfirm $BROWSERS_TO_INSTALL
        fi
        break
    done
}

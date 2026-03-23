#!/bin/bash

setup_editors() {
    while true; do
        print_header "Text Editor / IDE Selection"
        echo "   Enter numbers separated by spaces (e.g., '2 4 5')"
        echo "1) Vim (Official - Classic, highly configurable text editor)"
        echo "2) Neovim (Official - Modern fork of Vim, Lua-based config)"
        echo "3) LazyVim (Neovim + Preconfigured - Instant IDE experience)"
        echo "4) VS Code (OSS) (Official - Open-source build of VS Code)"
        echo "5) VSCodium (AUR - Telemetry-free VS Code binary)"
        echo "6) Cursor (AI Editor) (AUR - VS Code fork with built-in AI)"
        echo "7) Sublime Text 4 (AUR - Fast, sophisticated text editor)"
        echo "8) Zed (Official - High-performance, multiplayer code editor)"
        echo "9) Emacs (Official - The extensible, customizable text editor)"

        read -p ":: Choose editors to install: " -a editor_choices

        EDITORS_TO_INSTALL=""
        INSTALL_LAZYVIM=false
        SELECTED_NAMES=""

        for choice in "${editor_choices[@]}"; do
            case $choice in
                1) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL vim"; SELECTED_NAMES="$SELECTED_NAMES Vim" ;;
                2) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL neovim"; SELECTED_NAMES="$SELECTED_NAMES Neovim" ;;
                3) 
                    EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL neovim" 
                    INSTALL_LAZYVIM=true
                    SELECTED_NAMES="$SELECTED_NAMES LazyVim"
                    ;;
                4) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL code"; SELECTED_NAMES="$SELECTED_NAMES VSCode(OSS)" ;;
                5) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL vscodium-bin"; SELECTED_NAMES="$SELECTED_NAMES VSCodium" ;;
                6) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL cursor-bin"; SELECTED_NAMES="$SELECTED_NAMES Cursor" ;;
                7) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL sublime-text-4"; SELECTED_NAMES="$SELECTED_NAMES SublimeText" ;;
                8) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL zed"; SELECTED_NAMES="$SELECTED_NAMES Zed" ;;
                9) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL emacs"; SELECTED_NAMES="$SELECTED_NAMES Emacs" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No editors selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        if [ -n "$EDITORS_TO_INSTALL" ]; then
            echo ":: Installing selected editors: $EDITORS_TO_INSTALL"
            # Using yay to handle both official and AUR
            yay -S --needed --noconfirm $EDITORS_TO_INSTALL
        fi

        if [ "$INSTALL_LAZYVIM" = true ]; then
            echo ":: Setting up LazyVim..."
            if [ -d "$HOME/.config/nvim" ]; then
                echo ":: Backing up existing Neovim config..."
                mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
            fi
            
            echo ":: Cloning LazyVim starter..."
            git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
            rm -rf "$HOME/.config/nvim/.git"
            echo ":: LazyVim setup complete."
        fi
        break
    done
}

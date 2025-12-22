#!/bin/bash

setup_editors() {
    echo ":: Text Editor / IDE Selection"
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

    for choice in "${editor_choices[@]}"; do
        case $choice in
            1) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL vim" ;;
            2) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL neovim" ;;
            3) 
                EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL neovim" 
                INSTALL_LAZYVIM=true
                ;;
            4) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL code" ;;
            5) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL vscodium-bin" ;;
            6) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL cursor-bin" ;;
            7) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL sublime-text-4" ;;
            8) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL zed" ;;
            9) EDITORS_TO_INSTALL="$EDITORS_TO_INSTALL emacs" ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$EDITORS_TO_INSTALL" ]; then
        echo ":: Installing selected editors: $EDITORS_TO_INSTALL"
        # Using yay to handle both official and AUR
        yay -S --needed --noconfirm $EDITORS_TO_INSTALL
    fi

    if [ "$INSTALL_LAZYVIM" = true ]; then
        echo ":: Setting up LazyVim..."
        # Backup existing nvim config if it exists
        if [ -d "$HOME/.config/nvim" ]; then
            echo ":: Backing up existing Neovim config..."
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # Clone LazyVim starter
        echo ":: Cloning LazyVim starter..."
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        # Remove the .git folder so it's a fresh repo for the user
        rm -rf "$HOME/.config/nvim/.git"
        echo ":: LazyVim setup complete."
    fi
    
    if [ -z "$EDITORS_TO_INSTALL" ]; then
        echo ":: No editors selected."
    fi
}

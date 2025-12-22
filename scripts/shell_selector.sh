#!/bin/bash

setup_shell() {
    echo ":: Shell & Prompt Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 4')"
    echo "1) Zsh (Official - Popular, highly customizable)"
    echo "2) Fish (Official - User friendly, autosuggestions out of the box)"
    echo "3) Nushell (Official - Modern, structured data shell)"
    echo "4) Starship (Official - Cross-shell, fast, customizable prompt)"
    echo "5) Oh My Zsh (Script - Framework for managing Zsh config)"
    echo "6) Zsh Plugins (Autosuggestions + Syntax Highlighting)"

    read -p ":: Choose shell tools to install: " -a shell_choices

    SHELL_PKGS=""
    INSTALL_OMZ=false
    INSTALL_ZSH_PLUGINS=false

    for choice in "${shell_choices[@]}"; do
        case $choice in
            1) SHELL_PKGS="$SHELL_PKGS zsh zsh-completions" ;;
            2) SHELL_PKGS="$SHELL_PKGS fish" ;;
            3) SHELL_PKGS="$SHELL_PKGS nushell" ;;
            4) SHELL_PKGS="$SHELL_PKGS starship" ;;
            5) INSTALL_OMZ=true ;;
            6) INSTALL_ZSH_PLUGINS=true ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ -n "$SHELL_PKGS" ]; then
        echo ":: Installing selected shell packages: $SHELL_PKGS"
        yay -S --needed --noconfirm $SHELL_PKGS
    fi

    if [ "$INSTALL_OMZ" = true ]; then
        # Check if Zsh is installed/selected
        if command -v zsh &> /dev/null || [[ "$SHELL_PKGS" == *"zsh"* ]]; then
            echo ":: Installing Oh My Zsh (unattended)..."
            if [ -d "$HOME/.oh-my-zsh" ]; then
                echo ":: Oh My Zsh already installed."
            else
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            fi
        else
            echo ":: Skipping Oh My Zsh: Zsh not installed/selected."
        fi
    fi

    if [ "$INSTALL_ZSH_PLUGINS" = true ]; then
         echo ":: Installing Zsh Autosuggestions & Syntax Highlighting..."
         yay -S --needed --noconfirm zsh-autosuggestions zsh-syntax-highlighting
         echo ":: Note: You will need to add these plugins to your .zshrc manually if not using a framework."
    fi

    if [ -z "$SHELL_PKGS" ] && [ "$INSTALL_OMZ" = false ] && [ "$INSTALL_ZSH_PLUGINS" = false ]; then
        echo ":: No shell tools selected."
    fi
}

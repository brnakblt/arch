#!/bin/bash

setup_terminal() {
    while true; do
        print_header "Terminal Emulator Selection"
        echo "1) Kitty (GPU accelerated, highly scriptable, image support)"
        echo "2) Alacritty (Fast, GPU accelerated, minimal, configuration via YAML/TOML)"
        echo "3) Ghostty (Modern, fast, native feel, feature-rich)"
        echo "4) Foot (Wayland native, lightweight, fast, low resource usage)"
        
        read -p ":: Choose your terminal (1-4): " term_choice

        TERM_PKG=""
        TERM_CMD=""
        SELECTED_NAME=""

        case $term_choice in
            1)
                TERM_PKG="kitty"
                TERM_CMD="kitty"
                SELECTED_NAME="Kitty"
                ;;
            2)
                TERM_PKG="alacritty"
                TERM_CMD="alacritty"
                SELECTED_NAME="Alacritty"
                ;;
            3)
                TERM_PKG="ghostty"
                TERM_CMD="ghostty"
                SELECTED_NAME="Ghostty"
                ;;
            4)
                TERM_PKG="foot"
                TERM_CMD="foot"
                SELECTED_NAME="Foot"
                ;;
            *)
                echo ":: Invalid choice. Defaulting to Kitty."
                TERM_PKG="kitty"
                TERM_CMD="kitty"
                SELECTED_NAME="Kitty (Default)"
                ;;
        esac

        echo ":: You selected: $SELECTED_NAME"

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        echo ":: Installing $TERM_PKG..."
        sudo pacman -S --needed --noconfirm "$TERM_PKG"

        # Create a wrapper script so configs don't need changing if terminal changes
        echo ":: Setting up terminal wrapper..."
        mkdir -p "$HOME/.local/bin"
        
        WRAPPER="$HOME/.local/bin/me-terminal"
        
        echo "#!/bin/bash" > "$WRAPPER"
        echo "exec $TERM_CMD \"\$@\"" >> "$WRAPPER"
        chmod +x "$WRAPPER"
        
        echo ":: Terminal setup complete. '$TERM_CMD' is set as default via 'me-terminal'."
        break
    done
}

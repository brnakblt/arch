#!/bin/bash

setup_dotfiles() {
    echo ":: Setting up dotfiles..."
    
    SOURCE_DIR="$(pwd)/dotfiles"
    TARGET_DIR="$HOME/.config"
    BACKUP_DIR="$HOME/.config/backup_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$TARGET_DIR"

    # List of directories to manage
    DIRS=("hypr" "niri" "waybar" "kitty")

    for dir in "${DIRS[@]}"; do
        if [ -d "$TARGET_DIR/$dir" ]; then
            echo ":: Backing up existing $dir config to $BACKUP_DIR/$dir"
            mkdir -p "$BACKUP_DIR"
            mv "$TARGET_DIR/$dir" "$BACKUP_DIR/"
        fi
        
        echo ":: Symlinking $dir..."
        ln -sf "$SOURCE_DIR/$dir" "$TARGET_DIR/"
    done
    
    echo ":: Dotfiles installed."
}

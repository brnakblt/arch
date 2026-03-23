#!/bin/bash

setup_dotfiles() {
    print_header "Dotfiles & Configuration Setup"
    echo ":: You can choose to use preconfigured local profiles or pull from an external Git repository."
    echo "1) Use local preconfigured profiles (Hyprland, Niri, Waybar, etc.)"
    echo "2) Pull from an external Git repository (Custom dotfiles)"
    echo "3) Skip configuration"

    read -p ":: Choose configuration method: " dot_method

    case $dot_method in
        1)
            # Local setup logic
            SOURCE_DIR="$(pwd)/dotfiles"
            TARGET_DIR="$HOME/.config"
            BACKUP_DIR="$HOME/.config/backup_$(date +%Y%m%d_%H%M%S)"
            
            mkdir -p "$TARGET_DIR"

            # Helper function to link a profile
            link_profile() {
                local tool=$1
                local profile=$2
                
                echo ":: Setting up $tool (Profile: $profile)..."
                local src="$SOURCE_DIR/$tool/$profile"
                local dest="$TARGET_DIR/$tool"

                if [ ! -d "$src" ]; then
                    echo ":: Error: Profile directory '$src' does not exist. Skipping."
                    return
                fi

                if [ -d "$dest" ] || [ -L "$dest" ]; then
                    echo ":: Backing up existing $tool config to $BACKUP_DIR/$tool"
                    mkdir -p "$BACKUP_DIR"
                    mv "$dest" "$BACKUP_DIR/"
                fi
                
                echo ":: Symlinking $src -> $dest"
                ln -sf "$src" "$dest"
            }

            # 1. Hyprland Profile Selection
            if command -v Hyprland &> /dev/null; then
                echo ":: Hyprland detected."
                echo "   Choose a configuration profile:"
                echo "   1) Default (Simple, clean)"
                echo "   2) End-4 (Rich, futuristic)"
                echo "   3) DMS (Desktop-like)"
                echo "   4) Noctalia (Dark, moody)"
                echo "   5) Skip (I will handle my own configuration)"
                
                read -p ":: Select profile (default: 1): " hypr_choice
                case $hypr_choice in
                    2) link_profile "hypr" "end-4" ;;
                    3) link_profile "hypr" "dms" ;;
                    4) link_profile "hypr" "noctalia" ;;
                    5) echo ":: Skipping Hyprland configuration." ;;
                    *) link_profile "hypr" "default" ;;
                esac
            fi

            # 2. Niri Profile Selection
            if command -v niri &> /dev/null; then
                echo ":: Niri detected."
                echo "   Choose a configuration profile:"
                echo "   1) Default (Clean)"
                echo "   2) DMS (Desktop-like)"
                echo "   3) Skip (I will handle my own configuration)"
                
                read -p ":: Select profile (default: 1): " niri_choice
                case $niri_choice in
                    2) link_profile "niri" "dms" ;;
                    3) echo ":: Skipping Niri configuration." ;;
                    *) link_profile "niri" "default" ;;
                esac
            fi

            # 3. Standard Tools (Kitty, Waybar)
            read -p ":: Do you want to install default Kitty configuration? [Y/n] " kitty_q
            if [[ ! "$kitty_q" =~ ^[Nn]$ ]]; then
                link_profile "kitty" "default"
            fi

            read -p ":: Do you want to install default Waybar configuration? [Y/n] " waybar_q
            if [[ ! "$waybar_q" =~ ^[Nn]$ ]]; then
                link_profile "waybar" "default"
            fi
            ;;
        2)
            # External repository logic
            read -p ":: Enter dotfiles Git repository URL: " dot_repo_url
            if [ -n "$dot_repo_url" ]; then
                DOT_TMP="/tmp/external_dotfiles"
                rm -rf "$DOT_TMP"
                echo ":: Cloning external dotfiles..."
                git clone "$dot_repo_url" "$DOT_TMP"
                
                echo ":: External dotfiles cloned to $DOT_TMP."
                echo ":: You will need to manually link or use a provided install script in that repo."
                read -p ":: Would you like to try running 'install.sh' or 'setup.sh' if found? [y/N] " run_ext_install
                if [[ "$run_ext_install" =~ ^[Yy]$ ]]; then
                    if [ -f "$DOT_TMP/install.sh" ]; then
                        bash "$DOT_TMP/install.sh"
                    elif [ -f "$DOT_TMP/setup.sh" ]; then
                        bash "$DOT_TMP/setup.sh"
                    else
                        echo ":: No install.sh or setup.sh found in the repository."
                    fi
                fi
            else
                echo ":: No URL provided. Skipping."
            fi
            ;;
        3)
            echo ":: Skipping dotfiles configuration."
            ;;
        *)
            echo ":: Invalid choice. Skipping."
            ;;
    esac

    echo ":: Dotfiles setup complete."
}

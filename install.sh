#!/bin/bash

# Main Installer Script for Arch Linux Hyprland/Niri Setup

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source helper scripts
source "$SCRIPT_DIR/scripts/gpu_check.sh"
source "$SCRIPT_DIR/scripts/aur_helper.sh"
source "$SCRIPT_DIR/scripts/dotfiles.sh"
source "$SCRIPT_DIR/scripts/terminal_selector.sh"
source "$SCRIPT_DIR/scripts/browser_selector.sh"
source "$SCRIPT_DIR/scripts/editor_selector.sh"
source "$SCRIPT_DIR/scripts/file_manager_selector.sh"
source "$SCRIPT_DIR/scripts/music_selector.sh"
source "$SCRIPT_DIR/scripts/tool_selector.sh"
source "$SCRIPT_DIR/scripts/social_gaming_selector.sh"
source "$SCRIPT_DIR/scripts/dev_tools_selector.sh"
source "$SCRIPT_DIR/scripts/shell_selector.sh"
source "$SCRIPT_DIR/scripts/office_selector.sh"
source "$SCRIPT_DIR/scripts/communication_selector.sh"
source "$SCRIPT_DIR/scripts/utils_selector.sh"
source "$SCRIPT_DIR/scripts/theme_selector.sh"

echo "=========================================="
echo "   Arch Linux Hyprland/Niri Installer     "
echo "=========================================="

# Check if running on Arch Linux
if ! grep -q "Arch Linux" /etc/os-release; then
    echo "Error: This script is intended for Arch Linux."
    exit 1
fi

# 1. System Update
echo ":: Updating system..."
sudo pacman -Syu --noconfirm

# 2. Prepare Package List
echo ":: Reading package lists..."
OFFICIAL_PACKAGES=$(grep -v '^#' "$SCRIPT_DIR/packages/official.txt" | tr '\n' ' ')

# GPU Check and append packages
NVIDIA_PACKAGES=$(setup_gpu)
if [ -n "$NVIDIA_PACKAGES" ]; then
    OFFICIAL_PACKAGES="$OFFICIAL_PACKAGES $NVIDIA_PACKAGES"
fi

# 3. Install Official Packages
echo ":: Installing official packages..."
echo "Targets: $OFFICIAL_PACKAGES"
sudo pacman -S --needed --noconfirm $OFFICIAL_PACKAGES

# 4. Setup AUR Helper
setup_aur_helper

# 5. Install AUR Packages
echo ":: Installing AUR packages..."
AUR_PACKAGES=$(grep -v '^#' "$SCRIPT_DIR/packages/aur.txt" | tr '\n' ' ')
echo "Targets: $AUR_PACKAGES"
yay -S --needed --noconfirm $AUR_PACKAGES

# 6. Setup Terminal
setup_terminal

# 7. Setup Browsers
setup_browsers

# 8. Setup Editors
setup_editors

# 9. Setup File Managers
setup_file_managers

# 10. Setup Music Platforms
setup_music_platforms

# 11. Setup Multimedia Tools
setup_multimedia_tools

# 12. Setup Social & Gaming
setup_social_gaming

# 13. Setup Developer Tools
setup_dev_tools

# 14. Setup Shell & Prompt
setup_shell

# 15. Setup Office & Productivity
setup_office

# 16. Setup Communication
setup_communication

# 17. Setup Utilities
setup_utils

# 18. Setup Themes
setup_themes

# 19. Setup Dotfiles
setup_dotfiles

# 20. Enable Services
echo ":: Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable sddm

echo "=========================================="
echo "   Installation Complete!                 "
echo "=========================================="
echo "Please reboot your system."

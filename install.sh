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
source "$SCRIPT_DIR/scripts/audio_bluetooth_selector.sh"
source "$SCRIPT_DIR/scripts/music_selector.sh"
source "$SCRIPT_DIR/scripts/tool_selector.sh"
source "$SCRIPT_DIR/scripts/social_gaming_selector.sh"
source "$SCRIPT_DIR/scripts/dev_tools_selector.sh"
source "$SCRIPT_DIR/scripts/shell_selector.sh"
source "$SCRIPT_DIR/scripts/office_selector.sh"
source "$SCRIPT_DIR/scripts/communication_selector.sh"
source "$SCRIPT_DIR/scripts/utils_selector.sh"
source "$SCRIPT_DIR/scripts/theme_selector.sh"
source "$SCRIPT_DIR/scripts/asus_selector.sh"
# Source helper scripts
source "$SCRIPT_DIR/scripts/common.sh"
source "$SCRIPT_DIR/scripts/gpu_check.sh"
source "$SCRIPT_DIR/scripts/aur_helper.sh"
source "$SCRIPT_DIR/scripts/dotfiles.sh"
source "$SCRIPT_DIR/scripts/terminal_selector.sh"
source "$SCRIPT_DIR/scripts/browser_selector.sh"
source "$SCRIPT_DIR/scripts/editor_selector.sh"
source "$SCRIPT_DIR/scripts/file_manager_selector.sh"
source "$SCRIPT_DIR/scripts/audio_bluetooth_selector.sh"
source "$SCRIPT_DIR/scripts/music_selector.sh"
source "$SCRIPT_DIR/scripts/tool_selector.sh"
source "$SCRIPT_DIR/scripts/social_gaming_selector.sh"
source "$SCRIPT_DIR/scripts/dev_tools_selector.sh"
source "$SCRIPT_DIR/scripts/shell_selector.sh"
source "$SCRIPT_DIR/scripts/office_selector.sh"
source "$SCRIPT_DIR/scripts/communication_selector.sh"
source "$SCRIPT_DIR/scripts/utils_selector.sh"
source "$SCRIPT_DIR/scripts/theme_selector.sh"
source "$SCRIPT_DIR/scripts/asus_selector.sh"
source "$SCRIPT_DIR/scripts/desktop_env_selector.sh"

print_header "Arch Linux Desktop/WM Installer"

# Check if running on Arch Linux
if ! grep -q "Arch Linux" /etc/os-release; then
    echo "Error: This script is intended for Arch Linux."
    exit 1
fi

# 1. System Update
echo ":: Updating system..."
sudo pacman -Syu --noconfirm
wait_for_keypress

# 2. Prepare Package List
print_header "System Preparation"
echo ":: Reading package lists..."
OFFICIAL_PACKAGES=$(grep -v '^#' "$SCRIPT_DIR/packages/official.txt" | tr '\n' ' ')

# GPU Check and append packages
setup_gpu
if [ -n "$GPU_PACKAGES" ]; then
    OFFICIAL_PACKAGES="$OFFICIAL_PACKAGES $GPU_PACKAGES"
fi

# 3. Install Official Packages
echo ":: Installing official packages..."
echo "Targets: $OFFICIAL_PACKAGES"
sudo pacman -S --needed --noconfirm $OFFICIAL_PACKAGES
wait_for_keypress

# 4. Setup AUR Helper
print_header "AUR Helper Setup"
setup_aur_helper
wait_for_keypress

# 5. Install AUR Packages
print_header "Installing Base AUR Packages"
AUR_PACKAGES=$(grep -v '^#' "$SCRIPT_DIR/packages/aur.txt" | tr '\n' ' ')
echo "Targets: $AUR_PACKAGES"
yay -S --needed --noconfirm $AUR_PACKAGES
wait_for_keypress

# 6. Setup Desktop Environment
setup_desktop_env
wait_for_keypress

# 7. Setup Terminal
setup_terminal
wait_for_keypress

# 8. Setup Browsers
setup_browsers
wait_for_keypress

# 9. Setup Editors
setup_editors
wait_for_keypress

# 10. Setup File Managers
setup_file_managers
wait_for_keypress

# 11. Setup Audio & Bluetooth
setup_audio_bluetooth
wait_for_keypress

# 12. Setup Music Platforms
setup_music_platforms
wait_for_keypress

# 13. Setup Multimedia Tools
setup_multimedia_tools
wait_for_keypress

# 14. Setup Social & Gaming
setup_social_gaming
wait_for_keypress

# 15. Setup Developer Tools
setup_dev_tools
wait_for_keypress

# 16. Setup Shell & Prompt
setup_shell
wait_for_keypress

# 17. Setup Office & Productivity
setup_office
wait_for_keypress

# 18. Setup Communication
setup_communication
wait_for_keypress

# 19. Setup Utilities
setup_utils
wait_for_keypress

# 20. Setup Themes
setup_themes
wait_for_keypress

# 21. Setup ASUS ROG/TUF Tools
setup_asus
wait_for_keypress

# 22. Setup Dotfiles
setup_dotfiles
wait_for_keypress

# 23. Enable Services
print_header "Enabling Services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable sddm

print_header "Installation Complete!"
echo "Please reboot your system."

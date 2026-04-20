# Arch Linux Automated Installer & Rice

A comprehensive, modular automated installer for Arch Linux, designed to set up a modern tiling window manager environment (Hyprland/Niri) with hardware-specific optimizations.

## 🚀 Quick Install (One-Liners)

For those who want pre-configured options or external scripts:

**DankLinux Preconfigured:**
```bash
curl -fsSL https://install.danklinux.com | sh
```

**Interactive Options (clsty):**
```bash
bash <(curl -s https://ii.clsty.link/get)
```

---

## 🛠️ This Repository's Installer

The `install.sh` in this repo provides a surgical, modular installation process.

### How it works:
1.  **System Check:** Verifies Arch Linux and runs a full system update.
2.  **Hardware Detection:** Automatically detects GPU (NVIDIA/AMD/Intel) and applies specific fixes:
    *   **NVIDIA:** Configures Early KMS, `modeset=1`, `fbdev=1`, and video memory preservation.
    *   **ASUS:** Sets up `asusctl`, `rog-control-center`, and custom G14 kernels.
3.  **Modular Selectors:** You choose what to install:
    *   **Desktop:** Hyprland (Dynamic) or Niri (Scrollable).
    *   **Dev Tools:** Full SDK support for .NET, Rust, Node.js, Go, Python, and Java.
    *   **Apps:** Browsers, Editors, File Managers, and Social/Gaming tools.
4.  **Optimizations:** 
    *   **Niri + NVIDIA:** Automatic fix for idle VRAM consumption.
    *   **Flatpak:** Optional support installation.
5.  **Dotfiles:** Deploys pre-configured configurations for window managers, Waybar, and Kitty.

### Usage:
```bash
git clone https://github.com/your-username/arch.git
cd arch
chmod +x install.sh
./install.sh
```

## 📦 Package Management
*   **Official:** Defined in `packages/official.txt`
*   **AUR:** Defined in `packages/aur.txt` (uses `yay` automatically)
*   **Flatpak:** Optional step included in the main script.

## 🔧 ASUS ROG/TUF Support
This script includes specialized support for ASUS laptops via the `g14` repository, including fan control, LED profiles, and kernel patches.

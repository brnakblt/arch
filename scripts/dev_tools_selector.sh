#!/bin/bash

setup_dev_tools() {
    echo ":: Developer Tools & SDK Selection"
    echo "   Enter numbers separated by spaces (e.g., '1 2 5')"
    echo "1) JDK 17 (Legacy LTS Java Development Kit)"
    echo "2) JDK 21 (Modern LTS Java Development Kit)"
    echo "3) Android Studio & SDK (Full Android dev environment)"
    echo "4) CMake (Cross-platform build system generator)"
    echo "5) Docker & Docker Compose (Containerization platform)"
    echo "6) Node.js Ecosystem (JS/TS runtimes and package managers)"
    echo "7) Rust (Systems programming language via rustup)"
    echo "8) Go (Statically typed, compiled language by Google)"
    echo "9) Python + pip (Versatile scripting language & package installer)"
    echo "10) GCC / Clang (Essential C/C++ compiler collections)"
    echo "11) QEMU / Virt-manager (Virtual Machine & Emulation suite)"

    read -p ":: Choose dev tools to install: " -a dev_choices

    DEV_TO_INSTALL=""
    SETUP_DOCKER=false
    SETUP_RUST=false
    SETUP_VIRT=false
    SETUP_NODE=false

    for choice in "${dev_choices[@]}"; do
        case $choice in
            1) DEV_TO_INSTALL="$DEV_TO_INSTALL jdk17-openjdk" ;;
            2) DEV_TO_INSTALL="$DEV_TO_INSTALL jdk21-openjdk" ;;
            3) DEV_TO_INSTALL="$DEV_TO_INSTALL android-studio" ;; # Android Studio includes SDK manager
            4) DEV_TO_INSTALL="$DEV_TO_INSTALL cmake" ;;
            5) 
                DEV_TO_INSTALL="$DEV_TO_INSTALL docker docker-compose" 
                SETUP_DOCKER=true
                ;;
            6) SETUP_NODE=true ;;
            7) 
                DEV_TO_INSTALL="$DEV_TO_INSTALL rustup"
                SETUP_RUST=true
                ;;
            8) DEV_TO_INSTALL="$DEV_TO_INSTALL go" ;;
            9) DEV_TO_INSTALL="$DEV_TO_INSTALL python python-pip" ;;
            10) DEV_TO_INSTALL="$DEV_TO_INSTALL gcc clang" ;;
            11) 
                DEV_TO_INSTALL="$DEV_TO_INSTALL qemu-full virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables"
                SETUP_VIRT=true
                ;;
            *) echo ":: Invalid choice '$choice' ignored." ;;
        esac
    done

    if [ "$SETUP_NODE" = true ]; then
        echo ":: Node.js Ecosystem Selection"
        echo "   Enter numbers separated by spaces (e.g., '1 3 5')"
        echo "1) NVM (Node Version Manager) - Standard, shell-based manager. Good for stability."
        echo "2) FNM (Fast Node Manager) - Written in Rust, extremely fast. Good for speed."
        echo "3) npm (Node Package Manager) - The default package manager for Node.js."
        echo "4) pnpm (Performant NPM) - Disk-efficient, fast, strict dependency handling."
        echo "5) Yarn (Yet Another Resource Negotiator) - Reliable, widely used alternative to npm."
        echo "6) Bun (All-in-one toolkit) - Includes runtime, bundler, test runner, and package manager."

        read -p ":: Choose Node tools: " -a node_choices

        NODE_PKGS=""
        INSTALL_NVM=false
        INSTALL_FNM=false

        for nc in "${node_choices[@]}"; do
             case $nc in
                1) INSTALL_NVM=true ;;
                2) INSTALL_FNM=true ;;
                3) NODE_PKGS="$NODE_PKGS npm" ;;
                4) NODE_PKGS="$NODE_PKGS pnpm" ;;
                5) NODE_PKGS="$NODE_PKGS yarn" ;;
                6) NODE_PKGS="$NODE_PKGS bun-bin" ;;
             esac
        done
        
        if [ "$INSTALL_NVM" = true ]; then
             echo ":: Installing NVM..."
             yay -S --needed --noconfirm nvm
             echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.bashrc
             source /usr/share/nvm/init-nvm.sh
             echo ":: Installing Node.js LTS via NVM..."
             nvm install --lts
             nvm use --lts
        fi

        if [ "$INSTALL_FNM" = true ]; then
             echo ":: Installing FNM..."
             yay -S --needed --noconfirm fnm-bin
             echo 'eval "$(fnm env --use-on-cd)"' >> ~/.bashrc
             eval "$(fnm env --use-on-cd)"
             echo ":: Installing Node.js LTS via FNM..."
             fnm install --lts
             fnm use lts
        fi

        if [ -n "$NODE_PKGS" ]; then
             # If npm is chosen but no manager wasn't, ensure system node is installed
             if [[ "$NODE_PKGS" == *"npm"* ]] && [ "$INSTALL_NVM" = false ] && [ "$INSTALL_FNM" = false ]; then
                 NODE_PKGS="nodejs-lts-iron $NODE_PKGS"
             fi
             echo ":: Installing Node tools: $NODE_PKGS"
             yay -S --needed --noconfirm $NODE_PKGS
        fi
    fi

    if [ -n "$DEV_TO_INSTALL" ]; then
        echo ":: Installing selected dev tools: $DEV_TO_INSTALL"
        yay -S --needed --noconfirm $DEV_TO_INSTALL
    fi

    if [ "$SETUP_VIRT" = true ]; then
        echo ":: Configuring Virtualization..."
        sudo systemctl enable --now libvirtd.service
        sudo usermod -aG libvirt "$USER"
        echo ":: Added $USER to 'libvirt' group (requires logout/login to take effect)."
    fi

    if [ "$SETUP_DOCKER" = true ]; then
        echo ":: Configuring Docker..."
        sudo systemctl enable --now docker.service
        sudo usermod -aG docker "$USER"
        echo ":: Added $USER to 'docker' group (requires logout/login to take effect)."
    fi

    if [ "$SETUP_RUST" = true ]; then
        echo ":: Initializing Rust toolchain..."
        rustup default stable
    fi

    if [ -z "$DEV_TO_INSTALL" ]; then
        echo ":: No dev tools selected."
    fi
}

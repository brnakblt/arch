#!/bin/bash

setup_dev_tools() {
    while true; do
        print_header "Developer Tools & SDK Selection"
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
        echo "12) .NET Ecosystem (C#, F#, VB.NET runtimes & SDKs)"

        read -p ":: Choose dev tools to install: " -a dev_choices

        DEV_TO_INSTALL=""
        SETUP_DOCKER=false
        SETUP_RUST=false
        SETUP_VIRT=false
        SETUP_NODE=false
        SETUP_DOTNET=false
        SELECTED_NAMES=""

        for choice in "${dev_choices[@]}"; do
            case $choice in
                1) DEV_TO_INSTALL="$DEV_TO_INSTALL jdk17-openjdk"; SELECTED_NAMES="$SELECTED_NAMES JDK17" ;;
                2) DEV_TO_INSTALL="$DEV_TO_INSTALL jdk21-openjdk"; SELECTED_NAMES="$SELECTED_NAMES JDK21" ;;
                3) DEV_TO_INSTALL="$DEV_TO_INSTALL android-studio"; SELECTED_NAMES="$SELECTED_NAMES AndroidStudio" ;;
                4) DEV_TO_INSTALL="$DEV_TO_INSTALL cmake"; SELECTED_NAMES="$SELECTED_NAMES CMake" ;;
                5) 
                    DEV_TO_INSTALL="$DEV_TO_INSTALL docker docker-compose" 
                    SETUP_DOCKER=true
                    SELECTED_NAMES="$SELECTED_NAMES Docker"
                    ;;
                6) SETUP_NODE=true; SELECTED_NAMES="$SELECTED_NAMES Node.js" ;;
                7) 
                    DEV_TO_INSTALL="$DEV_TO_INSTALL rustup"
                    SETUP_RUST=true
                    SELECTED_NAMES="$SELECTED_NAMES Rust"
                    ;;
                8) DEV_TO_INSTALL="$DEV_TO_INSTALL go"; SELECTED_NAMES="$SELECTED_NAMES Go" ;;
                9) DEV_TO_INSTALL="$DEV_TO_INSTALL python python-pip"; SELECTED_NAMES="$SELECTED_NAMES Python" ;;
                10) DEV_TO_INSTALL="$DEV_TO_INSTALL gcc clang"; SELECTED_NAMES="$SELECTED_NAMES GCC/Clang" ;;
                11) 
                    DEV_TO_INSTALL="$DEV_TO_INSTALL qemu-full virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables"
                    SETUP_VIRT=true
                    SELECTED_NAMES="$SELECTED_NAMES QEMU/Virt"
                    ;;
                12) SETUP_DOTNET=true; SELECTED_NAMES="$SELECTED_NAMES .NET" ;;
                *) echo ":: Invalid choice '$choice' ignored." ;;
            esac
        done

        if [ "$SETUP_DOTNET" = true ]; then
            echo ":: .NET Ecosystem Selection"
            echo "   1) .NET Latest (Current)"
            echo "   2) .NET 9.0 (STS)"
            echo "   3) .NET 8.0 (LTS)"
            read -p ":: Choose .NET version [1-3]: " dotnet_ver_choice
            
            echo "   Select components (space separated):"
            echo "   1) SDK (Required for building apps)"
            echo "   2) Runtime (Only for running apps)"
            echo "   3) ASP.NET Core (Web development)"
            echo "   4) PowerShell Core (Global tool)"
            read -p ":: Choose .NET components: " -a dotnet_comp_choices
        fi

        if [ "$SETUP_NODE" = true ]; then
            echo ":: Node.js Ecosystem Selection"
            echo "   Enter numbers separated by spaces (e.g., '1 3 5')"
            echo "1) NVM (Node Version Manager) - Standard, shell-based manager."
            echo "2) FNM (Fast Node Manager) - Written in Rust, extremely fast."
            echo "3) npm (Node Package Manager)"
            echo "4) pnpm (Performant NPM)"
            echo "5) Yarn (Yet Another Resource Negotiator)"
            echo "6) Bun (All-in-one toolkit)"

            read -p ":: Choose Node tools: " -a node_choices
            # Logic handled below after confirmation
        fi

        if [ -n "$SELECTED_NAMES" ]; then
            echo ":: You selected: $SELECTED_NAMES"
        else
            echo ":: No dev tools selected."
        fi

        read -p ":: Confirm selection? [Y/n/r(retry)] " confirm
        if [[ $confirm =~ ^[Rr]$ ]]; then continue; fi
        if [[ $confirm =~ ^[Nn]$ ]]; then return; fi

        # Process Node Logic Here if confirmed
        if [ "$SETUP_NODE" = true ]; then
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
                 if [[ "$NODE_PKGS" == *"npm"* ]] && [ "$INSTALL_NVM" = false ] && [ "$INSTALL_FNM" = false ]; then
                     NODE_PKGS="nodejs-lts-iron $NODE_PKGS"
                 fi
                 echo ":: Installing Node tools: $NODE_PKGS"
                 yay -S --needed --noconfirm $NODE_PKGS
            fi
        fi

        if [ "$SETUP_DOTNET" = true ]; then
            DOTNET_PKGS=""
            SUFFIX=""
            case $dotnet_ver_choice in
                2) SUFFIX="-9.0" ;;
                3) SUFFIX="-8.0" ;;
            esac

            for dc in "${dotnet_comp_choices[@]}"; do
                case $dc in
                    1) DOTNET_PKGS="$DOTNET_PKGS dotnet-sdk$SUFFIX" ;;
                    2) DOTNET_PKGS="$DOTNET_PKGS dotnet-runtime$SUFFIX" ;;
                    3) 
                        DOTNET_PKGS="$DOTNET_PKGS aspnet-runtime$SUFFIX aspnet-targeting-pack$SUFFIX" 
                        ;;
                    4) INSTALL_PWSH=true ;;
                esac
            done

            if [ -n "$DOTNET_PKGS" ]; then
                echo ":: Installing .NET packages: $DOTNET_PKGS"
                # If versioned, prefer -bin from AUR for consistency
                if [ -n "$SUFFIX" ]; then
                    VER_PKGS=""
                    for p in $DOTNET_PKGS; do VER_PKGS="$VER_PKGS $p-bin"; done
                    yay -S --needed --noconfirm $VER_PKGS
                else
                    sudo pacman -S --needed --noconfirm $DOTNET_PKGS
                fi
            fi

            if [ "$INSTALL_PWSH" = true ]; then
                echo ":: Installing PowerShell Core via dotnet tool..."
                dotnet tool install --global PowerShell
            fi

            echo ":: Configuring .NET Environment (PATH & Telemetry)..."
            if ! grep -q "DOTNET_CLI_TELEMETRY_OPTOUT" ~/.bashrc; then
                echo 'export DOTNET_CLI_TELEMETRY_OPTOUT=1' >> ~/.bashrc
            fi
            if ! grep -q ".dotnet/tools" ~/.bashrc; then
                echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> ~/.bashrc
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
            echo ":: Added $USER to 'libvirt' group."
        fi

        if [ "$SETUP_DOCKER" = true ]; then
            echo ":: Configuring Docker..."
            sudo systemctl enable --now docker.service
            sudo usermod -aG docker "$USER"
            echo ":: Added $USER to 'docker' group."
        fi

        if [ "$SETUP_RUST" = true ]; then
            echo ":: Initializing Rust toolchain..."
            rustup default stable
        fi
        break
    done
}

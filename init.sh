#!/usr/bin/env bash

add_profile() {
   if ! grep -q -- 'source ~/.zprofile' ~/.config/fish/config.fish; then
        ed -s ~/.config/fish/config.fish <<< $'0a\nsource ~/.zprofile\n.\nw\nq'
   fi
}

detect_os_type() {
    local unameOut
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "${ID}" in
                    ubuntu)   OS_TYPE="ubuntu" ;;
                    debian)   OS_TYPE="debian" ;;
                    arch)     OS_TYPE="arch" ;;
                    fedora)   OS_TYPE="fedora" ;;
                    *)        OS_TYPE="linux" ;;
                esac
            else
                OS_TYPE="linux"
            fi
            ;;
        Darwin*)    OS_TYPE="macos" ;;
        CYGWIN*|MINGW*|MSYS*) OS_TYPE="windows" ;;
        *)          OS_TYPE="unknown" ;;
    esac
}

detect_arch_type() {
    local arch
    arch="$(uname -m)"
    case "${arch}" in
        x86_64)   ARCH_TYPE="x64" ;;
        arm64|aarch64) ARCH_TYPE="arm64" ;;
        i*86)     ARCH_TYPE="x86" ;;
        *)        ARCH_TYPE="unknown" ;;
    esac
}

install_package_manager() {
    case "${OS_TYPE}" in
        macos)
            echo "[INFO] Installing Homebrew (via Gitee mirror)..."
            if ! command -v brew >/dev/null 2>&1; then
                /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
                source ~/.zprofile
            else
                echo "[INFO] brew already installed"
            fi
            ;;
        arch)
            echo "[INFO] Detected Arch Linux. Installing 'yay' (AUR helper)..."
            if ! command -v yay >/dev/null 2>&1; then
                sudo pacman -S --noconfirm git base-devel
                cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay
                makepkg -si --noconfirm
            else
                echo "[INFO] yay already installed."
            fi
            ;;
        ubuntu|debian)
            echo "[INFO] Ubuntu/Debian detected. Updating apt."
            sudo apt update
            ;;
        *)
            echo "[WARN] OS '${OS_TYPE}' not supported for package manager install."
            ;;
    esac
}

install_packages() {
    if [ $# -eq 0 ]; then
        echo "[ERROR] No package names provided."
        return 1
    fi

    echo "[INFO] Installing packages: $*"

    case "${OS_TYPE}" in
        macos)
            brew install "$@"
            ;;
        arch)
            sudo pacman -S --noconfirm "$@"
            ;;
        ubuntu|debian)
            sudo apt update
            sudo apt install -y "$@"
            ;;
        *)
            echo "[WARN] Package install not supported on OS_TYPE=${OS_TYPE}"
            return 1
            ;;
    esac
}

add_profile
detect_os_type
detect_arch_type

echo "OS_TYPE=${OS_TYPE}"
echo "ARCH_TYPE=${ARCH_TYPE}"

install_package_manager
install_packages fish


fish ./init.fish

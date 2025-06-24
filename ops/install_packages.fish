function install_packages
    if test (count $argv) -eq 0
        echo "[ERROR] No package names provided."
        return 1
    end

    echo "[INFO] Installing packages: $argv"

    switch "$OS_TYPE"
        case "macos"
            brew install $argv
        case "arch"
            sudo pacman -S --noconfirm $argv
        case "ubuntu" "debian"
            sudo apt update
            sudo apt install -y $argv
        case '*'
            echo "[WARN] Package install not supported on OS_TYPE=$OS_TYPE"
            return 1
    end
end


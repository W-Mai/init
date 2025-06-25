#!/usr/bin/env fish

pushd ops

. ./change_shell.fish
. ./install_packages.fish
. ./init_yadm.fish


# Common packages
set common_packages pyenv curl gnupg

# Platform-specific packages
set macos_packages orbstack yadm
set linux_packages build-essential neofetch

# Install common packages
echo "[INFO] Installing common packages..."
install_packages $common_packages

# Install platform-specific packages
switch "$OS_TYPE"
    case "macos"
        echo "[INFO] Installing macOS-specific packages..."
        install_packages $macos_packages
    case "arch" "ubuntu" "debian"
        echo "[INFO] Installing Linux-specific packages..."
        install_packages $linux_packages
    case '*'
        echo "[WARN] Package install not supported on OS_TYPE=$OS_TYPE"
        return 1
end


# Init modules
setup_dotfiles


popd

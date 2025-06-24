#!/usr/bin/env fish

echo "READY to change default shell"

set fish_path (type -p fish)

if not test -f $fish_path
    echo "[ERROR] fish not found in PATH"
    exit 1
end

if not grep -q -- $fish_path /etc/shells
    echo "[INFO] Adding $fish_path to /etc/shells (requires sudo)"
    echo $fish_path | sudo tee -a /etc/shells
else
    echo "[INFO] $fish_path is already in /etc/shells"
end

chsh -s $fish_path


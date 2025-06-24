#!/usr/bin/env fish

pushd ops

. ./change_shell.fish
. ./install_packages.fish

echo install pa

install_packages \
        orbstack \
        pyenv

popd

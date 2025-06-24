#!/usr/bin/env fish

pushd ops

. ./change_shell.fish
. ./install_packages.fish

install_packages \
        orbstack \
        pyenv

popd

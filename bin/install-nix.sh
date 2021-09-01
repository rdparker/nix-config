#! /usr/bin/env bash

RELEASE="nix-2.4pre20210604_8e6ee1b"
URL="https://github.com/numtide/nix-unstable-installer/releases/download/$RELEASE/install"

# install using workaround for darwin systems
[[ $(uname -s) = "Darwin" ]] && FLAG="--darwin-use-unencrypted-nix-store-volume"
[[ ! -z "$1" ]] && URL="$1"

if command -v nix > /dev/null; then
    echo "nix is already installed on this system."
else
    bash <(curl -L $URL) --daemon $FLAG
fi

if [[ $(uname -s) = "Darwin" ]]; then
    BINDIR=$(dirname $0)
    if nix-channel --list | grep -qw ^darwin > /dev/null; then
        echo "The nix-darwin channel is already installed on this system."
    else
        nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
        nix-channel --update
    fi

    if command -v darwin-build > /dev/null; then
        echo "darwin-build is already installed on this system."
    else
        export NIX_PATH=darwin=darwin-config=$BINDIR/../modules/darwin/default.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
        $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
        $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
    fi
fi

#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export PKG_CONFIG_PATH="$SCRIPTPATH/root/lib/pkgconfig:$SCRIPTPATH/root/share/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig"

export LD_LIBRARY_PATH=$SCRIPTPATH/root/lib
export GPG_ARGS="--gpg-sign=82170E3D --gpg-homedir=$SCRIPTPATH/gnupg"
export EXPORT_ARGS="$GPG_ARGS"
export PATH=$SCRIPTPATH/root/bin:$PATH

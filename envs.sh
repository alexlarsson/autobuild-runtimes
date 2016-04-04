#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export GPG_ARGS="--gpg-sign=82170E3D --gpg-homedir=$SCRIPTPATH/gnupg"
export EXPORT_ARGS="$GPG_ARGS"
export PATH=$SCRIPTPATH/root/bin:$PATH

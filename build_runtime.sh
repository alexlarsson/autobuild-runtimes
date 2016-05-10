#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
ID=$1
VERSION=$2
URL=$3
BRANCH=$4
REPO=$5

DIR="$ID-$VERSION"

# Set this before we change dir
LOCAL_URL=file://`pwd`/export/$REPO

set -u
set -e

echo Build $ID $VERSION at $T
if [ -d $DIR ] ; then
    cd $DIR
    git pull
    git checkout $BRANCH
else
    git clone --branch=$BRANCH $URL $DIR
    cd $DIR
    ln -s ../export/$REPO repo
fi

rm -rf .flatpak-builder/build/*
make EXPORT_ARGS="$GPG_ARGS"
flatpak --user remote-add --no-gpg-verify local-$REPO $LOCAL_URL &> /dev/null  || true
flatpak --user install local-$REPO $ID.Platform $VERSION &> /dev/null || flatpak update --user $ID.Platform $VERSION
flatpak --user install local-$REPO $ID.Sdk $VERSION &> /dev/null  || flatpak update --user $ID.Sdk $VERSION
flatpak --user install local-$REPO $ID.Platform.Locale $VERSION &> /dev/null  || flatpak update --user $ID.Platform.Locale $VERSION
flatpak --user install local-$REPO $ID.Sdk.Locale $VERSION &> /dev/null  || flatpak update --user $ID.Sdk.Locale $VERSION
flatpak --user install local-$REPO $ID.Sdk.Debug $VERSION &> /dev/null  || flatpak update --user $ID.Sdk.Debug $VERSION

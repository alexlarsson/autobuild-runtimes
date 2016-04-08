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

rm -rf .xdg-app-builder/build/*
../lock.sh make EXPORT_ARGS="$GPG_ARGS"
xdg-app --user remote add local-$REPO $LOCAL_URL || true
xdg-app --user install local-$REPO $ID.Platform $VERSION || xdg-app update --user $ID.Platform $VERSION
xdg-app --user install local-$REPO $ID.Sdk $VERSION || xdg-app update --user $ID.Sdk $VERSION
xdg-app --user install local-$REPO $ID.Platform.Locale $VERSION || xdg-app update --user $ID.Platform.Locale $VERSION
xdg-app --user install local-$REPO $ID.Sdk.Locale $VERSION || xdg-app update --user $ID.Sdk.Locale $VERSION
xdg-app --user install local-$REPO $ID.Sdk.Debug $VERSION || xdg-app update --user $ID.Sdk.Debug $VERSION

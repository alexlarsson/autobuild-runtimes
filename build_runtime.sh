#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
ID=$1
VERSION=$2
URL=$3
BRANCH=$4

DIR="$ID-$VERSION"

set -u
set -e

echo Build $ID $VERSION at $T
set -x
if [ -d $DIR ] ; then
    cd $DIR
    git pull
else
    git clone --branch=$BRANCH $URL $DIR
    cd $DIR
    ln -s ../export/repo repo
fi

../lock.sh make EXPORT_ARGS="$GPG_ARGS"
rm -rf .xdg-app-builder/build-*
xdg-app --user install local $ID.Platform $VERSION || true
xdg-app --user install local $ID.Sdk $VERSION || true
xdg-app --user install local $ID.Platform.Locale $VERSION || true
xdg-app --user install local $ID.Sdk.Locale $VERSION || true
xdg-app --user install local $ID.Sdk.Debug $VERSION || true
xdg-app update --user 

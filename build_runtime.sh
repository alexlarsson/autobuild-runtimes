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
if [ -d $DIR ] ; then
    cd $DIR
    git pull
    git checkout $BRANCH
else
    git clone --branch=$BRANCH $URL $DIR
    cd $DIR
    ln -s ../export/repo repo
fi

rm -rf .xdg-app-builder/build-*
../lock.sh make EXPORT_ARGS="$GPG_ARGS"
xdg-app --user install local $ID.Platform $VERSION || xdg-app update --user $ID.Platform $VERSION
xdg-app --user install local $ID.Sdk $VERSION || xdg-app update --user $ID.Sdk $VERSION
xdg-app --user install local $ID.Platform.Locale $VERSION || xdg-app update --user $ID.Platform.Locale $VERSION
xdg-app --user install local $ID.Sdk.Locale $VERSION || xdg-app update --user $ID.Sdk.Locale $VERSION
xdg-app --user install local $ID.Sdk.Debug $VERSION || xdg-app update --user $ID.Sdk.Debug $VERSION

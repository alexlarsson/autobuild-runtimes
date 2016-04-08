#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
ID=$1
VERSION=$2
URL=$3
BRANCH=$4

DIR="$ID-base-$VERSION"

set -u
set -e

echo Build $ID base $VERSION at $T
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
xdg-app --user install local $ID.BaseSdk $VERSION || xdg-app update --user  $ID.BaseSdk $VERSION
xdg-app --user install local $ID.BasePlatform $VERSION || xdg-app update --user $ID.BasePlatform $VERSION

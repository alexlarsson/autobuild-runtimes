#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
ID=$1
VERSION=$2
URL=$3
BRANCH=$4
REPO=$5

DIR="$ID-base-$VERSION"

# Set this before we change dir
URL=file://`pwd`/export/$REPO

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
    ln -s ../export/$REPO repo
fi

../lock.sh make EXPORT_ARGS="$GPG_ARGS"
xdg-app --user remote add local-$REPO $URL || true
xdg-app --user install local-$REPO $ID.BaseSdk $VERSION || xdg-app update --user  $ID.BaseSdk $VERSION
xdg-app --user install local-$REPO $ID.BasePlatform $VERSION || xdg-app update --user $ID.BasePlatform $VERSION

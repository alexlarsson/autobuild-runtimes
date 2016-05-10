#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
ID=$1
VERSION=$2
URL=$3
BRANCH=$4
REPO=$5

DIR="$ID-base-$VERSION"

# Set this before we change dir
LOCAL_URL=file://`pwd`/export/$REPO

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

make EXPORT_ARGS="$GPG_ARGS"
flatpak --user remote-add --no-gpg-verify  local-$REPO $LOCAL_URL &> /dev/null  || true
flatpak --user install local-$REPO $ID.BaseSdk $VERSION &> /dev/null  || flatpak update --user  $ID.BaseSdk $VERSION
flatpak --user install local-$REPO $ID.BasePlatform $VERSION &> /dev/null  || flatpak update --user $ID.BasePlatform $VERSION

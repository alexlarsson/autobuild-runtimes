#!/bin/sh
T=`date +%Y-%m-%d-%H:%M`
NAME=$1
URL=$2
BRANCH=$3
REPO=$4

DIR="$NAME-$BRANCH"

set -u
set -e

echo Build $NAME $BRANCH at $T
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

for i in *.json; do
    T=`date +%Y-%m-%d-%H:%M`
    echo Build $i $BRANCH at $T
    ./build.sh $i &> ../export/logs/build-`basename $i .json`-$BRANCH-$T.log || true
done

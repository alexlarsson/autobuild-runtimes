#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd $SCRIPTPATH

source ./envs.sh

mkdir -p gnupg export/logs export/keys

if [ ! -d  export/repo  ] ; then
    ostree  init --mode=archive-z2 --repo=export/repo
fi

T=`date +%Y-%m-%d-%H:%M`
echo Build Freedesktop base at $T
cd freedesktop-sdk-base/
git pull
../lock.sh make &> ../export/logs/build-fdo-base-$T.log
rm -rf .xdg-app-builder/build-*
xdg-app update --user org.freedesktop.BaseSdk
xdg-app update --user org.freedesktop.BasePlatform
cd ..

echo Build Freedesktop 1.4
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.freedesktop 1.4 git://anongit.freedesktop.org/xdg-app/freedesktop-sdk-images master &> export/logs/build-fdo-1.4-$T.log

echo Build Gnome 3.20
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.gnome 3.20 https://git.gnome.org/browse/gnome-sdk-images gnome-3-20 &> export/logs/build-gnome-3.20-$T.log

echo Build Gnome Master
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.gnome master https://git.gnome.org/browse/gnome-sdk-images master &> export/logs/build-gnome-master-$T.log

cd gnome-apps-nightly
../lock.sh ./build_all_logged.sh
cd ..

T=`date +%Y-%m-%d-%H:%M`
echo Update Repo
../lock.sh ./update_repo.sh &> export/logs/update-repo-$T.log

echo DONE

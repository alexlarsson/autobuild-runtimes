#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd $SCRIPTPATH

source ./envs.sh

mkdir -p gnupg export/logs export/keys

function init_repo {
    if [ ! -d  export/repo-$1  ] ; then
	ostree  init --mode=archive-z2 --repo=export/repo-$1
    fi
}
init_repo staging
init_repo staging-apps
init_repo nightly
init_repo nightly-apps

T=`date +%Y-%m-%d-%H:%M`
echo Build Freedesktop base at $T
./build_base_runtime.sh org.freedesktop 1.4 git://anongit.freedesktop.org/xdg-app/freedesktop-sdk-base 1.4 repo-staging &> export/logs/build-fdo-base-1.4-$T.log

echo Build Freedesktop 1.4
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.freedesktop 1.4 git://anongit.freedesktop.org/xdg-app/freedesktop-sdk-images 1.4 repo-staging &> export/logs/build-fdo-1.4-$T.log

echo Build Gnome 3.20
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.gnome 3.20 https://git.gnome.org/browse/gnome-sdk-images gnome-3-20 repo-staging &> export/logs/build-gnome-3.20-$T.log

T=`date +%Y-%m-%d-%H:%M`
echo Update Staging Repo
./update_repo.sh repo-staging -1 &> export/logs/update-repo-staging-$T.log

echo Build Apps Gnome stable
./build_apps.sh gnome-apps-stable https://github.com/alexlarsson/gnome-apps-nightly.git gnome-3-20 repo-staging-apps

T=`date +%Y-%m-%d-%H:%M`
echo Update Stable Apps Repo
./update_repo.sh repo-staging-apps 4 &> export/logs/update-repo-staging-apps-$T.log

echo Build Gnome Master
T=`date +%Y-%m-%d-%H:%M`
./build_runtime.sh org.gnome master https://git.gnome.org/browse/gnome-sdk-images master repo-nightly &> export/logs/build-gnome-master-$T.log

T=`date +%Y-%m-%d-%H:%M`
echo Update Nightly Repo
./update_repo.sh repo-nightly 4 &> export/logs/update-repo-nightly-$T.log

echo Build Apps Gnome Master
./build_apps.sh gnome-apps-nightly https://github.com/alexlarsson/gnome-apps-nightly.git master repo-nightly-apps

T=`date +%Y-%m-%d-%H:%M`
echo Update Nightly Apps Repo
./update_repo.sh repo-nightly-apps 4 &> export/logs/update-repo-nightly-apps-$T.log

# Remove old logs
find export/logs -mtime +5 -exec rm {} \;

echo DONE

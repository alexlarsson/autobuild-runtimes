#!/bin/bash

REPO=$1
PRUNE_DEPTH=$2

REFS=$(for r in $(ostree refs --repo=export/$REPO) ; do echo $(ostree rev-parse --repo=export/$REPO $r ); done)

# Only keep deltas to the refs heads
for d in $(ostree static-delta list --repo=export/$REPO); do
    t=$(echo $d | sed "s/.*-//")
    if [[ $REFS =~ $t ]] ; then
	echo keeping delta $d
    else
	echo remove delta $d
	ostree static-delta delete  --repo=export/$REPO $d
    fi
done

xdg-app build-update-repo --generate-static-deltas --prune --prune-depth=$PRUNE_DEPTH  ${EXPORT_ARGS-} export/$REPO

echo DONE

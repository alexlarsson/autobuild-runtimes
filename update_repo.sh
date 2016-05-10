#!/bin/bash

REPO=$1
PRUNE_DEPTH=$2

REFS=$(for r in $(ostree refs --repo=export/$REPO) ; do echo $(ostree rev-parse --repo=export/$REPO $r ); done)

if ostree static-delta list --repo=export/repo-staging | grep "No static" ; then
    # No static deltas to remove
    true
else
    # Only keep deltas to the refs heads
    ostree static-delta list --repo=export/$REPO
    for d in $(ostree static-delta list --repo=export/$REPO); do
	t=$(echo $d | sed "s/.*-//")
	if [[ $REFS =~ $t ]] ; then
	    echo keeping delta $d
	else
	    echo remove delta $d
	    ostree static-delta delete  --repo=export/$REPO $d
	fi
    done
fi

flatpak build-update-repo --generate-static-deltas --prune --prune-depth=$PRUNE_DEPTH  ${EXPORT_ARGS-} export/$REPO

echo DONE

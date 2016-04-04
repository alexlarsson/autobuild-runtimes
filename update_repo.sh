#!/bin/sh

find export/repo/deltas -type f -mtime +3 -exec rm "{}" \;
find export/repo/deltas -depth -type d -empty -exec rmdir "{}" \;
xdg-app build-update-repo --generate-static-deltas --prune --prune-depth=4  ${EXPORT_ARGS-} export/repo
find export/logs -mtime +5 -exec rm {} \;

echo DONE

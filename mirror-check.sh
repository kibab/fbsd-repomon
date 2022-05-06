#!/bin/sh
set -eu

head_url=$(cat leader-url)
head_commit=$(git ls-remote $head_url refs/heads/main | cut -f1 -d' ')
if [ $? -ne 0 ]; then
    echo "Cannot get head commit from the leader"
    exit 127
fi
echo "=== Head commit: $head_commit"

for mirr_url in $(cat mirror-list); do
    mirr_head_commit=$(git ls-remote $mirr_url refs/heads/main | cut -f1 -d' ')
    if [ $? -ne 0 ]; then
	echo "Cannot get head commit for mirror $mirr_url"
	exit 127
    fi

    if [ "$mirr_head_commit" == "$head_commit" ]; then
	echo "OK: $mirr_url"
    else
	echo "STALE: $mirr_url"
    fi
done

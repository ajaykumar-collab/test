#!/bin/bash
# merge-html.sh
# $1 = base, $2 = ours, $3 = theirs

# Simple union merge: keep both versions
cat "$2" "$3" > "$2"
exit 0

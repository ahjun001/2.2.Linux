#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

# collect all files 'staged.txt' in $DISK canonical dir tree
declare staged_txts=()
while read -r fullpath; do staged_txts+=("$fullpath"); done < <(find "$DISK" -type f -name 'staged.txt')

# collect all keywords in collected 'staged.txt' files, prepend with keyword length for further sorting
tmp_file=$(mktemp /tmp/02_collect_keywords_from_tree.sh.XXX)
for f in "${staged_txts[@]}"; do
    while read -r k; do
        [[ $k == '' ]] && continue
        echo "${#k}"$'\t'"$k"$'\t'"${f/\/staged.txt/}" >>"$tmp_file"
    done <"$f"
done

# sort keyword dest-dir on decreasing keyword length and put in
sort -t $'\t' -k 1 -rn "$tmp_file" -o "$tmp_file" # n numerical sort

# reposition files from Calibre directory

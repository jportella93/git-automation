#!/bin/bash

usage() {
  echo 'Usage: cherry-pick-range "<commit1> <commit2> <commit3>"'
}

commits="$1"

if [[ -z $1 ]]; then
  echo "ERROR: commits must be set" >&2
  usage >&2
  exit 1
fi

IFS=' '
read -ra ADDR <<< "$commits"

for (( idx=${#ADDR[@]}-1 ; idx>=0 ; idx-- )) ; do
    git cherry-pick "${ADDR[idx]}"
done

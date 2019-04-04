#!/bin/bash

base_commit=''
commit_message=''
current_branch=$(git rev-parse --abbrev-ref HEAD)

usage() {
  echo "Usage: squash-in-new-branch [-c <base_commit>] [-m <commit_message]> "
}

while getopts ':c:m:h' opt; do
  case "$opt" in
    c) base_commit="$OPTARG";;
    m) commit_message="$OPTARG";;
    h)
      usage
      exit
    ;;
    \?)
      echo "Invalid option $OPTARG" >&2
      usage >&2
      exit 1
    ;;
  esac
done

check_is_set() {
  if [[ -z $2 ]]; then
    echo "ERROR: $1 must be set" >&2
    usage >&2
    exit 1
  fi
}

check_is_set "base_commit" $base_commit
check_is_set "commit_message" $commit_message

git checkout -B $current_branch'-squash'
git reset --soft $base_commit
git add .
git commit -m "$commit_message"

#! /bin/bash
# By James Cameron on Egghead https://egghead.io/lessons/git-use-exec-to-redirect-stdio-in-a-git-hook-script

exec >> log/hooks-out.log 2>&1

if git diff-tree --name-only --no-commit-id ORIG_HEAD HEAD | grep --quiet 'package.json'; then
  echo "$(date "+%d-%m-%y|%H:%M:%S"): Running npm install because package.json changed"
  npm install > /dev/null
else
  echo "$(date "+%d-%m-%y|%H:%M:%S"): No changes in package.json found"
fi
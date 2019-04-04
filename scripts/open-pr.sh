#!/bin/bash
# Fork of James Cameron's code on Egghead https://egghead.io/lessons/bash-create-a-bash-script-to-open-a-pull-request-on-github-using-getopts

current_branch=$(git rev-parse --abbrev-ref HEAD)
username=''
title=''
password=''
base='master'
repo_owner=''
repo_name=''

usage() {
  echo "Usage: open-pr [-u <username>] [-p <password/token> [-t <title of the PR>] [-o <repo owner username>] [-n <repo name>] <body of the PR>"
}

while getopts ':u:p:t:b:o:n:h' opt; do
  case "$opt" in
    u) username="$OPTARG";;
    p) password="$OPTARG";;
    t) title="$OPTARG";;
    b) base="$OPTARG";;
    o) repo_owner="$OPTARG";;
    n) repo_name="$OPTARG";;
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

shift $((OPTIND - 1))

if [[ $current_branch == 'master' ]]; then
  echo "You're already on master. Create a new branch, push it, and them tun this script" >&2
  exit 1
fi

check_is_set() {
  if [[ -z $2 ]]; then
    echo "ERROR: $1 must be set" >&2
    usage >&2
    exit 1
  fi
}

check_is_set "username" $username
check_is_set "password" $password
check_is_set "title" $title
check_is_set "repo_owner" $repo_owner
check_is_set "repo_name" $repo_name

data=$(cat <<-END
{
  "title": "$title",
  "base": "$base",
  "head": "$current_branch",
  "body": "$@"
}
END
)

status_code=$(curl -s --user "$username:$password" -X POST "https://api.github.com/repos/$repo_owner/$repo_name/pulls" -d "$data" -w %{http_code} -o /dev/null)

if
  [[ status_code == 201 ]]; then
  echo "Complete!"
else
  echo "Error occurred, $status_code status received" >&2
  exit 1
fi
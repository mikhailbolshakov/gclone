#!/bin/bash

# parsing named parameters
while [ $# -gt 0 ]; do

  if [[ $1 == "--help" ]]; then

    echo "usage: gclone [--help] [-r repository] [-t token])"
    echo "  --help - print help"
    echo "  -r repository - specify http(s) url to gitlab ripository with backslash"
    echo "  -t token - specify private gitlab token that can be obtain on gitlab account setting page"

    echo 'example: gclone -r "https://gitlab.example.com/" -t 4g-ZxrAXKuJa5kapqsDF'
    echo ""
    echo "WARNING!!! make sure your public SSH key is setup on gitlab profile. Otherwise, you will get authorization error"

    exit 0
  fi

  if [[ $1 == *"-"* ]]; then
    param="${1/-/}"
    declare $param="$2"
  fi

  shift
done

http_repository=$r
private_token=$t

if [ -z "$http_repository" ]; then
  echo "Repository is empty"
  echo "run gclone --help to see how for usage details"
  exit 1
fi

if [ -z "$private_token" ]; then
  echo "Token is empty"
  echo "run gclone --help to see how for usage details"
  exit 1
fi

# build http request to gitlab and extract ssh url of repositories
api_req="${http_repository}api/v4/projects?private_token=${private_token}&per_page=100"
ssh_urls=$(curl -s $api_req \  | jq .[].ssh_url_to_repo | tr -d '"')

# go through all repositories and either clone (if dir doesn't exist) or pull it
for ssh_url in $ssh_urls; do

  repo_dir=$(echo "$ssh_url" | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')

  if [ ! -d "$repo_dir" ]; then
    echo "Cloning repo_dir ( $ssh_url )"
    git clone "$ssh_url"
  else
    echo "Pulling $repo_dir"
    cd "$repo_dir" && git pull && cd ..
  fi

done

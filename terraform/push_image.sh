#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "ERROR: Argument are missing"
    exit 1
fi


IFS="."
read -ra splitted_image_url <<< "$1"
REGION=${splitted_image_url[3]}

IFS="/"
read -ra splitted_image_url <<< "$1"
REPO_NAME=${splitted_image_url[1]}


docker login -u AWS -p "$(aws ecr get-login-password --region $REGION --profile $4)" "$1"

docker build -t "$REPO_NAME" "$2"
docker tag "$REPO_NAME":latest "$1":"$3"

exit_with_code() {
  echo "ERROR: $docker_push"
  ret_code=$?

  if [[ "$docker_push" == *"already exists"* ]]; then
    echo "Expected ERROR. Will exit with 0"
    exit 0
  else
    echo "Unexpected ERROR. Will exit with $ret_code"
    exit $ret_code
  fi
}

trap exit_with_code ERR

echo "Uploading image $1:$3"

docker_push=$(docker push "$1":"$3" 2>&1 > /dev/null)

echo $docker_push

echo "Image uploaded $1:$3"

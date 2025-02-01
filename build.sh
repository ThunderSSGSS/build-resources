#!/bin/bash

if [ ! $2 ]; then
  echo "ERROR: This command needs arguments
Example: $0 <prod_branch> <actual_branch>
"
    exit 1;
fi

export PROD_BRANCH="$1"
export ACTUAL_BRANCH="$2"
export DOCKERFILE_DIR="${DOCKERFILE_DIR:-'.'}"
export VERSION="$(bash ./version.sh)"

cd $DOCKERFILE_DIR

echo "$DOT_ENV" > .env

if [ "$ACTUAL_BRANCH" = "$PROD_BRANCH" ]; then 
  echo "$PROD_DOT_ENV" >> .env; 
else
  echo "$STAGING_DOT_ENV" >> .env; 
fi

docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG_PREFIX}${VERSION}-${ACTUAL_BRANCH} .
echo "IMAGE_REPOSITORY=${DOCKER_USERNAME}/${IMAGE_NAME}" >> build.env
echo "IMAGE_TAG=${IMAGE_TAG_PREFIX}${VERSION}-${ACTUAL_BRANCH}" >> build.env
echo "ID=${RANDOM}" >> build.env
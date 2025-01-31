#!/bin/bash

export DOCKERFILE_DIR="${DOCKERFILE_DIR:-'.'}"
export VERSION="$(./version.sh)"

cd $DOCKERFILE_DIR
echo "$DOT_ENV" > .env

if [ "$IMAGE_TYPE" = "prod" ]; then 
  echo "$PROD_DOT_ENV" >> .env; 
else
  echo "$STAGING_DOT_ENV" >> .env; 
fi

docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG_PREFIX}${VERSION}-${IMAGE_TYPE} .
echo "IMAGE_REPOSITORY=${DOCKER_USERNAME}/${IMAGE_NAME}" >> build.env
echo "IMAGE_TAG=${IMAGE_TAG_PREFIX}${VERSION}-${IMAGE_TYPE}" >> build.env
echo "ID=${RANDOM}" >> build.env
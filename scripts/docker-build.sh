#!/bin/bash
# More safety, by turning some bugs into errors.
#set -o errexit -o pipefail -o noclobber -o nounset

if ! command -v docker &> /dev/null
then
  echo "ERROR: docker isn't installed/can't be found. Make sure you have Docker Desktop installed for your O/S."
  exit 2
fi

usage() {
  echo ""
  echo "Usage: ${0} <docker_org> <image_version> [--push]"
  echo "Example: ${0} my-org 1.0.0"
  exit 1
}

export DOCKER_ORG=$1
export IMAGE_VERSION=$2
export PUSH_IMAGE=$3
export IMAGE_NAME=bootstrap-nginx

if [ -z "${DOCKER_ORG}" ]
then
  echo "ERROR: DOCKER_ORG is required."
  usage
fi

if [ -z "${IMAGE_VERSION}" ]
then
  echo "ERROR: IMAGE_VERSION is required."
  usage
fi

echo ""
echo "===> Provided inputs:"
echo "  DOCKER_ORG: ${DOCKER_ORG}"
echo "  IMAGE_VERSION: ${IMAGE_VERSION}"

echo ""
echo "===> Building image ${DOCKER_ORG}/${IMAGE_NAME}:${IMAGE_VERSION} and latest ..."
docker build --build-arg IMAGE_VERSION --no-cache -t ${DOCKER_ORG}/${IMAGE_NAME}:${IMAGE_VERSION} -t ${DOCKER_ORG}/${IMAGE_NAME}:latest .

if [ "${PUSH_IMAGE}" = "--push" ]; then
  echo ""
  echo "===> Pushing image ${DOCKER_ORG}/${IMAGE_NAME}:${IMAGE_VERSION} and latest ..."
  docker push ${DOCKER_ORG}/${IMAGE_NAME}:${IMAGE_VERSION}
  docker push ${DOCKER_ORG}/${IMAGE_NAME}:latest
fi

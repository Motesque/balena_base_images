#!/bin/bash
ARCH=$1
CONTAINER=$2
REVISION=k
if [[ $WORKSPACE == "" ]]; then
    echo "ERROR: No WORKSPACE set"
    exit 1
fi

set -e
mkdir -p $WORKSPACE/artifacts
cd $WORKSPACE/containers/$CONTAINER

echo "Building Docker Base Image for '$CONTAINER' - '$ARCH'"
# use the last entry as the TAG
DOCKER_TAG=$(grep FROM Dockerfile | tail -n 1 | cut -d : -f 2)$REVISION
docker build -t motesque/$CONTAINER/$ARCH-debian:${DOCKER_TAG} --build-arg ARCH=$ARCH  .

# extract the list with the installed packages
mkdir -p $WORKSPACE/validation/$CONTAINER
docker run --rm  -t motesque/$CONTAINER/$ARCH-debian:${DOCKER_TAG} pip3 freeze > $WORKSPACE/validation/${CONTAINER}/installed_packages_${ARCH}.txt

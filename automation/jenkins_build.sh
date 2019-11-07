#!/bin/bash
ARCH=$1
CONTAINER=$2
REVISION=$(git log |  head -n 1 | cut -f2 -d ' ' | cut -c1-7)
if [[ $WORKSPACE == "" ]]; then
    echo "ERROR: No WORKSPACE set"
    exit 1
fi

set -e
mkdir -p $WORKSPACE/artifacts
cd $WORKSPACE/containers/$CONTAINER

echo "Building Docker Base Image for '$CONTAINER' - '$ARCH'"
# remove the crossbuild commands if needed
if [[ $ARCH == "amd64" ]]; then
    cat Dockerfile.in  | sed -e 's/RUN \[ "cross-build-start" \]//g' -e 's/RUN \[ \"cross-build-end\" \]//g' > Dockerfile
else
    cp Dockerfile.in Dockerfile
fi

# use the last entry as the TAG
DOCKER_TAG=$(grep FROM Dockerfile | tail -n 1 | cut -d : -f 2)-$REVISION
docker build -t motesque/$CONTAINER-$ARCH-debian:${DOCKER_TAG} --build-arg ARCH=$ARCH  .

# extract the list with the installed packages
mkdir -p $WORKSPACE/validation/$CONTAINER
docker run --rm  -t motesque/$CONTAINER-$ARCH-debian:${DOCKER_TAG} pip3 freeze > $WORKSPACE/validation/${CONTAINER}/installed_packages_${ARCH}.txt

#!/bin/bash
THIS_ARCH=$1
THIS_CONTAINER=$2

echo "Building Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"

# use the last entry as the TAG
DOCKER_TAG=$(grep FROM containers/$THIS_CONTAINER/Dockerfile | tail -n 1 | cut -d : -f 2)-git$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION  | cut -c1-7)
echo "DockerTag: $DOCKER_TAG"
docker build -t motesque/codebuild-$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} --build-arg ARCH=$THIS_ARCH  containers/$THIS_CONTAINER/

#echo "Saving Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"
#docker save motesque/codebuild-$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} | gzip > motesque-codebuild-$THIS_CONTAINER-$THIS_ARCH-debian_${DOCKER_TAG}.tar.gz

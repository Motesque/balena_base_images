#!/bin/bash
THIS_ARCH=$1
THIS_CONTAINER=$2

docker login
# use the last entry as the TAG
DOCKER_TAG=$(grep FROM containers/$THIS_CONTAINER/Dockerfile | tail -n 1 | cut -d : -f 2)-git$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION  | cut -c1-7)
echo "Pushing Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"
docker push motesque/codebuild-$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG}

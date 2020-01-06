#!/bin/bash
THIS_ARCH=$1
THIS_CONTAINER=$2

echo "Building Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"

# use the last entry as the TAG
DOCKER_TAG=$(grep FROM containers/$THIS_CONTAINER/Dockerfile | tail -n 1 | cut -d : -f 2)-git$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION  | cut -c1-7)
echo "DockerTag: $DOCKER_TAG"
# pull previous container to allow layer cache
docker pull motesque/$THIS_CONTAINER-$THIS_ARCH-debian:latest || echo "Unable to pull latest image! This is ok..."
docker build -t motesque/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} --cache-from motesque/$THIS_CONTAINER-$THIS_ARCH-debian:latest --build-arg ARCH=$THIS_ARCH  containers/$THIS_CONTAINER/

#echo "Saving Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"
#docker save motesque/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} | gzip > motesque-$THIS_CONTAINER-$THIS_ARCH-debian_latest.tar.gz

#!/bin/bash
THIS_ARCH=$1
THIS_CONTAINER=$2

echo "Creating docker image artifacts for '$THIS_CONTAINER' - '$THIS_ARCH'"
mkdir -p /var/docker-images/
# use the last entry as the TAG
export DOCKER_TAG=$(grep FROM containers/$THIS_CONTAINER/Dockerfile | tail -n 1 | cut -d : -f 2)-git$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION  | cut -c1-7)
docker save motesque/codebuild-$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} | gzip > /var/docker-images/motesque-codebuild-$THIS_CONTAINER-$THIS_ARCH-debian-${DOCKER_TAG}.tar.gz
ls -al /var/docker-images/
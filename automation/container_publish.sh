#!/bin/bash
THIS_ARCH=$1
THIS_CONTAINER=$2
export REPO_BASE=473689091316.dkr.ecr.eu-central-1.amazonaws.com

# use the last entry as the TAG
DOCKER_TAG=$(grep FROM containers/$THIS_CONTAINER/Dockerfile | tail -n 1 | cut -d : -f 2)-git$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION  | cut -c1-7)
echo "Pushing Docker Base Image for '$THIS_CONTAINER' - '$THIS_ARCH'"
docker push base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG}
# push again with latest tag
docker tag base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} base-images/$THIS_CONTAINER-$THIS_ARCH-debian:latest
docker push base-images/$THIS_CONTAINER-$THIS_ARCH-debian:latest
# push to ECR:
docker tag base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} ${REPO_BASE}/base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG}
docker tag base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG} ${REPO_BASE}/base-images/$THIS_CONTAINER-$THIS_ARCH-debian:latest
docker push ${REPO_BASE}/base-images/$THIS_CONTAINER-$THIS_ARCH-debian:${DOCKER_TAG}
docker push ${REPO_BASE}/base-images/$THIS_CONTAINER-$THIS_ARCH-debian:latest

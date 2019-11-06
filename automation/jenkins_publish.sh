# carry over the revision as it is specified in the jenkins_build.sh
REVISION=$(grep REVISION= $WORKSPACE/automation/jenkins_build.sh | cut -d = -f 2)
CONTAINER=$1


dockerUsr=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f1`
cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f2 | docker login -u ${dockerUsr} --password-stdin

echo "     Publishing container $CONTAINER"
cd $WORKSPACE/containers/$CONTAINER
DOCKER_TAG=$(grep FROM Dockerfile | tail -n 1 | cut -d : -f 2)$REVISION
platforms=( "raspberrypi3" "amd64" )
for pl in "${platforms[@]}"
do
    echo "docker push motesque/${CONTAINER}/$pl-debian:${DOCKER_TAG}"
    docker push motesque/${CONTAINER}-$pl-debian:${DOCKER_TAG}
done

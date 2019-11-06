# carry over the revision as it is specified in the jenkins_build.sh

REVISION=$(grep REVISION= $WORKSPACE/automation/jenkins_build.sh | cut -d = -f 2)
containers=( "scopethemove" )
platforms=( "raspberrypi3" "amd64" )

for cont in "${containers[@]}"
do
    diff -q --from-file $WORKSPACE/validation/${cont}/installed_packages_amd64.txt  $WORKSPACE/validation/${cont}/installed_packages_raspberrypi3.txt
done
rc_diff=$?
if [[ $rc_diff != "0" ]]
then
    echo "ERROR - Packet versions across docker base images do not match. Please check."
else
    dockerUsr=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f1`
    echo "OK - Packet version match across all docker base images. Well done!"
    echo "     Publishing..."
    cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f2 | docker login -u ${dockerUsr} --password-stdin
    for cont in "${containers[@]}"
    do
     echo "     Publishing container $cont"
        cd $WORKSPACE/containers/$cont
        DOCKER_TAG=$(grep FROM Dockerfile | tail -n 1 | cut -d : -f 2)$REVISION
        for pl in "${platforms[@]}"
        do
            echo "docker push motesque/${cont}/$pl-debian:${DOCKER_TAG}"
            docker push motesque/${cont}/$pl-debian:${DOCKER_TAG}
        done
    done
fi